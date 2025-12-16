# Arcane CLI Brick

A Mason brick for creating Dart command-line interface applications using the [darted_cli](https://pub.dev/packages/darted_cli) framework.

## Features

- Pure Dart (no Flutter dependency)
- Declarative command structure
- Built-in argument and flag parsing
- Fuzzy command matching
- Abbreviation support
- Colored output
- Progress indicators
- Easy to extend

## Usage

### Via Oracular CLI

```bash
oracular mason make --brick arcane_cli
```

### Via Mason CLI

```bash
mason make arcane_cli
```

## Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `name` | string | - | Project name in snake_case |
| `class_name` | string | - | Base class name in PascalCase |
| `description` | string | - | CLI description |

## Generated Structure

```
my_cli/
├── bin/
│   └── main.dart             # Entry point
├── lib/
│   └── cli/
│       ├── commands.dart     # Command definitions
│       └── handlers/
│           ├── hello_handlers.dart
│           └── config_handlers.dart
└── pubspec.yaml
```

## Command Structure

Commands are defined declaratively in `lib/cli/commands.dart`:

```dart
final List<DartedCommand> commandsTree = [
  DartedCommand(
    name: 'hello',
    helperDescription: 'Say hello',
    arguments: [
      DartedArgument(name: 'name', abbreviation: 'n'),
    ],
    flags: [
      DartedFlag(name: 'loud', abbreviation: 'l'),
      DartedFlag.help,
    ],
    callback: (args, flags) => handleHello(args ?? {}, flags ?? {}),
    subCommands: [
      DartedCommand(
        name: 'world',
        helperDescription: 'Say hello to the world',
        callback: (_, __) => print('Hello, World!'),
      ),
    ],
  ),
];
```

## Usage Examples

After building and installing your CLI:

```bash
# Run commands
my_cli hello --name John
my_cli hello world
my_cli config set --key api_url --value https://api.example.com
my_cli config get --key api_url

# Get help
my_cli --help
my_cli hello --help

# Use abbreviations
my_cli hello -n John -l
```

## Handler Pattern

Handlers contain the actual logic for commands:

```dart
// lib/cli/handlers/hello_handlers.dart

Future<void> handleHello(
  Map<String, dynamic> args,
  Map<String, dynamic> flags,
) async {
  final name = args['name'] as String? ?? 'World';
  final loud = flags['loud'] == true;

  var message = 'Hello, $name!';
  if (loud) {
    message = message.toUpperCase();
  }

  print(message);
}
```

## Included Dependencies

- `darted_cli` - CLI framework
- `fast_log` - Colored logging
- `toxic` - Reactive utilities
- `artifact` - Data modeling
- `http` - HTTP client
- `path` - Path manipulation
- `yaml` - YAML parsing
- `crypto` - Cryptographic utilities

## Publishing Your CLI

The generated `pubspec.yaml` is configured for publishing:

```yaml
# 1. Remove this line to enable publishing:
publish_to: 'none'

# 2. Uncomment and fill in:
homepage: https://github.com/YOUR_USERNAME/my_cli
repository: https://github.com/YOUR_USERNAME/my_cli

# 3. The executable is already configured:
executables:
  my_cli: main
```

Then publish:

```bash
# Dry run first
dart pub publish --dry-run

# Publish
dart pub publish
```

Users can then install with:

```bash
dart pub global activate my_cli
```

## Local Development

```bash
# Install locally for testing
dart pub global activate . --source=path

# Run directly
dart run bin/main.dart hello --name Test

# Uninstall
dart pub global deactivate my_cli
```

## Adding Commands

1. Add handler in `lib/cli/handlers/`:

```dart
// lib/cli/handlers/greet_handlers.dart
Future<void> handleGreet(Map<String, dynamic> args, Map<String, dynamic> flags) async {
  print('Greetings!');
}
```

2. Add command in `lib/cli/commands.dart`:

```dart
DartedCommand(
  name: 'greet',
  helperDescription: 'Send a greeting',
  callback: (args, flags) => handleGreet(args ?? {}, flags ?? {}),
),
```

## Logging

Use `fast_log` for colored output:

```dart
import 'package:fast_log/fast_log.dart';

info('This is information');
success('Operation completed');
warn('This is a warning');
error('Something went wrong');
verbose('Debug information');
```

## Scripts

```yaml
scripts:
  run: dart run bin/main.dart
  activate: dart pub global activate . --source=path
  deactivate: dart pub global deactivate my_cli
  publish_dry: dart pub publish --dry-run
  publish: dart pub publish
```

## Requirements

- Dart SDK ^3.10.0

## Related Bricks

- [arcane_app](../arcane_app/) - Flutter application
- [arcane_server](../arcane_server/) - Backend server
- [arcane_models](../arcane_models/) - Shared models
