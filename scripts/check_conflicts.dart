#!/usr/bin/env dart
// ignore_for_file: avoid_print
/// Checks for dependency conflicts by running pub get and parsing errors.
///
/// Usage: dart run scripts/check_conflicts.dart
///
/// This script:
/// 1. Builds the reference pubspec from bricks
/// 2. Attempts flutter pub get
/// 3. Parses any conflicts and shows which bricks are affected
/// 4. Suggests resolutions

import 'dart:io';

void main() async {
  print('╔══════════════════════════════════════════════════════════════╗');
  print('║           Dependency Conflict Analyzer                       ║');
  print('╚══════════════════════════════════════════════════════════════╝');
  print('');

  final repoRoot = _findRepoRoot();
  if (repoRoot == null) {
    print('❌ Error: Could not find repository root');
    exit(1);
  }

  // First, build the reference pubspec
  print('📝 Building reference pubspec from bricks...');
  final buildResult = await Process.run(
    'dart',
    ['run', 'scripts/build_reference.dart'],
    workingDirectory: repoRoot,
  );

  if (buildResult.exitCode != 0) {
    print('❌ Failed to build reference pubspec');
    print(buildResult.stderr);
    exit(1);
  }
  print('   Done\n');

  // Try to resolve dependencies
  print('🔍 Analyzing dependencies...');
  final pubResult = await Process.run(
    'flutter',
    ['pub', 'get'],
    workingDirectory: '$repoRoot/reference',
  );

  if (pubResult.exitCode == 0) {
    print('');
    print('════════════════════════════════════════════════════════════════');
    print('✅ All dependencies are compatible!');
    print('');
    print('Run: dart run scripts/sync_from_lock.dart');
    print('to sync resolved versions to bricks.');
    print('════════════════════════════════════════════════════════════════');
    exit(0);
  }

  // Parse the error output
  final error = pubResult.stderr.toString();
  print('');
  print('════════════════════════════════════════════════════════════════');
  print('⚠️  Dependency conflicts detected');
  print('════════════════════════════════════════════════════════════════');
  print('');

  // Extract package names involved in conflict
  final conflictingPackages = _extractConflictingPackages(error);

  // Load brick -> dependency mapping
  final brickDeps = await _loadBrickDependencies(repoRoot);

  // Show which bricks use conflicting packages
  print('Conflicting packages and their usage:');
  print('');

  for (final package in conflictingPackages) {
    final usedBy = brickDeps.entries
        .where((e) => e.value.contains(package))
        .map((e) => e.key)
        .toList();

    if (usedBy.isNotEmpty) {
      print('  📦 $package');
      print('     Used by: ${usedBy.join(", ")}');
    }
  }

  print('');
  print('Full error from pub:');
  print('─' * 60);
  print(error);
  print('─' * 60);
  print('');
  print('Suggested actions:');
  print('  1. Update the conflicting package to a compatible version');
  print('  2. Find an alternative package');
  print('  3. Lock to an older version of the constraining package');
  print('');
}

String? _findRepoRoot() {
  var dir = Directory.current;
  while (dir.path != dir.parent.path) {
    if (Directory('${dir.path}/bricks').existsSync()) {
      return dir.path;
    }
    dir = dir.parent;
  }
  return null;
}

Set<String> _extractConflictingPackages(String error) {
  final packages = <String>{};

  // Match package names in error messages
  // Common patterns:
  // "depends on packagename ^1.0.0"
  // "Because packagename >="
  final patterns = [
    RegExp(r'depends on (\w+) '),
    RegExp(r'Because (\w+) '),
    RegExp(r'requires (\w+) '),
  ];

  for (final pattern in patterns) {
    for (final match in pattern.allMatches(error)) {
      final package = match.group(1);
      if (package != null && !_isCommonWord(package)) {
        packages.add(package);
      }
    }
  }

  return packages;
}

bool _isCommonWord(String word) {
  return ['version', 'solving', 'failed', 'every', 'reference'].contains(word.toLowerCase());
}

Future<Map<String, Set<String>>> _loadBrickDependencies(String repoRoot) async {
  final brickDeps = <String, Set<String>>{};
  final bricksDir = Directory('$repoRoot/bricks');

  await for (final entity in bricksDir.list(recursive: true)) {
    if (entity is File &&
        entity.path.endsWith('pubspec.yaml') &&
        entity.path.contains('__brick__')) {
      final brickName = _extractBrickName(entity.path);
      final content = await entity.readAsString();
      final deps = _extractDependencies(content);
      brickDeps[brickName] = deps;
    }
  }

  return brickDeps;
}

String _extractBrickName(String path) {
  final match = RegExp(r'bricks/([^/]+)/').firstMatch(path);
  return match?.group(1) ?? 'unknown';
}

Set<String> _extractDependencies(String content) {
  final deps = <String>{};
  final depRegex = RegExp(r'^\s{2}(\w+):\s*\^?[\d.]+', multiLine: true);

  for (final match in depRegex.allMatches(content)) {
    deps.add(match.group(1)!);
  }

  return deps;
}
