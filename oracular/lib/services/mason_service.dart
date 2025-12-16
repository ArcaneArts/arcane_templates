import 'dart:io';

import 'package:fast_log/fast_log.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;

/// Service for generating projects using Mason bricks
class MasonService {
  /// GitHub repository for bricks
  static const String _repoOwner = 'ArcaneArts';
  static const String _repoName = 'oracular';
  static const String _branch = 'master';
  static const String _bricksPath = 'bricks';

  /// Available brick types
  static const Map<String, String> brickNames = {
    'arcane_app': 'arcane_app',
    'arcane_beamer': 'arcane_beamer',
    'arcane_dock': 'arcane_dock',
    'arcane_cli': 'arcane_cli',
    'arcane_models': 'arcane_models',
    'arcane_server': 'arcane_server',
  };

  /// Generate a project from a brick
  ///
  /// [brickName] - Name of the brick to use (e.g., 'arcane_app')
  /// [outputDir] - Directory where the project will be created
  /// [vars] - Variables to pass to the brick template
  /// [onProgress] - Optional callback for progress updates
  static Future<void> generate({
    required String brickName,
    required String outputDir,
    required Map<String, dynamic> vars,
    void Function(String message)? onProgress,
  }) async {
    // First try local bricks (for development)
    Brick brick;
    final localBrickPath = _findLocalBrick(brickName);

    if (localBrickPath != null) {
      onProgress?.call('Using local brick: $brickName');
      brick = Brick.path(localBrickPath);
    } else {
      // Fall back to git
      onProgress?.call('Fetching brick from GitHub: $brickName');
      brick = Brick.git(
        GitPath(
          'https://github.com/$_repoOwner/$_repoName',
          path: '$_bricksPath/$brickName',
          ref: _branch,
        ),
      );
    }

    onProgress?.call('Loading template...');
    final generator = await MasonGenerator.fromBrick(brick);

    // Ensure output directory exists
    final targetDir = Directory(outputDir);
    if (!targetDir.existsSync()) {
      await targetDir.create(recursive: true);
    }

    final target = DirectoryGeneratorTarget(targetDir);
    var variables = Map<String, dynamic>.from(vars);

    // Run pre-gen hook (this runs flutter create)
    onProgress?.call('Running pre-generation setup...');
    try {
      await generator.hooks.preGen(
        vars: variables,
        workingDirectory: outputDir,
        onVarsChanged: (v) => variables = v,
      );
    } catch (e) {
      warn('Pre-gen hook error (may be expected): $e');
    }

    // Generate template files
    onProgress?.call('Generating project files...');
    final files = await generator.generate(target, vars: variables);
    onProgress?.call('Generated ${files.length} files');

    // Run post-gen hook (this runs pub get, etc.)
    onProgress?.call('Running post-generation setup...');
    try {
      await generator.hooks.postGen(
        vars: variables,
        workingDirectory: outputDir,
      );
    } catch (e) {
      warn('Post-gen hook error (may be expected): $e');
    }

    success('Project generated successfully!');
  }

  /// Generate a project using SetupConfig (for compatibility)
  static Future<void> generateFromConfig({
    required dynamic config, // SetupConfig
    void Function(String message)? onProgress,
  }) async {
    // Map template type to brick name
    final brickName = _getBrickName(config.template);

    await generate(
      brickName: brickName,
      outputDir: config.outputDir,
      vars: {
        'name': config.appName,
        'class_name': config.baseClassName,
        'org': config.orgDomain,
        'description': 'A new Arcane project',
        'use_firebase': config.useFirebase,
        'firebase_project_id': config.firebaseProjectId ?? '',
        'platforms': config.platforms,
      },
      onProgress: onProgress,
    );
  }

  /// Find local brick path for development
  static String? _findLocalBrick(String brickName) {
    final scriptPath = Platform.script.toFilePath();
    final scriptDir = p.dirname(scriptPath);

    // Check various possible locations
    final possiblePaths = <String>[
      // When running from oracular/ directory
      p.join(scriptDir, '..', '..', 'bricks', brickName),
      // When running from Oracular monorepo root
      p.join(Directory.current.path, 'bricks', brickName),
      // Sibling to current directory
      p.join(Directory.current.path, '..', 'bricks', brickName),
    ];

    for (final path in possiblePaths) {
      final normalizedPath = p.normalize(path);
      final brickYaml = File(p.join(normalizedPath, 'brick.yaml'));
      if (brickYaml.existsSync()) {
        verbose('Found local brick at: $normalizedPath');
        return normalizedPath;
      }
    }

    return null;
  }

  /// Map template type enum to brick name
  static String _getBrickName(dynamic templateType) {
    // templateType is TemplateType enum
    final typeName = templateType.toString().split('.').last;

    return switch (typeName) {
      'arcaneTemplate' => 'arcane_app',
      'arcaneBeamer' => 'arcane_beamer',
      'arcaneDock' => 'arcane_dock',
      'arcaneCli' => 'arcane_cli',
      _ => 'arcane_app',
    };
  }

  /// Check if a brick is available locally
  static bool hasBrickLocally(String brickName) {
    return _findLocalBrick(brickName) != null;
  }

  /// List available bricks
  static List<String> get availableBricks => brickNames.keys.toList();
}
