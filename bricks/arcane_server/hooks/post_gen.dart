import 'dart:io';
import 'package:mason/mason.dart';

/// Post-generation hook - runs flutter pub get
Future<void> run(HookContext context) async {
  final name = context.vars['name'] as String;
  final packageDir = '${name}_server';

  context.logger.info('Running flutter pub get...');

  // Run pub get
  final result = await Process.run(
    'flutter',
    ['pub', 'get'],
    workingDirectory: packageDir,
    runInShell: Platform.isWindows,
  );

  if (result.exitCode != 0) {
    context.logger.warn('flutter pub get had warnings: ${result.stderr}');
  } else {
    context.logger.success('Dependencies installed');
  }

  context.logger.success('Server package setup complete!');
  context.logger.info('');
  context.logger.info('Note: The server requires the models package.');
  context.logger.info('Make sure to generate ${name}_models first.');
  context.logger.info('');
  context.logger.info('To deploy:');
  context.logger.info('  cd $packageDir');
  context.logger.info('  oracular deploy server');
}
