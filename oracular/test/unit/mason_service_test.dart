import 'dart:io';

import 'package:oracular/services/mason_service.dart';
import 'package:test/test.dart';

void main() {
  group('MasonService', () {
    group('brickNames', () {
      test('contains all expected brick names', () {
        expect(MasonService.brickNames, contains('arcane_app'));
        expect(MasonService.brickNames, contains('arcane_beamer'));
        expect(MasonService.brickNames, contains('arcane_dock'));
        expect(MasonService.brickNames, contains('arcane_cli'));
        expect(MasonService.brickNames, contains('arcane_models'));
        expect(MasonService.brickNames, contains('arcane_server'));
      });

      test('has 6 brick types', () {
        expect(MasonService.brickNames.length, equals(6));
      });
    });

    group('availableBricks', () {
      test('returns list of brick names', () {
        final bricks = MasonService.availableBricks;

        expect(bricks, isA<List<String>>());
        expect(bricks, isNotEmpty);
        expect(bricks, contains('arcane_app'));
      });

      test('matches brickNames keys', () {
        expect(
          MasonService.availableBricks,
          equals(MasonService.brickNames.keys.toList()),
        );
      });
    });

    group('hasBrickLocally', () {
      test('returns true for arcane_app when in repo', () {
        // This test assumes we're running from the oracular directory
        // and the bricks folder exists
        final bricksDir = Directory('${Directory.current.path}/../bricks/arcane_app');

        if (bricksDir.existsSync()) {
          // Can only test this when running from the right directory
          expect(MasonService.hasBrickLocally('arcane_app'), isTrue);
        }
      });

      test('returns false for non-existent brick', () {
        expect(MasonService.hasBrickLocally('non_existent_brick'), isFalse);
      });
    });
  });
}
