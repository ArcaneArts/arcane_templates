# How to Make Mason Bricks

This guide explains how to create Mason bricks for the Oracular template system. We'll use `arcane_app` as a detailed example.

## Table of Contents

1. [What is a Mason Brick?](#what-is-a-mason-brick)
2. [Brick Structure](#brick-structure)
3. [The brick.yaml File](#the-brickyaml-file)
4. [Mustache Templating](#mustache-templating)
5. [Hooks (Pre/Post Generation)](#hooks-prepost-generation)
6. [Creating Your First Brick](#creating-your-first-brick)
7. [The arcane_app Brick Explained](#the-arcane_app-brick-explained)
8. [Testing Your Brick](#testing-your-brick)
9. [Dependency Management](#dependency-management)
10. [Best Practices](#best-practices)

---

## What is a Mason Brick?

A Mason brick is a template that generates project files using [Mustache](https://mustache.github.io/) syntax for variable substitution. Mason is the templating engine used by Dart/Flutter for code generation.

**Key concepts:**
- **Variables** - Values provided by the user (e.g., project name, organization)
- **Mustache syntax** - `{{variable}}` placeholders that get replaced
- **Hooks** - Dart scripts that run before/after generation
- **Lambdas** - Built-in transformations like `{{name.snakeCase()}}`

---

## Brick Structure

Every brick follows this structure:

```
my_brick/
├── brick.yaml              # Brick configuration and variables
├── README.md               # Documentation for the brick
├── __brick__/              # Template files (REQUIRED)
│   └── {{name.snakeCase()}}/   # Output directory (uses variables)
│       ├── lib/
│       ├── pubspec.yaml
│       └── ...
└── hooks/                  # Optional pre/post generation scripts
    ├── pubspec.yaml        # Dependencies for hooks
    ├── pre_gen.dart        # Runs BEFORE file generation
    └── post_gen.dart       # Runs AFTER file generation
```

### Important Notes

- The `__brick__/` directory is **required** - Mason copies everything inside it
- Directory and file names can use Mustache variables: `{{name.snakeCase()}}`
- The hooks directory is optional but useful for running commands

---

## The brick.yaml File

The `brick.yaml` file defines your brick's metadata and variables.

### Example: arcane_app/brick.yaml

```yaml
name: arcane_app
description: Multi-platform Flutter application with Arcane UI framework
version: 1.0.0
environment:
  mason: ">=0.1.0-dev.58 <0.1.0"

# Repository information (for remote bricks)
repository: https://github.com/ArcaneArts/oracular

vars:
  # Required variables
  name:
    type: string
    description: Project name in snake_case
    prompt: What is the project name?

  class_name:
    type: string
    description: Base class name in PascalCase
    prompt: What is the base class name?

  org:
    type: string
    description: Organization domain (e.g., com.example)
    default: com.example
    prompt: What is your organization domain?

  description:
    type: string
    description: Project description
    default: A new Arcane application
    prompt: Describe your project

  # Boolean variables (conditionals)
  use_firebase:
    type: boolean
    description: Include Firebase integration
    default: false
    prompt: Include Firebase?

  firebase_project_id:
    type: string
    description: Firebase project ID
    default: ""
    prompt: Firebase project ID (if using Firebase)

  # Array variables
  platforms:
    type: array
    description: Target platforms
    default: [android, ios, web, macos, linux, windows]
    prompt: Which platforms?
```

### Variable Types

| Type | Description | Example |
|------|-------------|---------|
| `string` | Text value | `"my_app"` |
| `boolean` | True/false | `true` |
| `array` | List of values | `[android, ios, web]` |
| `number` | Numeric value | `42` |

---

## Mustache Templating

Mustache is a logic-less templating language. Here's how to use it:

### Variable Substitution

```dart
// In template file:
import 'package:{{name.snakeCase()}}/main.dart';

class {{class_name.pascalCase()}}App extends StatelessWidget {
  // ...
}

// Output (with name="my_app", class_name="MyApp"):
import 'package:my_app/main.dart';

class MyAppApp extends StatelessWidget {
  // ...
}
```

### Built-in Lambdas (Transformations)

Mason provides these transformations:

| Lambda | Input | Output |
|--------|-------|--------|
| `{{name.camelCase()}}` | `my_app` | `myApp` |
| `{{name.pascalCase()}}` | `my_app` | `MyApp` |
| `{{name.snakeCase()}}` | `MyApp` | `my_app` |
| `{{name.titleCase()}}` | `my_app` | `My App` |
| `{{name.constantCase()}}` | `my_app` | `MY_APP` |
| `{{name.paramCase()}}` | `MyApp` | `my-app` |
| `{{name.dotCase()}}` | `my_app` | `my.app` |
| `{{name.pathCase()}}` | `my_app` | `my/app` |
| `{{name.sentenceCase()}}` | `my_app` | `My app` |
| `{{name.headerCase()}}` | `my_app` | `My-App` |
| `{{name.upperCase()}}` | `my_app` | `MY_APP` |
| `{{name.lowerCase()}}` | `MY_APP` | `my_app` |

### Conditionals

Use `{{#variable}}...{{/variable}}` for conditional sections:

```yaml
# In pubspec.yaml template:
dependencies:
  flutter:
    sdk: flutter

{{#use_firebase}}
  # Firebase dependencies (only included if use_firebase is true)
  firebase_core: ^3.0.0
  firebase_auth: ^5.0.0
  cloud_firestore: ^5.0.0
{{/use_firebase}}

  # Always included
  http: ^1.0.0
```

### Inverted Conditionals

Use `{{^variable}}...{{/variable}}` for "if NOT":

```dart
{{^use_firebase}}
// No Firebase - use local storage instead
import 'package:hive/hive.dart';
{{/use_firebase}}

{{#use_firebase}}
// Firebase enabled
import 'package:cloud_firestore/cloud_firestore.dart';
{{/use_firebase}}
```

### Iterating Arrays

```yaml
# With platforms: [android, ios, web]

{{#platforms}}
- {{.}}
{{/platforms}}

# Output:
- android
- ios
- web
```

### File and Directory Names

You can use variables in file/directory names:

```
__brick__/
└── {{name.snakeCase()}}/           # Creates: my_app/
    └── lib/
        └── {{name.snakeCase()}}.dart   # Creates: my_app.dart
```

---

## Hooks (Pre/Post Generation)

Hooks are Dart scripts that run before or after file generation.

### hooks/pubspec.yaml

```yaml
name: arcane_app_hooks
version: 1.0.0
publish_to: none

environment:
  sdk: ^3.0.0

dependencies:
  mason: ^0.1.2
```

### hooks/pre_gen.dart

Runs **before** Mason generates files. Common uses:
- Running `flutter create` to set up the project structure
- Validating variables
- Modifying variables

```dart
import 'dart:io';
import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final name = context.vars['name'] as String;
  final org = context.vars['org'] as String;
  final platforms = context.vars['platforms'] as List<dynamic>;

  context.logger.info('Creating Flutter project: $name');

  // Run flutter create to generate platform directories
  final args = <String>[
    'create',
    '--org', org,
    '--project-name', name,
    '--platforms', platforms.join(','),
    name,
  ];

  final result = await Process.run(
    'flutter',
    args,
    runInShell: Platform.isWindows,
  );

  if (result.exitCode != 0) {
    context.logger.err('flutter create failed: ${result.stderr}');
    throw Exception('Failed to create Flutter project');
  }

  context.logger.success('Flutter project created');
}
```

### hooks/post_gen.dart

Runs **after** Mason generates files. Common uses:
- Running `flutter pub get`
- Running build_runner
- Cleaning up files

```dart
import 'dart:io';
import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final name = context.vars['name'] as String;

  context.logger.info('Installing dependencies...');

  // Run flutter pub get
  final result = await Process.run(
    'flutter',
    ['pub', 'get'],
    workingDirectory: name,
    runInShell: Platform.isWindows,
  );

  if (result.exitCode != 0) {
    context.logger.warn('flutter pub get had warnings: ${result.stderr}');
  } else {
    context.logger.success('Dependencies installed');
  }

  // Delete test folder (we provide our own)
  final testDir = Directory('$name/test');
  if (testDir.existsSync()) {
    await testDir.delete(recursive: true);
    context.logger.info('Removed default test folder');
  }

  context.logger.success('Project setup complete!');
}
```

---

## Creating Your First Brick

Let's create a simple "hello world" brick step by step.

### Step 1: Create Directory Structure

```bash
mkdir -p my_brick/__brick__/{{name.snakeCase()}}/lib
mkdir -p my_brick/hooks
```

### Step 2: Create brick.yaml

```yaml
# my_brick/brick.yaml
name: my_brick
description: A simple example brick
version: 1.0.0

vars:
  name:
    type: string
    description: Project name
    prompt: Project name?

  author:
    type: string
    description: Author name
    default: Anonymous
    prompt: Author name?
```

### Step 3: Create Template Files

```dart
// my_brick/__brick__/{{name.snakeCase()}}/lib/main.dart
/// {{name.titleCase()}}
/// Created by {{author}}

void main() {
  print('Hello from {{name.titleCase()}}!');
}
```

```yaml
# my_brick/__brick__/{{name.snakeCase()}}/pubspec.yaml
name: {{name.snakeCase()}}
description: Created by {{author}}
version: 1.0.0

environment:
  sdk: ^3.0.0
```

### Step 4: Test Your Brick

```bash
# From the brick directory
mason make my_brick --name hello_world --author "John Doe" -o ./output
```

---

## The arcane_app Brick Explained

Let's examine the `arcane_app` brick in detail.

### Directory Structure

```
arcane_app/
├── brick.yaml
├── README.md
├── __brick__/
│   └── {{name.snakeCase()}}/
│       ├── assets/
│       │   └── icon/
│       │       ├── icon.png
│       │       └── splash.png
│       ├── lib/
│       │   ├── main.dart
│       │   └── screens/
│       │       ├── home_screen.dart
│       │       └── settings_screen.dart
│       └── pubspec.yaml
└── hooks/
    ├── pubspec.yaml
    ├── pre_gen.dart
    └── post_gen.dart
```

### How It Works

1. **User runs**: `oracular mason make --brick arcane_app`

2. **Mason prompts for variables** (from brick.yaml):
   - name: `my_app`
   - class_name: `MyApp`
   - org: `com.example`
   - use_firebase: `true`
   - platforms: `[android, ios, web]`

3. **pre_gen.dart runs**:
   - Executes `flutter create --org com.example --project-name my_app --platforms android,ios,web my_app`
   - This creates the Flutter project structure with platform directories

4. **Mason generates files**:
   - Copies `__brick__/{{name.snakeCase()}}/` to `my_app/`
   - Replaces all `{{name.snakeCase()}}` with `my_app`
   - Replaces all `{{class_name.pascalCase()}}` with `MyApp`
   - Evaluates conditionals like `{{#use_firebase}}...{{/use_firebase}}`

5. **post_gen.dart runs**:
   - Runs `flutter pub get` to install dependencies
   - Deletes the default test folder

### Key Template Files

#### pubspec.yaml (with conditionals)

```yaml
name: {{name.snakeCase()}}
description: "{{description}}"
version: 1.0.0

dependencies:
  flutter:
    sdk: flutter

  arcane: ^6.5.3

{{#use_firebase}}
  firebase_core: ^3.0.0
  firebase_auth: ^5.0.0
  cloud_firestore: ^5.0.0
{{/use_firebase}}

scripts:
{{#use_firebase}}
  deploy: firebase deploy --project {{firebase_project_id}}
{{/use_firebase}}
```

#### main.dart

```dart
import 'package:arcane/arcane.dart';
import 'package:{{name.snakeCase()}}/screens/home_screen.dart';
{{#use_firebase}}
import 'package:firebase_core/firebase_core.dart';
{{/use_firebase}}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

{{#use_firebase}}
  await Firebase.initializeApp();
{{/use_firebase}}

  runApp("{{name.snakeCase()}}", const {{class_name.pascalCase()}}App());
}

class {{class_name.pascalCase()}}App extends StatelessWidget {
  const {{class_name.pascalCase()}}App({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
```

---

## Testing Your Brick

### Local Testing

```bash
# Navigate to your brick directory
cd bricks/my_brick

# Generate to a test directory
mason make . --name test_project -o /tmp/test_output

# Check the output
ls -la /tmp/test_output/test_project
```

### Using MasonService (in Oracular)

```dart
await MasonService.generate(
  brickName: 'my_brick',
  outputDir: '/tmp/test',
  vars: {
    'name': 'test_app',
    'class_name': 'TestApp',
    'org': 'com.test',
  },
);
```

### Dry Run

```bash
# See what would be generated without creating files
mason make my_brick --name test -o ./output --dry-run
```

---

## Dependency Management

Since brick pubspec files contain Mustache syntax, they can't be edited with normal Dart tools.

### The Problem

```yaml
# This is valid Mustache but invalid YAML for dart pub:
name: {{name.snakeCase()}}
dependencies:
{{#use_firebase}}
  firebase_core: ^3.0.0
{{/use_firebase}}
```

### The Solution: Reference Project

Oracular includes scripts to manage dependencies:

1. **build_reference.dart** - Extracts all dependencies from bricks into `reference/pubspec.yaml`
2. **check_conflicts.dart** - Detects incompatible dependency versions
3. **sync_from_lock.dart** - Syncs resolved versions back to bricks

### Workflow

```bash
# 1. Check for conflicts
dart run scripts/check_conflicts.dart

# 2. If OK, upgrade dependencies
cd reference/
flutter pub upgrade
cd ..

# 3. Sync resolved versions to bricks
dart run scripts/sync_from_lock.dart
```

---

## Best Practices

### 1. Use Meaningful Variable Names

```yaml
# Good
vars:
  project_name:
    description: The name of your project

# Bad
vars:
  n:
    description: Name
```

### 2. Provide Sensible Defaults

```yaml
vars:
  org:
    type: string
    default: com.example  # Good default
```

### 3. Use Hooks for Complex Setup

Don't try to do everything in templates. Use hooks for:
- Running shell commands
- Complex file operations
- Conditional file creation

### 4. Keep Templates Simple

```dart
// Good - simple variable substitution
class {{class_name.pascalCase()}}App extends StatelessWidget {}

// Avoid - complex nested conditionals
{{#use_firebase}}
{{#use_analytics}}
{{#is_production}}
// This gets hard to maintain
{{/is_production}}
{{/use_analytics}}
{{/use_firebase}}
```

### 5. Document Your Variables

```yaml
vars:
  api_url:
    type: string
    description: |
      The base URL for API requests.
      Should include protocol (https://) but no trailing slash.
      Example: https://api.example.com
```

### 6. Test All Combinations

If you have boolean flags, test with all combinations:

```bash
# Test with Firebase
mason make my_brick --name test1 --use_firebase true

# Test without Firebase
mason make my_brick --name test2 --use_firebase false
```

### 7. Version Your Bricks

Update `version` in brick.yaml when making changes:

```yaml
version: 1.0.0  # Initial release
version: 1.1.0  # Added new feature
version: 2.0.0  # Breaking changes
```

---

## Quick Reference

### Mustache Syntax Cheat Sheet

| Syntax | Description |
|--------|-------------|
| `{{variable}}` | Simple substitution |
| `{{variable.snakeCase()}}` | With transformation |
| `{{#bool}}...{{/bool}}` | If true |
| `{{^bool}}...{{/bool}}` | If false |
| `{{#array}}{{.}}{{/array}}` | Iterate array |
| `{{! comment }}` | Comment (not rendered) |

### File Naming

| Template Name | Output (name=my_app) |
|---------------|---------------------|
| `{{name.snakeCase()}}.dart` | `my_app.dart` |
| `{{name.pascalCase()}}Screen.dart` | `MyAppScreen.dart` |
| `{{name.snakeCase()}}/` | `my_app/` |

### Hook Context

```dart
// In hooks
context.vars['name']           // Access variable
context.logger.info('msg')     // Log info
context.logger.warn('msg')     // Log warning
context.logger.err('msg')      // Log error
context.logger.success('msg')  // Log success
```

---

## Further Resources

- [Mason Documentation](https://pub.dev/packages/mason)
- [Mustache Specification](https://mustache.github.io/mustache.5.html)
- [Dart Process API](https://api.dart.dev/stable/dart-io/Process-class.html)
- [Oracular Source Code](https://github.com/ArcaneArts/oracular)
