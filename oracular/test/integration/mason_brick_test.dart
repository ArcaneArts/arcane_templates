import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  // Find the bricks directory relative to test location
  late String bricksPath;

  setUpAll(() {
    // Try to find bricks directory
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

  group('arcane_app brick', () {
    late String brickPath;

    setUpAll(() {
      brickPath = p.join(bricksPath, 'arcane_app');
    });

    test('brick directory exists', () {
      expect(Directory(brickPath).existsSync(), isTrue);
    });

    test('brick.yaml exists and is valid', () {
      final brickYamlFile = File(p.join(brickPath, 'brick.yaml'));
      expect(brickYamlFile.existsSync(), isTrue);

      final content = brickYamlFile.readAsStringSync();
      final yaml = loadYaml(content);

      expect(yaml['name'], equals('arcane_app'));
      expect(yaml['description'], isNotEmpty);
      expect(yaml['version'], isNotNull);
    });

    test('brick.yaml has required variables', () {
      final brickYamlFile = File(p.join(brickPath, 'brick.yaml'));
      final content = brickYamlFile.readAsStringSync();
      final yaml = loadYaml(content);

      final vars = yaml['vars'] as YamlMap;

      // Check required variables exist
      expect(vars, contains('name'));
      expect(vars, contains('class_name'));
      expect(vars, contains('org'));
      expect(vars, contains('use_firebase'));
    });

    test('brick.yaml variables have correct types', () {
      final brickYamlFile = File(p.join(brickPath, 'brick.yaml'));
      final content = brickYamlFile.readAsStringSync();
      final yaml = loadYaml(content);

      final vars = yaml['vars'] as YamlMap;

      expect(vars['name']['type'], equals('string'));
      expect(vars['class_name']['type'], equals('string'));
      expect(vars['org']['type'], equals('string'));
      expect(vars['use_firebase']['type'], equals('boolean'));
    });

    test('__brick__ directory exists', () {
      final brickDir = Directory(p.join(brickPath, '__brick__'));
      expect(brickDir.existsSync(), isTrue);
    });

    test('__brick__ contains templated project directory', () {
      final brickDir = Directory(p.join(brickPath, '__brick__'));
      final contents = brickDir.listSync();

      // Should have a directory with {{name.snakeCase()}} pattern
      final hasTemplatedDir = contents.any((entity) {
        return entity is Directory &&
            p.basename(entity.path).contains('{{') &&
            p.basename(entity.path).contains('}}');
      });

      expect(hasTemplatedDir, isTrue);
    });

    group('template files', () {
      late String templatePath;

      setUpAll(() {
        templatePath = p.join(brickPath, '__brick__', '{{name.snakeCase()}}');
      });

      test('lib directory exists', () {
        expect(Directory(p.join(templatePath, 'lib')).existsSync(), isTrue);
      });

      test('main.dart exists', () {
        expect(File(p.join(templatePath, 'lib', 'main.dart')).existsSync(), isTrue);
      });

      test('main.dart contains Mustache variables', () {
        final mainDart = File(p.join(templatePath, 'lib', 'main.dart'));
        final content = mainDart.readAsStringSync();

        // Should contain package import with variable
        expect(content, contains('{{name.snakeCase()}}'));
        // Should contain class name variable
        expect(content, contains('{{class_name.pascalCase()}}'));
      });

      test('screens directory exists with required files', () {
        final screensDir = Directory(p.join(templatePath, 'lib', 'screens'));
        expect(screensDir.existsSync(), isTrue);

        expect(
          File(p.join(screensDir.path, 'home_screen.dart')).existsSync(),
          isTrue,
        );
        expect(
          File(p.join(screensDir.path, 'settings_screen.dart')).existsSync(),
          isTrue,
        );
      });

      test('pubspec.yaml exists and contains variables', () {
        final pubspec = File(p.join(templatePath, 'pubspec.yaml'));
        expect(pubspec.existsSync(), isTrue);

        final content = pubspec.readAsStringSync();
        expect(content, contains('{{name.snakeCase()}}'));
        expect(content, contains('{{description}}'));
      });

      test('pubspec.yaml contains Firebase conditional', () {
        final pubspec = File(p.join(templatePath, 'pubspec.yaml'));
        final content = pubspec.readAsStringSync();

        expect(content, contains('{{#use_firebase}}'));
        expect(content, contains('{{/use_firebase}}'));
      });

      test('assets directory exists', () {
        expect(
          Directory(p.join(templatePath, 'assets', 'icon')).existsSync(),
          isTrue,
        );
      });

      test('icon assets exist', () {
        expect(
          File(p.join(templatePath, 'assets', 'icon', 'icon.png')).existsSync(),
          isTrue,
        );
        expect(
          File(p.join(templatePath, 'assets', 'icon', 'splash.png')).existsSync(),
          isTrue,
        );
      });
    });

    group('hooks', () {
      late String hooksPath;

      setUpAll(() {
        hooksPath = p.join(brickPath, 'hooks');
      });

      test('hooks directory exists', () {
        expect(Directory(hooksPath).existsSync(), isTrue);
      });

      test('hooks pubspec.yaml exists', () {
        expect(File(p.join(hooksPath, 'pubspec.yaml')).existsSync(), isTrue);
      });

      test('pre_gen.dart exists', () {
        expect(File(p.join(hooksPath, 'pre_gen.dart')).existsSync(), isTrue);
      });

      test('post_gen.dart exists', () {
        expect(File(p.join(hooksPath, 'post_gen.dart')).existsSync(), isTrue);
      });

      test('pre_gen.dart contains flutter create logic', () {
        final preGen = File(p.join(hooksPath, 'pre_gen.dart'));
        final content = preGen.readAsStringSync();

        expect(content, contains('flutter'));
        expect(content, contains('create'));
        expect(content, contains('run(HookContext context)'));
      });

      test('post_gen.dart contains pub get logic', () {
        final postGen = File(p.join(hooksPath, 'post_gen.dart'));
        final content = postGen.readAsStringSync();

        expect(content, contains('pub'));
        expect(content, contains('get'));
        expect(content, contains('run(HookContext context)'));
      });
    });
  });

  group('brick naming conventions', () {
    test('all brick directories follow naming convention', () {
      final bricksDir = Directory(bricksPath);
      if (!bricksDir.existsSync()) return;

      for (final entity in bricksDir.listSync()) {
        if (entity is Directory) {
          final name = p.basename(entity.path);
          // Skip hidden directories
          if (name.startsWith('.')) continue;

          // Should be snake_case
          expect(
            RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(name),
            isTrue,
            reason: 'Brick "$name" should be snake_case',
          );
        }
      }
    });
  });
}
