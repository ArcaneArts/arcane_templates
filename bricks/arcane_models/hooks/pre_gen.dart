import 'package:mason/mason.dart';

/// Pre-generation hook - no flutter create needed for pure Dart models package
Future<void> run(HookContext context) async {
  final name = context.vars['name'] as String;
  context.logger.info('Creating models package: ${name}_models');
  // No pre-generation needed for pure Dart packages
}
