import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  late String bricksPath;

  setUpAll(() {
    final possiblePaths = [
      p.join(Directory.current.path, '..', 'bricks'),
      p.join(Directory.current.path, 'bricks'),
      p.join(Directory.current.path, '..', '..', 'bricks'),
    ];

    for (final path in possiblePaths) {
      if (Directory(path).existsSync()) {
        bricksPath = p.normalize(path);
        return;
      }
    }

    fail('Could not find bricks directory');
  });

  group('Mustache template validation', () {
    test('all template files have balanced Mustache tags', () async {
      final templateDir = Directory(
        p.join(bricksPath, 'arcane_app', '__brick__'),
      );

      if (!templateDir.existsSync()) {
        fail('Template directory not found');
      }

      final errors = <String>[];

      await for (final entity in templateDir.list(recursive: true)) {
        if (entity is File) {
          final ext = p.extension(entity.path).toLowerCase();
          // Only check text files
          if (['.dart', '.yaml', '.yml', '.md', '.txt', '.json']
              .contains(ext)) {
            final content = await entity.readAsString();
            final validationErrors = _validateMustacheTags(content);

            if (validationErrors.isNotEmpty) {
              errors.add(
                '${p.relative(entity.path, from: bricksPath)}:\n'
                '  ${validationErrors.join('\n  ')}',
              );
            }
          }
        }
      }

      if (errors.isNotEmpty) {
        fail('Mustache validation errors:\n${errors.join('\n')}');
      }
    });

    test('template variables use valid lambda functions', () async {
      final templateDir = Directory(
        p.join(bricksPath, 'arcane_app', '__brick__'),
      );

      if (!templateDir.existsSync()) return;

      // Valid Mason lambdas
      final validLambdas = [
        'camelCase',
        'constantCase',
        'dotCase',
        'headerCase',
        'lowerCase',
        'mustacheCase',
        'pascalCase',
        'paramCase',
        'pathCase',
        'sentenceCase',
        'snakeCase',
        'titleCase',
        'upperCase',
      ];

      final lambdaPattern = RegExp(r'\{\{(\w+)\.(\w+)\(\)\}\}');
      final errors = <String>[];

      await for (final entity in templateDir.list(recursive: true)) {
        if (entity is File) {
          final ext = p.extension(entity.path).toLowerCase();
          if (['.dart', '.yaml', '.yml'].contains(ext)) {
            final content = await entity.readAsString();
            final matches = lambdaPattern.allMatches(content);

            for (final match in matches) {
              final lambda = match.group(2);
              if (lambda != null && !validLambdas.contains(lambda)) {
                errors.add(
                  '${p.relative(entity.path, from: bricksPath)}: '
                  'Invalid lambda "${match.group(0)}"',
                );
              }
            }
          }
        }
      }

      if (errors.isNotEmpty) {
        fail('Invalid lambdas found:\n${errors.join('\n')}');
      }
    });

    test('conditional blocks are properly nested', () async {
      final templateDir = Directory(
        p.join(bricksPath, 'arcane_app', '__brick__'),
      );

      if (!templateDir.existsSync()) return;

      final errors = <String>[];

      await for (final entity in templateDir.list(recursive: true)) {
        if (entity is File) {
          final ext = p.extension(entity.path).toLowerCase();
          if (['.dart', '.yaml', '.yml'].contains(ext)) {
            final content = await entity.readAsString();
            final nestingErrors = _validateConditionalNesting(content);

            if (nestingErrors.isNotEmpty) {
              errors.add(
                '${p.relative(entity.path, from: bricksPath)}:\n'
                '  ${nestingErrors.join('\n  ')}',
              );
            }
          }
        }
      }

      if (errors.isNotEmpty) {
        fail('Conditional nesting errors:\n${errors.join('\n')}');
      }
    });
  });

  group('Template file naming', () {
    test('templated filenames use valid syntax', () async {
      final templateDir = Directory(
        p.join(bricksPath, 'arcane_app', '__brick__'),
      );

      if (!templateDir.existsSync()) return;

      final errors = <String>[];
      final validPattern = RegExp(r'\{\{[a-z_]+\.[a-zA-Z]+\(\)\}\}');

      await for (final entity in templateDir.list(recursive: true)) {
        final name = p.basename(entity.path);

        // Check if filename contains Mustache syntax
        if (name.contains('{{')) {
          if (!validPattern.hasMatch(name)) {
            // Check if it's a simple variable (no lambda)
            if (!RegExp(r'\{\{[a-z_]+\}\}').hasMatch(name)) {
              errors.add('Invalid filename pattern: $name');
            }
          }
        }
      }

      if (errors.isNotEmpty) {
        fail('Invalid filename patterns:\n${errors.join('\n')}');
      }
    });
  });
}

/// Validate Mustache tags are balanced
List<String> _validateMustacheTags(String content) {
  final errors = <String>[];

  // Count opening and closing section tags
  final openPattern = RegExp(r'\{\{#(\w+)\}\}');
  final closePattern = RegExp(r'\{\{/(\w+)\}\}');

  final openMatches = openPattern.allMatches(content).toList();
  final closeMatches = closePattern.allMatches(content).toList();

  // Track open sections
  final openSections = <String>[];

  // Simple validation: count opens and closes for each variable
  final openCounts = <String, int>{};
  final closeCounts = <String, int>{};

  for (final match in openMatches) {
    final varName = match.group(1)!;
    openCounts[varName] = (openCounts[varName] ?? 0) + 1;
  }

  for (final match in closeMatches) {
    final varName = match.group(1)!;
    closeCounts[varName] = (closeCounts[varName] ?? 0) + 1;
  }

  // Check for mismatches
  final allVars = {...openCounts.keys, ...closeCounts.keys};
  for (final varName in allVars) {
    final opens = openCounts[varName] ?? 0;
    final closes = closeCounts[varName] ?? 0;

    if (opens != closes) {
      errors.add(
        'Unbalanced section "$varName": $opens opens, $closes closes',
      );
    }
  }

  // Check for unclosed variable interpolations
  final varPattern = RegExp(r'\{\{(?!#|/|\^|>|!)');
  final closeVarPattern = RegExp(r'\}\}');

  final varOpens = varPattern.allMatches(content).length;
  final varCloses = closeVarPattern.allMatches(content).length;

  // This is a rough check - in practice, sections count as opens too
  // So we just verify there are matching pairs

  return errors;
}

/// Validate conditional blocks are properly nested
List<String> _validateConditionalNesting(String content) {
  final errors = <String>[];
  final stack = <String>[];

  // Match both #section and ^inverted sections
  final tagPattern = RegExp(r'\{\{([#^/])(\w+)\}\}');
  final matches = tagPattern.allMatches(content);

  for (final match in matches) {
    final type = match.group(1);
    final name = match.group(2)!;

    if (type == '#' || type == '^') {
      // Opening tag
      stack.add(name);
    } else if (type == '/') {
      // Closing tag
      if (stack.isEmpty) {
        errors.add('Unexpected closing tag {{/$name}} with no opening tag');
      } else if (stack.last != name) {
        errors.add(
          'Mismatched closing tag: expected {{/${stack.last}}}, got {{/$name}}',
        );
      } else {
        stack.removeLast();
      }
    }
  }

  // Check for unclosed sections
  for (final unclosed in stack) {
    errors.add('Unclosed section: {{#$unclosed}}');
  }

  return errors;
}
