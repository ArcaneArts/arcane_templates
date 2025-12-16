```
 ██████╗ ██████╗  █████╗  ██████╗██╗   ██╗██╗      █████╗ ██████╗
██╔═══██╗██╔══██╗██╔══██╗██╔════╝██║   ██║██║     ██╔══██╗██╔══██╗
██║   ██║██████╔╝███████║██║     ██║   ██║██║     ███████║██████╔╝
██║   ██║██╔══██╗██╔══██║██║     ██║   ██║██║     ██╔══██║██╔══██╗
╚██████╔╝██║  ██║██║  ██║╚██████╗╚██████╔╝███████╗██║  ██║██║  ██║
 ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
```

Project scaffolding and script runner for Arcane-based Flutter and Dart applications.

## Features

- **Mason Brick Templates** - Production-ready project templates using [Mason](https://pub.dev/packages/mason)
- **Script Runner** - Execute pubspec.yaml scripts with fuzzy matching
- **Multi-Project Architecture** - Client, models, and server packages
- **Firebase Integration** - Automated setup and deployment
- **Platform Selection** - Choose which platforms to target
- **Dependency Management** - Tools to keep brick dependencies in sync

## Repository Structure

```
Oracular/
├── oracular/           # Dart CLI tool
├── oracular_gui/       # Flutter GUI wizard
├── bricks/             # Mason brick templates
│   ├── arcane_app/     # Multi-platform Flutter app
│   ├── arcane_beamer/  # Beamer navigation Flutter app
│   ├── arcane_dock/    # Desktop system tray app
│   ├── arcane_cli/     # Dart CLI application
│   ├── arcane_models/  # Shared data models package
│   └── arcane_server/  # Shelf-based REST API server
├── reference/          # Dependency resolution project
└── scripts/            # Brick maintenance scripts
```

## Installation

```bash
dart pub global activate oracular
```

## Quick Start

```bash
# Interactive wizard
oracular create

# Launch GUI wizard
oracular gui

# Create project directly
oracular create --app-name my_app --org com.example --template 1

# Use Mason directly
oracular mason make --brick arcane_app
```

## Commands

### Project Creation

```bash
oracular create                   # Interactive project creation
oracular create templates         # List available templates
oracular mason make               # Generate from Mason brick
oracular mason list               # List available bricks
```

### Script Runner

Run scripts defined in your `pubspec.yaml`:

```bash
oracular scripts list             # List all scripts
oracular scripts exec build       # Run a script
oracular scripts exec br          # Abbreviation (build_runner)
oracular scripts exec tv          # Abbreviation (test_verbose)
```

Supports fuzzy matching and abbreviations (first letter of each word).

### Tool Verification

```bash
oracular check tools              # Verify all CLI tools
oracular check flutter            # Check Flutter installation
oracular check firebase           # Check Firebase CLI
oracular check docker             # Check Docker
oracular check gcloud             # Check Google Cloud SDK
oracular check doctor             # Run flutter doctor
```

### Firebase Deployment

```bash
oracular deploy all               # Deploy all Firebase resources
oracular deploy firestore         # Deploy Firestore rules
oracular deploy storage           # Deploy Storage rules
oracular deploy hosting           # Deploy to release hosting
oracular deploy hosting-beta      # Deploy to beta hosting
oracular deploy firebase-setup    # Initial Firebase setup
```

### Server Deployment

```bash
oracular deploy server-setup      # Generate Docker configs
oracular deploy server-build      # Build Docker image
```

## Available Bricks

| Brick | Type | Platforms | Description |
|-------|------|-----------|-------------|
| `arcane_app` | Flutter | All | Multi-platform app with Arcane UI |
| `arcane_beamer` | Flutter | All | Declarative routing with Beamer |
| `arcane_dock` | Flutter | Desktop | System tray/menu bar application |
| `arcane_cli` | Dart | - | Command-line interface app |
| `arcane_models` | Dart | - | Shared data models package |
| `arcane_server` | Dart | - | Shelf-based REST API server |

### Brick Variables

When creating a project, you'll be prompted for:

| Variable | Description | Example |
|----------|-------------|---------|
| `name` | Project name (snake_case) | `my_app` |
| `class_name` | Base class name (PascalCase) | `MyApp` |
| `org` | Organization domain | `com.example` |
| `description` | Project description | `My awesome app` |
| `use_firebase` | Enable Firebase integration | `true/false` |
| `firebase_project_id` | Firebase project ID | `my-firebase-project` |
| `platforms` | Target platforms (Flutter only) | `[android, ios, web]` |

## Dependency Management

The bricks use Mason's Mustache syntax which makes pubspec files difficult to edit directly. Use these scripts to manage dependencies:

```bash
# Check for dependency conflicts across all bricks
oracular scripts exec check_conflicts

# Build reference pubspec from all brick dependencies
oracular scripts exec build_reference

# After running `flutter pub upgrade` in reference/, sync back to bricks
oracular scripts exec sync_versions
```

### Workflow

1. **Check for conflicts**: `oracular scripts exec check_conflicts`
2. **If compatible, upgrade**: `cd reference/ && flutter pub upgrade`
3. **Sync to bricks**: `oracular scripts exec sync_versions`

See [How to Make Bricks](docs/how-to-make-bricks.md) for detailed documentation.

## Script Runner Examples

Add scripts to your `pubspec.yaml`:

```yaml
scripts:
  build: flutter build web --release
  deploy: firebase deploy --project my-project
  build_runner: dart run build_runner build --delete-conflicting-outputs
  test_verbose: dart test --reporter=expanded
  pod_install: cd ios && pod install --repo-update
```

Then run with abbreviations:

```bash
oracular scripts exec b           # build (unique prefix)
oracular scripts exec br          # build_runner
oracular scripts exec tv          # test_verbose
oracular scripts exec pi          # pod_install
```

## Development

### CLI Development

```bash
cd oracular
dart pub get
dart run bin/main.dart --help
```

### Running Tests

```bash
cd oracular
dart test
```

### Creating Custom Bricks

See [How to Make Bricks](docs/how-to-make-bricks.md) for a comprehensive guide on creating your own Mason bricks.

## Documentation

- [CLI Development](oracular/README.md)
- [GUI Development](oracular_gui/README.md)
- [How to Make Bricks](docs/how-to-make-bricks.md)
- Individual brick READMEs in `bricks/*/README.md`

## License

MIT
