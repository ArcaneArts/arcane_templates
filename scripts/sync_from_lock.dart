#!/usr/bin/env dart
// ignore_for_file: avoid_print
/// Syncs RESOLVED dependency versions from reference/pubspec.lock to all bricks
///
/// This approach ensures all dependencies are compatible because they come from
/// an actual pub resolution (not just latest from pub.dev).
///
/// Workflow:
///   1. cd reference/
///   2. flutter pub upgrade              # Or flutter pub upgrade --major-versions
///   3. flutter pub get                  # Verify resolution
///   4. cd ..
///   5. dart run scripts/sync_from_lock.dart
///
/// The script reads the RESOLVED versions from pubspec.lock and updates bricks.

import 'dart:io';

void main(List<String> args) async {
  final dryRun = args.contains('--dry') || args.contains('--dry-run');

  print('╔══════════════════════════════════════════════════════════════╗');
  print('║     Sync Resolved Versions from pubspec.lock to Bricks       ║');
  print('╚══════════════════════════════════════════════════════════════╝');
  print('');
  if (dryRun) print('📋 Dry run - no files will be modified\n');

  final repoRoot = _findRepoRoot();
  if (repoRoot == null) {
    print('❌ Error: Could not find repository root');
    exit(1);
  }

  final lockFile = File('$repoRoot/reference/pubspec.lock');
  if (!lockFile.existsSync()) {
    print('❌ Error: reference/pubspec.lock not found');
    print('');
    print('Run these commands first:');
    print('  cd reference/');
    print('  flutter pub upgrade');
    print('  cd ..');
    exit(1);
  }

  // Parse pubspec.lock to get resolved versions
  print('📖 Reading reference/pubspec.lock...');
  final lockContent = await lockFile.readAsString();
  final resolvedVersions = _parseLockFile(lockContent);
  print('   Found ${resolvedVersions.length} resolved packages');
  print('');

  // Find all brick pubspecs
  final bricksDir = Directory('$repoRoot/bricks');
  final brickPubspecs = <File>[];

  await for (final entity in bricksDir.list(recursive: true)) {
    if (entity is File &&
        entity.path.endsWith('pubspec.yaml') &&
        entity.path.contains('__brick__')) {
      brickPubspecs.add(entity);
    }
  }

  print('🔍 Found ${brickPubspecs.length} brick pubspecs');
  print('');

  // Update each brick pubspec
  print('📝 ${dryRun ? "Previewing" : "Updating"} brick pubspecs...');
  var totalChanges = 0;

  for (final pubspec in brickPubspecs) {
    final relativePath = pubspec.path.replaceFirst('$repoRoot/', '');
    final content = await pubspec.readAsString();
    final result = _updateVersions(content, resolvedVersions);

    if (result.changes > 0) {
      if (!dryRun) {
        await pubspec.writeAsString(result.content);
      }
      print('');
      print('${dryRun ? "📋" : "✅"} $relativePath (${result.changes} updates)');
      for (final change in result.changeDetails) {
        print('   • $change');
      }
      totalChanges += result.changes;
    }
  }

  print('');
  print('════════════════════════════════════════════════════════════════');
  if (dryRun) {
    print('📋 Would update $totalChanges dependencies across ${brickPubspecs.length} files');
  } else {
    print('✅ Updated $totalChanges dependencies across ${brickPubspecs.length} files');
  }
  print('');
  print('These versions are guaranteed compatible (from pub resolution)');
  print('════════════════════════════════════════════════════════════════');
}

String? _findRepoRoot() {
  var dir = Directory.current;
  while (dir.path != dir.parent.path) {
    if (Directory('${dir.path}/bricks').existsSync() &&
        Directory('${dir.path}/reference').existsSync()) {
      return dir.path;
    }
    dir = dir.parent;
  }
  return null;
}

/// Parse pubspec.lock to extract package versions
/// Lock file format:
/// packages:
///   package_name:
///     dependency: ...
///     version: "1.2.3"
Map<String, String> _parseLockFile(String content) {
  final versions = <String, String>{};
  final lines = content.split('\n');

  String? currentPackage;

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];

    // Match package name (2 spaces indent, ends with :)
    final packageMatch = RegExp(r'^  (\w+):$').firstMatch(line);
    if (packageMatch != null) {
      currentPackage = packageMatch.group(1);
      continue;
    }

    // Match version line (4 spaces indent)
    if (currentPackage != null) {
      final versionMatch = RegExp(r'^    version: "(.+)"$').firstMatch(line);
      if (versionMatch != null) {
        versions[currentPackage] = '^${versionMatch.group(1)}';
        currentPackage = null;
      }
    }
  }

  return versions;
}

/// Update versions in pubspec content using resolved versions
_UpdateResult _updateVersions(String content, Map<String, String> resolvedVersions) {
  final changes = <String>[];
  var updatedContent = content;

  final depRegex = RegExp(r'^(\s{2})(\w+):\s*(\^?[\d.]+|any)\s*$', multiLine: true);

  updatedContent = content.replaceAllMapped(depRegex, (match) {
    final indent = match.group(1)!;
    final package = match.group(2)!;
    final oldVersion = match.group(3)!;

    if (resolvedVersions.containsKey(package)) {
      final newVersion = resolvedVersions[package]!;
      if (oldVersion != newVersion) {
        changes.add('$package: $oldVersion → $newVersion');
        return '$indent$package: $newVersion';
      }
    }

    return match.group(0)!;
  });

  return _UpdateResult(
    content: updatedContent,
    changes: changes.length,
    changeDetails: changes,
  );
}

class _UpdateResult {
  final String content;
  final int changes;
  final List<String> changeDetails;

  _UpdateResult({
    required this.content,
    required this.changes,
    required this.changeDetails,
  });
}
