import 'dart:io';

import 'package:archive/archive.dart';
import 'package:fast_log/fast_log.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

/// Service for downloading and caching templates from GitHub
class TemplateDownloader {
  /// GitHub repository for templates
  static const String _repoOwner = 'ArcaneArts';
  static const String _repoName = 'oracular';
  static const String _branch = 'master';

  /// Local cache directory name
  static const String _cacheDirName = '.oracular';
  static const String _templatesDirName = 'templates';
  static const String _versionFileName = '.version';

  /// Get the cache directory path
  static String get cacheDir {
    final String home = Platform.environment['HOME'] ??
        Platform.environment['USERPROFILE'] ??
        '.';
    return p.join(home, _cacheDirName);
  }

  /// Get the templates directory path within the cache
  static String get templatesDir => p.join(cacheDir, _templatesDirName);

  /// Get the version file path
  static String get versionFile => p.join(cacheDir, _versionFileName);

  /// Check if templates are cached locally
  static bool get hasCachedTemplates {
    final Directory dir = Directory(templatesDir);
    return dir.existsSync() && dir.listSync().isNotEmpty;
  }

  /// Get the cached version (commit SHA or tag)
  static String? get cachedVersion {
    final File file = File(versionFile);
    if (file.existsSync()) {
      return file.readAsStringSync().trim();
    }
    return null;
  }

  /// Get the latest commit SHA from GitHub
  static Future<String?> getLatestVersion() async {
    try {
      final Uri uri = Uri.parse(
        'https://api.github.com/repos/$_repoOwner/$_repoName/commits/$_branch',
      );
      final http.Response response = await http.get(
        uri,
        headers: {'Accept': 'application/vnd.github.v3+json'},
      );

      if (response.statusCode == 200) {
        // Extract SHA from response - simple parsing without json dependency
        final String body = response.body;
        final RegExp shaRegex = RegExp(r'"sha"\s*:\s*"([a-f0-9]{40})"');
        final Match? match = shaRegex.firstMatch(body);
        return match?.group(1);
      }
    } catch (e) {
      warn('Failed to check latest version: $e');
    }
    return null;
  }

  /// Check if templates need to be updated
  static Future<bool> needsUpdate() async {
    if (!hasCachedTemplates) return true;

    final String? cached = cachedVersion;
    if (cached == null) return true;

    final String? latest = await getLatestVersion();
    if (latest == null) {
      // Can't check, assume cached is fine
      return false;
    }

    return cached != latest;
  }

  /// Download and extract templates from GitHub
  /// Returns the path to the templates directory
  static Future<String> downloadTemplates({
    bool force = false,
    void Function(String message)? onProgress,
  }) async {
    // Check if we need to download
    if (!force && hasCachedTemplates) {
      final bool shouldUpdate = await needsUpdate();
      if (!shouldUpdate) {
        onProgress?.call('Using cached templates');
        return templatesDir;
      }
      onProgress?.call('Updating templates...');
    } else {
      onProgress?.call('Downloading templates...');
    }

    // Create cache directory
    final Directory cacheDirectory = Directory(cacheDir);
    if (!cacheDirectory.existsSync()) {
      await cacheDirectory.create(recursive: true);
    }

    // Download the repository archive
    final String archiveUrl =
        'https://github.com/$_repoOwner/$_repoName/archive/refs/heads/$_branch.zip';

    onProgress?.call('Fetching from GitHub...');
    info('Downloading templates from: $archiveUrl');

    final http.Response response = await http.get(Uri.parse(archiveUrl));

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to download templates: HTTP ${response.statusCode}',
      );
    }

    onProgress?.call('Extracting templates...');

    // Decode the zip archive
    final Archive archive = ZipDecoder().decodeBytes(response.bodyBytes);

    // Clear existing templates directory
    final Directory templatesDirectory = Directory(templatesDir);
    if (templatesDirectory.existsSync()) {
      await templatesDirectory.delete(recursive: true);
    }
    await templatesDirectory.create(recursive: true);

    // Extract only the templates/ folder from the archive
    // Archive structure: oracular-master/templates/...
    final String archivePrefix = '$_repoName-$_branch/templates/';

    int extractedCount = 0;
    for (final ArchiveFile file in archive) {
      if (!file.name.startsWith(archivePrefix)) continue;

      // Get relative path within templates/
      final String relativePath = file.name.substring(archivePrefix.length);
      if (relativePath.isEmpty) continue;

      final String targetPath = p.join(templatesDir, relativePath);

      if (file.isFile) {
        final File outFile = File(targetPath);
        await outFile.parent.create(recursive: true);
        await outFile.writeAsBytes(file.content as List<int>);
        extractedCount++;
      } else {
        await Directory(targetPath).create(recursive: true);
      }
    }

    // Save the version
    final String? version = await getLatestVersion();
    if (version != null) {
      await File(versionFile).writeAsString(version);
    }

    onProgress?.call('Extracted $extractedCount files');
    success('Templates downloaded to: $templatesDir');

    return templatesDir;
  }

  /// Ensure templates are available (download if needed)
  /// This is the main entry point for other services
  static Future<String> ensureTemplates({
    void Function(String message)? onProgress,
  }) async {
    try {
      return await downloadTemplates(onProgress: onProgress);
    } catch (e) {
      // If download fails but we have cached templates, use them
      if (hasCachedTemplates) {
        warn('Failed to update templates, using cached version: $e');
        return templatesDir;
      }
      rethrow;
    }
  }

  /// Clear the template cache
  static Future<void> clearCache() async {
    final Directory templatesDirectory = Directory(templatesDir);
    if (templatesDirectory.existsSync()) {
      await templatesDirectory.delete(recursive: true);
      info('Template cache cleared');
    }

    final File version = File(versionFile);
    if (version.existsSync()) {
      await version.delete();
    }
  }
}
