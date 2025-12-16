# Arcane Beamer Brick

A Mason brick for creating multi-platform Flutter applications with [Arcane UI](https://pub.dev/packages/arcane) and [Beamer](https://pub.dev/packages/beamer) navigation.

## Features

- Multi-platform support (Android, iOS, Web, macOS, Linux, Windows)
- Arcane UI framework with modern, customizable components
- Beamer declarative navigation with deep linking support
- Optional Firebase integration
- URL-based routing (great for web)
- Pre-configured route structure

## Usage

### Via Oracular CLI

```bash
oracular mason make --brick arcane_beamer
```

### Via Mason CLI

```bash
mason make arcane_beamer
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
│       ├── icon.png
│       └── splash.png
├── lib/
│   ├── main.dart             # App entry with Beamer setup
│   ├── routes.dart           # Route definitions
│   └── screens/
│       └── home_screen.dart
├── pubspec.yaml
└── [platform directories]
```

## Beamer Navigation

### Route Structure

Routes are defined in `lib/routes.dart`:

```dart
class AppRoutes {
  static const home = '/';
  static const settings = '/settings';
  static const profile = '/profile/:id';
}

class AppRouter extends BeamerDelegate {
  AppRouter() : super(
    locationBuilder: RoutesLocationBuilder(
      routes: {
        AppRoutes.home: (context, state, data) => const HomeScreen(),
        AppRoutes.settings: (context, state, data) => const SettingsScreen(),
        AppRoutes.profile: (context, state, data) {
          final id = state.pathParameters['id']!;
          return ProfileScreen(userId: id);
        },
      },
    ),
  );
}
```

### Navigation Examples

```dart
// Push to route
context.beamToNamed('/settings');

// Push with parameters
context.beamToNamed('/profile/123');

// Replace route
context.beamToReplacementNamed('/home');

// Pop
context.beamBack();

// Deep link (works from URL)
// https://myapp.com/profile/123
```

## Why Beamer?

- **Declarative** - Routes defined as data, not imperative navigation
- **Deep linking** - URLs map directly to screens
- **Web-friendly** - Browser back/forward buttons work correctly
- **Type-safe** - Compile-time route checking
- **Nested navigation** - Support for complex navigation patterns

## Included Dependencies

Everything from `arcane_app` plus:
- `beamer` - Declarative navigation

## Scripts

Same as `arcane_app` - see that README for details.

## Customization

### Adding Routes

1. Define route constant in `routes.dart`:
```dart
static const myRoute = '/my-route';
```

2. Add to route builder:
```dart
AppRoutes.myRoute: (context, state, data) => const MyScreen(),
```

### Nested Navigation

```dart
class MainRouter extends BeamerDelegate {
  MainRouter() : super(
    locationBuilder: RoutesLocationBuilder(
      routes: {
        '/': (context, state, data) => BeamPage(
          child: MainScreen(
            // Nested Beamer for tabs
            beamerKey: _tabsBeamerKey,
          ),
        ),
      },
    ),
  );
}
```

## Requirements

- Flutter SDK ^3.10.0
- Dart SDK ^3.0.0

## Related Bricks

- [arcane_app](../arcane_app/) - Without Beamer navigation
- [arcane_dock](../arcane_dock/) - Desktop system tray app
- [arcane_models](../arcane_models/) - Shared models package
- [arcane_server](../arcane_server/) - Backend server
