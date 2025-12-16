import 'dart:io';
import 'package:mason/mason.dart';

/// Pre-generation hook - runs `flutter create` for desktop platforms only
Future<void> run(HookContext context) async {
  final name = context.vars['name'] as String;
  final org = context.vars['org'] as String;

  context.logger.info('Running flutter create for $name (desktop only)...');

  // Desktop-only platforms for dock app
  final platforms = ['macos', 'linux', 'windows'];

  // Build flutter create arguments
  final args = <String>[
    'create',
    '--org', org,
    '--project-name', name,
    '--platforms', platforms.join(','),
    name,
  ];

  // Run flutter create
  final result = await Process.run(
    'flutter',
    args,
    runInShell: Platform.isWindows,
  );

  if (result.exitCode != 0) {
    context.logger.err('flutter create failed: ${result.stderr}');
    throw Exception('flutter create failed');
  }

  context.logger.success('Flutter project created (desktop platforms)');

  // Delete the lib folder - Mason will replace it with our template
  final libDir = Directory('$name/lib');
  if (libDir.existsSync()) {
    await libDir.delete(recursive: true);
    context.logger.info('Cleared lib directory for template');
  }
}
