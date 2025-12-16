import 'dart:io';
import 'package:mason/mason.dart';

/// Post-generation hook that runs setup tasks
Future<void> run(HookContext context) async {
  final name = context.vars['name'] as String;
  final projectDir = name;

  // Run flutter pub get
  final pubGetProgress = context.logger.progress('Getting dependencies');
  final pubGetResult = await Process.run(
    'flutter',
    ['pub', 'get'],
    workingDirectory: projectDir,
    runInShell: Platform.isWindows,
  );

  if (pubGetResult.exitCode != 0) {
    pubGetProgress.fail('Failed to get dependencies');
    context.logger.err(pubGetResult.stderr.toString());
  } else {
    pubGetProgress.complete('Dependencies installed');
  }

  // Generate launcher icons
  final iconsProgress = context.logger.progress('Generating launcher icons');
  final iconsResult = await Process.run(
    'dart',
    ['run', 'flutter_launcher_icons'],
    workingDirectory: projectDir,
    runInShell: Platform.isWindows,
  );

  if (iconsResult.exitCode != 0) {
    iconsProgress.fail('Failed to generate icons (optional)');
  } else {
    iconsProgress.complete('Launcher icons generated');
  }

  // Generate splash screen
  final splashProgress = context.logger.progress('Generating splash screen');
  final splashResult = await Process.run(
    'dart',
    ['run', 'flutter_native_splash:create'],
    workingDirectory: projectDir,
    runInShell: Platform.isWindows,
  );

  if (splashResult.exitCode != 0) {
    splashProgress.fail('Failed to generate splash (optional)');
  } else {
    splashProgress.complete('Splash screen generated');
  }

  context.logger.success('Project setup complete!');
  context.logger.info('');
  context.logger.info('Next steps:');
  context.logger.info('  cd $name');
  context.logger.info('  flutter run');
}
