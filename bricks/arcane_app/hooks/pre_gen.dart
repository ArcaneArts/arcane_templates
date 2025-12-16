import 'dart:io';
import 'package:mason/mason.dart';

/// Pre-generation hook that runs `flutter create` to set up the base project
Future<void> run(HookContext context) async {
  final name = context.vars['name'] as String;
  final org = context.vars['org'] as String;
  final platforms = context.vars['platforms'] as List<dynamic>;

  // Build flutter create command
  final args = <String>[
    'create',
    '--org', org,
    '--project-name', name,
    '--platforms', platforms.join(','),
    name,
  ];

  context.logger.info('Running: flutter ${args.join(' ')}');
  final progress = context.logger.progress('Creating Flutter project');

  final result = await Process.run(
    'flutter',
    args,
    runInShell: Platform.isWindows,
  );

  if (result.exitCode != 0) {
    progress.fail('Flutter create failed');
    context.logger.err(result.stderr.toString());
    throw Exception('flutter create failed with exit code ${result.exitCode}');
  }

  progress.complete('Flutter project created');

  // Delete the generated lib folder - Mason will replace it
  final libDir = Directory('$name/lib');
  if (libDir.existsSync()) {
    context.logger.detail('Removing generated lib/ folder');
    await libDir.delete(recursive: true);
  }

  // Delete the generated test folder
  final testDir = Directory('$name/test');
  if (testDir.existsSync()) {
    context.logger.detail('Removing generated test/ folder');
    await testDir.delete(recursive: true);
  }
}
