import 'package:mason/mason.dart';

/// Pre-generation hook
Future<void> run(HookContext context) async {
  final name = context.vars['name'] as String;
  context.logger.info('Creating server package: ${name}_server');
  // No pre-generation needed for server package
}
