import 'dart:io';
import 'package:mason/mason.dart';

/// Post-generation hook - runs dart pub get and build_runner
Future<void> run(HookContext context) async {
  final name = context.vars['name'] as String;
  final packageDir = '${name}_models';

  context.logger.info('Running dart pub get...');

  // Run pub get
  var result = await Process.run(
    'dart',
    ['pub', 'get'],
    workingDirectory: packageDir,
    runInShell: Platform.isWindows,
  );

  if (result.exitCode != 0) {
    context.logger.warn('dart pub get had warnings: ${result.stderr}');
  } else {
    context.logger.success('Dependencies installed');
  }

  // Run build_runner to generate artifacts
  context.logger.info('Running build_runner to generate code...');
  result = await Process.run(
    'dart',
    ['run', 'build_runner', 'build', '--delete-conflicting-outputs'],
    workingDirectory: packageDir,
    runInShell: Platform.isWindows,
  );

  if (result.exitCode == 0) {
    context.logger.success('Code generation complete');
  } else {
    context.logger.warn('Code generation had issues: ${result.stderr}');
  }

  context.logger.success('Models package setup complete!');
  context.logger.info('');
  context.logger.info('To regenerate after model changes:');
  context.logger.info('  cd $packageDir');
  context.logger.info('  dart run build_runner build --delete-conflicting-outputs');
}
