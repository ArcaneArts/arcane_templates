import 'dart:io';

import 'package:fast_log/fast_log.dart';

import '../../services/mason_service.dart';
import '../../utils/user_prompt.dart';

/// Handle mason make command - generate a project using Mason bricks
Future<void> handleMasonMake(Map<String, dynamic> args, Map<String, dynamic> flags) async {
  UserPrompt.printBanner(
    'Oracular Mason Generator',
    subtitle: 'Brick-based Template System',
  );

  final brickName = args['brick'] as String? ?? 'arcane_app';
  final outputDir = args['output'] as String? ?? Directory.current.path;

  // Validate brick name
  if (!MasonService.availableBricks.contains(brickName)) {
    error('Unknown brick: $brickName');
    print('Available bricks: ${MasonService.availableBricks.join(", ")}');
    exit(1);
  }

  // Gather variables interactively
  final name = await UserPrompt.askString(
    'Project name (snake_case)',
    defaultValue: 'my_app',
    validator: (s) => RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(s),
    validationMessage: 'Use lowercase letters, numbers, and underscores',
  );

  final className = await UserPrompt.askString(
    'Base class name (PascalCase)',
    defaultValue: _snakeToPascal(name),
  );

  final org = await UserPrompt.askString(
    'Organization domain',
    defaultValue: 'com.example',
  );

  final description = await UserPrompt.askString(
    'Project description',
    defaultValue: 'A new Arcane project',
  );

  final useFirebase = await UserPrompt.askYesNo('Include Firebase?', defaultValue: false);

  String? firebaseProjectId;
  if (useFirebase) {
    firebaseProjectId = await UserPrompt.askString(
      'Firebase project ID',
      validator: (s) => s.isNotEmpty,
    );
  }

  // Show summary
  print('');
  info('Configuration:');
  print('  Brick: $brickName');
  print('  Name: $name');
  print('  Class: $className');
  print('  Org: $org');
  print('  Firebase: ${useFirebase ? "Yes ($firebaseProjectId)" : "No"}');
  print('  Output: $outputDir');
  print('');

  final confirmed = await UserPrompt.askYesNo('Proceed?');
  if (!confirmed) {
    warn('Cancelled');
    return;
  }

  // Generate using Mason
  await MasonService.generate(
    brickName: brickName,
    outputDir: outputDir,
    vars: {
      'name': name,
      'class_name': className,
      'org': org,
      'description': description,
      'use_firebase': useFirebase,
      'firebase_project_id': firebaseProjectId ?? '',
      'platforms': ['android', 'ios', 'web', 'macos', 'linux', 'windows'],
    },
    onProgress: (message) => info(message),
  );

  print('');
  success('Project generated successfully!');
  print('');
  print('Next steps:');
  print('  cd $name');
  print('  flutter run');
}

/// Handle mason list command - list available bricks
Future<void> handleMasonList() async {
  print('');
  print('Available Bricks:');
  print('\u2500' * 50);

  for (final brick in MasonService.availableBricks) {
    final isLocal = MasonService.hasBrickLocally(brick);
    final status = isLocal ? '(local)' : '(remote)';
    print('  \u2022 $brick $status');
  }

  print('');
  print('\u2500' * 50);
  info('Use: oracular mason make --brick <name>');
}

/// Convert snake_case to PascalCase
String _snakeToPascal(String snake) {
  return snake
      .split('_')
      .map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1))
      .join('');
}
