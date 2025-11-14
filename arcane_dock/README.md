# Arcane Dock

**System Tray/Menu Bar Application Template** - A Flutter desktop template for creating applications that live in the system tray (macOS menu bar, Windows system tray, Linux notification area).

## 📋 Overview

Arcane Dock is a production-ready template for building desktop applications that:

- **Live in the system tray** - No dock icon, launches from menu bar/tray
- **Show popup windows** - Click tray icon to show a sleek popup interface
- **Auto-hide on blur** - Window automatically hides when focus is lost
- **Launch at startup** - Optional autolaunch configuration
- **Cross-platform** - Supports macOS, Linux, and Windows

Perfect for:
- System utilities and tools
- Background monitoring apps
- Quick-access dashboards
- Always-available interfaces
- Menu bar applications

## 🎯 Features

### System Tray Integration
- Native system tray icon
- Context menu (right-click)
- Click to show/hide window
- Template icons (adapt to system theme on macOS)

### Window Management
- Popup window positioned near tray icon
- Transparent background with blur effects
- Auto-hide when focus is lost
- Frameless, always-on-top window
- Customizable size and position

### Application Features
- Launch at startup configuration
- Persistent settings with Hive
- Logging with rotation
- Package info integration
- Configuration directory management

### UI Framework
- Pure Arcane components (no Material Design)
- Theme support (light/dark/system)
- Glassmorphic effects
- Responsive layout

## 🚀 Quick Start

### Prerequisites

- Flutter SDK (latest stable)
- Platform-specific requirements:
  - **macOS**: Xcode, CocoaPods
  - **Linux**: libappindicator3-dev, system tray support
  - **Windows**: Visual Studio 2019+

### Create New Project

```bash
# Clone or copy the arcane_dock template
cp -r arcane_dock my_tray_app
cd my_tray_app

# Get dependencies
flutter pub get

# macOS only: Install pods
cd macos && pod install --repo-update && cd ..

# Run
flutter run -d macos  # or linux, or windows
```

### Platform-Specific Setup

**⚠️ IMPORTANT**: Each platform requires specific configuration. See [PLATFORM_SETUP.md](PLATFORM_SETUP.md) for detailed instructions.

**Quick summary:**
- **macOS**: Add `LSUIElement` to `Info.plist`
- **Linux**: Install `libappindicator3-dev`
- **Windows**: No additional setup needed

## 📂 Project Structure

```
lib/
├── main.dart                 # App entry, initialization
├── screens/
│   └── dock_screen.dart     # Main popup UI
└── util/
    └── window_manager.dart  # Tray & window management

assets/
├── icon.png                  # App icon
└── tray.png                  # System tray icon

macos/                        # macOS platform files
linux/                        # Linux platform files
windows/                      # Windows platform files
```

## 🎨 Customization

### Change Tray Icon

Replace `assets/tray.png` with your icon:

**macOS:**
- 22x22 pixels (@1x), 44x44 (@2x)
- Black with transparency (template image)
- Will adapt to system theme

**Linux:**
- 22x22 pixels PNG
- Full color or monochrome

**Windows:**
- 16x16 or 32x32 pixels
- PNG or ICO format

### Modify Popup Window

Edit `lib/util/window_manager.dart`:

```dart
static const wm.WindowOptions windowOptions = wm.WindowOptions(
  size: Size(400, 600),        // Change size
  maximumSize: Size(400, 600),
  minimumSize: Size(400, 600),
  // ... other options
);
```

### Customize UI

Edit `lib/screens/dock_screen.dart`:

```dart
Widget build(BuildContext context) {
  return Screen(
    backgroundColor: context.colorScheme.bg.primary,
    child: Collection(
      children: [
        // Add your custom UI here
      ],
    ).padded(),
  );
}
```

### Add Menu Items

Edit `lib/util/window_manager.dart` in `initSystemTray()`:

```dart
final Menu menu = Menu(
  items: [
    MenuItem(
      key: 'show',
      label: 'Show',
    ),
    MenuItem(
      key: 'your_action',
      label: 'Your Action',
    ),
    MenuItem.separator(),
    MenuItem(
      key: 'exit',
      label: 'Exit',
    ),
  ],
);
```

