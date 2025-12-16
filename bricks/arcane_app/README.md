# Arcane App Brick

A Mason brick for creating multi-platform Flutter applications with the [Arcane UI](https://pub.dev/packages/arcane) framework.

## Features

- Multi-platform support (Android, iOS, Web, macOS, Linux, Windows)
- Arcane UI framework with modern, customizable components
- Optional Firebase integration (Auth, Firestore, Storage)
- Pre-configured script runner commands
- Asset generation (icons, splash screens)
- Production-ready project structure

## Usage

### Via Oracular CLI

```bash
oracular mason make --brick arcane_app
```

### Via Mason CLI

```bash
mason make arcane_app
```

### Programmatic

```dart
await MasonService.generate(
  brickName: 'arcane_app',
  outputDir: './output',
  vars: {
    'name': 'my_app',
    'class_name': 'MyApp',
    'org': 'com.example',
    'description': 'My awesome app',
    'use_firebase': true,
    'firebase_project_id': 'my-firebase-project',
    'platforms': ['android', 'ios', 'web'],
  },
);
```

## Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `name` | string | - | Project name in snake_case |
| `class_name` | string | - | Base class name in PascalCase |
| `org` | string | `com.example` | Organization domain |
| `description` | string | - | Project description |
| `use_firebase` | boolean | `false` | Include Firebase integration |
| `firebase_project_id` | string | `""` | Firebase project ID |
| `platforms` | array | all platforms | Target platforms |

## Generated Structure

```
my_app/
├── assets/
│   └── icon/
│       ├── icon.png          # App icon
│       └── splash.png        # Splash screen image
├── lib/
│   ├── main.dart             # App entry point
│   └── screens/
│       ├── home_screen.dart  # Home screen
│       └── settings_screen.dart
├── android/                  # Android platform (if selected)
├── ios/                      # iOS platform (if selected)
├── web/                      # Web platform (if selected)
├── macos/                    # macOS platform (if selected)
├── linux/                    # Linux platform (if selected)
├── windows/                  # Windows platform (if selected)
├── pubspec.yaml              # Dependencies and scripts
└── analysis_options.yaml     # Lint rules
```

## Included Dependencies

### Core
- `arcane` - Arcane UI framework
- `arcane_user` - User management utilities
- `pylon` - State management
- `toxic` / `toxic_flutter` - Reactive utilities

### Firebase (when enabled)
- `firebase_core`
- `firebase_auth`
- `cloud_firestore`
- `firebase_storage`
- `arcane_fluf` - Arcane Firebase utilities
- `arcane_auth` - Arcane authentication
- `fire_crud` - Firestore CRUD operations

### Utilities
- `rxdart` - Reactive extensions
- `hive` / `hive_flutter` - Local storage
- `http` - HTTP client
- `cached_network_image` - Image caching
- `url_launcher` - URL handling
- And more...

## Scripts

The generated project includes these scripts in `pubspec.yaml`:

```bash
# Build
oracular scripts exec build_web      # Build for web

# Deploy (Firebase only)
oracular scripts exec deploy         # Deploy all
oracular scripts exec deploy_hosting # Deploy hosting only

# Asset Generation
oracular scripts exec gen_icons      # Generate app icons
oracular scripts exec gen_splash     # Generate splash screen
oracular scripts exec gen_assets     # Generate all assets

# Platform Setup
oracular scripts exec pod_install_ios    # Install iOS pods
oracular scripts exec pod_install_macos  # Install macOS pods
```

## Customization

### Adding Screens

Create new screens in `lib/screens/`:

```dart
import 'package:arcane/arcane.dart';

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ArcaneScaffold(
      title: 'My Screen',
      child: Center(
        child: Text('Hello!'),
      ),
    );
  }
}
```

### Theming

Arcane uses a customizable theme system. Modify in `main.dart`:

```dart
runApp(
  "my_app",
  const MyAppApp(),
  theme: ArcaneTheme(
    // Customize theme here
  ),
);
```

## Requirements

- Flutter SDK ^3.10.0
- Dart SDK ^3.0.0
- (Optional) Firebase CLI for deployment

## Related Bricks

- [arcane_beamer](../arcane_beamer/) - With Beamer navigation
- [arcane_dock](../arcane_dock/) - Desktop system tray app
- [arcane_models](../arcane_models/) - Shared models package
- [arcane_server](../arcane_server/) - Backend server
