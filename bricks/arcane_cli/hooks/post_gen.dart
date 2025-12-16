import 'dart:io';
import 'package:mason/mason.dart';

/// Post-generation hook - runs dart pub get
Future<void> run(HookContext context) async {
  final name = context.vars['name'] as String;

  context.logger.info('Running dart pub get...');

  // Run pub get
  final result = await Process.run(
    'dart',
    ['pub', 'get'],
    workingDirectory: name,
    runInShell: Platform.isWindows,
  );

  if (result.exitCode != 0) {
    context.logger.warn('dart pub get had warnings: ${result.stderr}');
  } else {
    context.logger.success('Dependencies installed');
  }

  context.logger.success('Project setup complete!');
  context.logger.info('');
  context.logger.info('Next steps:');
  context.logger.info('  cd $name');
  context.logger.info('  dart run bin/main.dart --help');
  context.logger.info('');
  context.logger.info('To install globally:');
  context.logger.info('  dart pub global activate . --source=path');
}
