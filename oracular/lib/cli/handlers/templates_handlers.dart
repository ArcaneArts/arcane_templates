import 'dart:io';

import 'package:fast_log/fast_log.dart';

import '../../services/template_downloader.dart';

/// Handle templates update command
Future<void> handleTemplatesUpdate() async {
  info('Updating templates from GitHub...');

  try {
    await TemplateDownloader.downloadTemplates(
      force: true,
      onProgress: (message) => info(message),
    );
    success('Templates updated successfully!');
  } catch (e) {
    error('Failed to update templates: $e');
    exit(1);
  }
}

/// Handle templates clear command
Future<void> handleTemplatesClear() async {
  info('Clearing template cache...');

  await TemplateDownloader.clearCache();
  success('Template cache cleared!');
}

/// Handle templates path command
Future<void> handleTemplatesPath() async {
  print('Cache directory: ${TemplateDownloader.cacheDir}');
  print('Templates path: ${TemplateDownloader.templatesDir}');

  if (TemplateDownloader.hasCachedTemplates) {
    final version = TemplateDownloader.cachedVersion;
    print('Cached version: ${version ?? 'unknown'}');
    print('Status: Templates are cached');
  } else {
    print('Status: No cached templates');
  }
}

/// Handle templates status command
Future<void> handleTemplatesStatus() async {
  print('');
  print('Template Cache Status');
  print('─────────────────────');
  print('Cache location: ${TemplateDownloader.cacheDir}');
  print('');

  if (TemplateDownloader.hasCachedTemplates) {
    final version = TemplateDownloader.cachedVersion;
    success('✓ Templates are cached');
    print('  Version: ${version?.substring(0, 7) ?? 'unknown'}');

    // Check if update is available
    info('Checking for updates...');
    final needsUpdate = await TemplateDownloader.needsUpdate();
    if (needsUpdate) {
      warn('  Update available! Run: oracular templates update');
    } else {
      success('  Templates are up to date');
    }
  } else {
    warn('✗ No cached templates');
    print('  Run: oracular templates update');
  }
  print('');
}
