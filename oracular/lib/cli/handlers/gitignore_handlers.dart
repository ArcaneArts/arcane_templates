import 'dart:io';

import 'package:fast_log/fast_log.dart';
import 'package:path/path.dart' as p;

import '../../services/template_downloader.dart';

/// Handle gitignore command - adds the standard .gitignore to current directory
Future<void> handleGitignore(
  Map<String, dynamic> args,
  Map<String, dynamic> flags,
) async {
  final String currentDir = Directory.current.path;
  final String targetPath = p.join(currentDir, '.gitignore');
  final bool force = flags['force'] == true;

  // Check if .gitignore already exists
  final File targetFile = File(targetPath);
  final bool alreadyExists = targetFile.existsSync();

  if (alreadyExists && !force) {
    warn('.gitignore already exists in current directory');
    print('Use --force to overwrite');
    return;
  }

  info('Fetching gitignore template...');

  try {
    // Ensure templates are downloaded (this also downloads gitignore.gitignore)
    await TemplateDownloader.ensureTemplates(
      onProgress: (message) => info(message),
    );

    final File sourceFile = File(TemplateDownloader.gitignoreFile);
    if (!sourceFile.existsSync()) {
      error('gitignore.gitignore not found in cache');
      error('Try running: oracular templates update');
      exit(1);
    }

    // Copy the file
    final String content = await sourceFile.readAsString();
    await targetFile.writeAsString(content);

    if (alreadyExists) {
      success('.gitignore replaced in ${Directory.current.path}');
    } else {
      success('.gitignore added to ${Directory.current.path}');
    }
  } catch (e) {
    error('Failed to add .gitignore: $e');
    exit(1);
  }
}
