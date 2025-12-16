# Arcane Dock Brick

A Mason brick for creating desktop system tray / menu bar applications with [Arcane UI](https://pub.dev/packages/arcane).

## Features

- **Desktop-only** (macOS, Linux, Windows)
- System tray / menu bar integration
- Window management (hide to tray, show on click)
- Launch at startup support
- Hotkey support
- Transparent/acrylic window effects
- Compact, always-accessible interface

## Usage

### Via Oracular CLI

```bash
oracular mason make --brick arcane_dock
```

### Via Mason CLI

```bash
mason make arcane_dock
```

## Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `name` | string | - | Project name in snake_case |
| `class_name` | string | - | Base class name in PascalCase |
| `org` | string | `com.example` | Organization domain |
| `description` | string | - | Project description |

**Note:** No `platforms` variable - this brick is desktop-only by design.

## Generated Structure

```
my_app/
├── assets/
│   ├── icon.png              # App icon
│   └── tray.png              # System tray icon
├── lib/
│   ├── main.dart             # App entry with tray setup
│   ├── dock_screen.dart      # Main dock UI
│   └── window_manager.dart   # Window control utilities
├── macos/
├── linux/
├── windows/
└── pubspec.yaml
```

## System Tray Features

### Tray Menu

```dart
await trayManager.setContextMenu(
  Menu(
    items: [
      MenuItem(label: 'Show', onClick: (_) => showWindow()),
      MenuItem(label: 'Hide', onClick: (_) => hideWindow()),
      MenuItem.separator(),
      MenuItem(label: 'Quit', onClick: (_) => exit(0)),
    ],
  ),
);
```

### Tray Click Handlers

```dart
trayManager.addListener(TrayListener(
  onTrayIconMouseDown: () => toggleWindow(),
  onTrayIconRightMouseDown: () => showTrayMenu(),
));
```

### Window Management

```dart
// Hide to tray
await windowManager.hide();

// Show from tray
await windowManager.show();
await windowManager.focus();

// Set window position (near tray icon)
await windowManager.setPosition(Offset(x, y));

// Prevent close (hide instead)
await windowManager.setPreventClose(true);
```

## Included Dependencies

### Desktop-Specific
- `tray_manager` - System tray management
- `window_manager` - Window control
- `screen_retriever` - Screen information
- `flutter_acrylic` - Transparent/acrylic effects
- `launch_at_startup` - Auto-start support

### Core
- `arcane` - Arcane UI framework
- `pylon` - State management
- `toxic_flutter` - Reactive utilities
- `hive_flutter` - Local storage

## Use Cases

- **Status monitors** - CPU, memory, network status
- **Quick actions** - Shortcuts to common tasks
- **Utilities** - Clipboard managers, note taking
- **Background services** - With a UI when needed
- **Control panels** - For other applications

## Window Styles

### Transparent Window

```dart
await Window.initialize();
await Window.setEffect(
  effect: WindowEffect.transparent,
);
```

### Acrylic/Blur Effect

```dart
await Window.setEffect(
  effect: WindowEffect.acrylic,
  color: Colors.black.withOpacity(0.5),
);
```

### Frameless Window

```dart
await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
await windowManager.setAsFrameless();
```

## Launch at Startup

```dart
// Enable
await launchAtStartup.enable();

// Disable
await launchAtStartup.disable();

// Check status
final isEnabled = await launchAtStartup.isEnabled();
```

## Hotkeys

```dart
// Register global hotkey
await hotKeyManager.register(
  HotKey(KeyCode.space, modifiers: [KeyModifier.alt]),
  keyDownHandler: (hotKey) => toggleWindow(),
);
```

## Platform Notes

### macOS
- Appears in menu bar (top right)
- Use `tray.png` with transparency for best results
- Supports acrylic effects

### Windows
- Appears in system tray (bottom right)
- May need to "show hidden icons" initially
- Supports acrylic on Windows 11

### Linux
- Behavior varies by desktop environment
- GNOME may need extensions for tray support
- KDE and others work out of the box

## Requirements

- Flutter SDK ^3.10.0
- Dart SDK ^3.0.0
- Desktop platform (macOS, Linux, or Windows)

## Related Bricks

- [arcane_app](../arcane_app/) - Standard multi-platform app
- [arcane_cli](../arcane_cli/) - Command-line interface