Handle clicks in `onTrayMenuItemClick()`:

```dart
@override
void onTrayMenuItemClick(MenuItem menuItem) {
  switch (menuItem.key) {
    case 'your_action':
      // Handle your action
      break;
    // ... other cases
  }
}
```

## 🔧 Configuration

### Launch at Startup

Users can enable/disable autolaunch from the UI:

```dart
// Programmatically
await launchAtStartup.enable();
await launchAtStartup.disable();

// Check status
final bool isEnabled = await launchAtStartup.isEnabled();
```

### Persistent Settings

Settings are stored in Hive boxes:

```dart
// Save setting
await boxSettings.put('key', value);

// Load setting
final value = boxSettings.get('key', defaultValue: 'default');
```

### Logging

Logs are written to `~/Documents/ArcaneDock/arcane_dock.log`:

```dart
info('Information message');
verbose('Detailed message');
warn('Warning message');
error('Error message');
success('Success message');
```

Log file automatically rotates when exceeding 1MB.

## 🎯 Common Use Cases

### System Monitor

Monitor system resources and display in popup:

```dart
// Add to dock_screen.dart
Timer.periodic(Duration(seconds: 1), (timer) {
  final cpuUsage = getCPUUsage();
  final memoryUsage = getMemoryUsage();
  setState(() {
    // Update UI
  });
});
```

### Clipboard Manager

Monitor clipboard and show history:

```dart
// Add clipboard monitoring
import 'package:flutter/services.dart';

Timer.periodic(Duration(milliseconds: 500), (timer) async {
  final data = await Clipboard.getData('text/plain');
  // Store and display clipboard history
});
```

### Quick Notes

Persistent notes accessible from tray:

```dart
// Save notes to Hive
await box.put('notes', notesList);

// Display in popup
final notes = box.get('notes', defaultValue: <String>[]);
```

### API Dashboard

Display API status or data:

```dart
// Fetch data periodically
Timer.periodic(Duration(minutes: 5), (timer) async {
  final response = await http.get(apiUrl);
  setState(() {
    // Update UI with API data
  });
});
```

## 📝 Scripts

Convenient dart run scripts in pubspec.yaml:

```bash
# macOS CocoaPods
dart run pod_install_macos

# Generate icons
dart run gen_icons
```

## 🐛 Troubleshooting

### macOS: App shows in Dock

**Solution:** Add `LSUIElement` to `macos/Runner/Info.plist`:

```xml
<key>LSUIElement</key>
<true/>
```

Then rebuild:
```bash
flutter clean
flutter run -d macos
```

### Linux: Tray icon not showing

**Solutions:**

1. Install system tray support:
```bash
# Ubuntu/Debian
sudo apt-get install libappindicator3-dev

# Fedora
sudo dnf install libappindicator-gtk3-devel
```

