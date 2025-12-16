import 'dart:io';
import 'package:mason/mason.dart';

/// Post-generation hook - runs pub get and asset generation
Future<void> run(HookContext context) async {
  final name = context.vars['name'] as String;

  context.logger.info('Running flutter pub get...');

  // Run pub get
  var result = await Process.run(
    'flutter',
    ['pub', 'get'],
    workingDirectory: name,
    runInShell: Platform.isWindows,
  );

  if (result.exitCode != 0) {
    context.logger.warn('flutter pub get had warnings: ${result.stderr}');
  } else {
    context.logger.success('Dependencies installed');
  }

  // Generate launcher icons
  context.logger.info('Generating launcher icons...');
  result = await Process.run(
    'dart',
    ['run', 'flutter_launcher_icons'],
    workingDirectory: name,
    runInShell: Platform.isWindows,
  );

  if (result.exitCode == 0) {
    context.logger.success('Launcher icons generated');
  }

  context.logger.success('Project setup complete!');
  context.logger.info('Note: See PLATFORM_SETUP.md for platform-specific configuration');
}
