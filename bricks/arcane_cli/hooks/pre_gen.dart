import 'package:mason/mason.dart';

/// Pre-generation hook - no flutter create needed for pure Dart CLI
Future<void> run(HookContext context) async {
  final name = context.vars['name'] as String;
  context.logger.info('Creating Dart CLI project: $name');
  // No pre-generation needed for pure Dart projects
  // Mason will create the directory structure
}