2. Enable system tray in your desktop environment:
   - **GNOME**: Install [AppIndicator extension](https://extensions.gnome.org/extension/615/appindicator-support/)
   - **KDE/XFCE**: Usually enabled by default

### Windows: Window position incorrect

**Solution:** Ensure screen_retriever is working:

```dart
// Debug window position
final Display display = await screenRetriever.getPrimaryDisplay();
print('Screen size: ${display.size}');

final Offset cursor = await screenRetriever.getCursorScreenPoint();
print('Cursor position: $cursor');
```

### All Platforms: Window doesn't hide on blur

**Solution:** Verify window listener is registered:

```dart
// In WindowManager.init()
wm.windowManager.addListener(HideOnBlurWindowListener());
```

### CocoaPods installation fails

**Solution:** Clean and retry:

```bash
cd macos
rm -rf Pods Podfile.lock
pod install --repo-update
cd ..
```

## 📚 Dependencies

| Package | Purpose |
|---------|---------|
| `arcane` | UI framework (no Material Design) |
| `tray_manager` | System tray icon and menu |
| `window_manager` | Window positioning and management |
| `screen_retriever` | Get screen info and cursor position |
| `flutter_acrylic` | Window blur and transparency effects |
| `launch_at_startup` | Autolaunch configuration |
| `hive` | Local data persistence |
| `fast_log` | Logging system |

## 🔗 Related Documentation

- **[PLATFORM_SETUP.md](PLATFORM_SETUP.md)** - Platform-specific configuration
- **[Main README](../README.md)** - All Arcane templates
- **[tray_manager](https://pub.dev/packages/tray_manager)** - Tray manager package
- **[window_manager](https://pub.dev/packages/window_manager)** - Window manager package

## 🎓 Examples

### Simple Status Indicator

```dart
class StatusIndicator extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Tile(
      leading: Icon(
        isOnline ? Icons.check_circle : Icons.error,
        color: isOnline ? Colors.green : Colors.red,
      ),
      titleText: isOnline ? 'Online' : 'Offline',
      subtitleText: 'Last checked: $lastChecked',
    );
  }
}
```

### Custom Tray Menu

```dart
// In WindowManager.initSystemTray()
final Menu menu = Menu(
  items: [
    MenuItem(key: 'status', label: isOnline ? '● Online' : '● Offline'),
    MenuItem.separator(),
    MenuItem(key: 'refresh', label: 'Refresh'),
    MenuItem(key: 'settings', label: 'Settings...'),
    MenuItem.separator(),
    MenuItem(key: 'about', label: 'About'),
    MenuItem(key: 'exit', label: 'Quit'),
  ],
);
```

### Window with Sections

```dart
Screen(
  child: Collection(
    children: [
      Section(
        titleText: 'Status',
        children: [
          // Status tiles
        ],
      ),
      Section(
        titleText: 'Actions',
        children: [
          // Action buttons
        ],
      ),
      Section(
        titleText: 'Settings',
        children: [
          // Settings toggles
        ],
      ),
    ],
  ).padded(),
)
```

## 🚀 Building for Production

### macOS

```bash
# Build app bundle
flutter build macos --release

# Sign (if you have a developer certificate)
cd build/macos/Build/Products/Release
codesign --deep --force --verify --sign "Your Identity" YourApp.app

# Create DMG (requires appdmg: npm install -g appdmg)
# Configure distribute_options.yaml first
flutter_distributor package --platform macos --targets dmg
```

### Linux

```bash
# Build
flutter build linux --release

# Package as AppImage or create .deb
# See flutter_distributor for packaging options
```

### Windows

```bash
# Build
flutter build windows --release

# Create installer with Inno Setup or similar
```

## 🎯 Best Practices

### 1. Keep Window Lightweight

The popup window should load instantly:

```dart
// ✅ Good - Simple, fast UI
Widget build(BuildContext context) {
  return Screen(
    child: Collection(
      children: [
        // Simple tiles and sections
      ],
    ).padded(),
  );
}

// ❌ Bad - Heavy, slow operations
Widget build(BuildContext context) {
  final data = await fetchHeavyData();  // Don't block build
  return ComplexWidget(data: data);
}
```

### 2. Handle Errors Gracefully

Tray apps run in the background, handle errors silently:

```dart
try {
  await riskyOperation();
} catch (e) {
  error('Operation failed: $e');
  // Don't show error dialogs, just log
}
```

### 3. Minimize Resource Usage

Your app runs constantly, be efficient:

```dart
// Use timers wisely
Timer.periodic(Duration(minutes: 5), (timer) {
  // Check status every 5 minutes, not every second
});

// Cancel timers when not needed
@override
void dispose() {
  timer?.cancel();
  super.dispose();
}
```

### 4. Provide Visual Feedback

Update tray icon to reflect status:

```dart
// Show status in tray icon
await trayManager.setIcon(
  isOnline ? 'assets/tray_online.png' : 'assets/tray_offline.png',
  isTemplate: Platform.isMacOS,
);
```

### 5. Test on All Platforms

Behavior varies by platform:

```dart
if (Platform.isMacOS) {
  // macOS-specific behavior
} else if (Platform.isWindows) {
  // Windows-specific behavior
} else if (Platform.isLinux) {
  // Linux-specific behavior
}
```

---

**Built with Arcane** 🚀 - Material Design-free Flutter UI

For more information, see the [main Arcane templates README](../README.md).
