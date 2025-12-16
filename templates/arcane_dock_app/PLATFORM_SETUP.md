# Platform Setup for Arcane Dock

This document describes the platform-specific configurations required for tray_manager to work on macOS, Linux, and Windows.

## 📋 Overview

The tray_manager package requires platform-specific configurations that cannot be automated. After running `flutter create`, you must manually configure each platform.

## 🍎 macOS Setup

### 1. Info.plist Configuration

Edit `macos/Runner/Info.plist` and add:

```xml
<key>LSUIElement</key>
<true/>
```

**This makes the app run without a dock icon** (menu bar only).

### 2. Entitlements (Optional)

The default entitlements in `macos/Runner/DebugProfile.entitlements` and `macos/Runner/Release.entitlements` should work as-is.

If you need network access:

```xml
<key>com.apple.security.network.client</key>
<true/>
```

### 3. App Icon Template

The tray icon (`assets/tray.png`) should be a template image:
- Black icon with transparency
- Recommended size: 22x22 pixels @1x, 44x44 @2x
- Will automatically adapt to system theme (light/dark)

### 4. CocoaPods

Run pod install after flutter pub get:

```bash
cd macos
pod install --repo-update
cd ..
```

---

## 🐧 Linux Setup

### 1. System Tray Support

Linux requires a system tray to be available. Most modern desktop environments include one:
- GNOME: Requires [AppIndicator extension](https://extensions.gnome.org/extension/615/appindicator-support/)
- KDE Plasma: Built-in support
- XFCE: Built-in support
- Cinnamon: Built-in support

### 2. Dependencies

Install required system libraries:

**Ubuntu/Debian:**
```bash
sudo apt-get install libappindicator3-dev
```

**Fedora:**
```bash
sudo dnf install libappindicator-gtk3-devel
```

**Arch Linux:**
```bash
sudo pacman -S libappindicator-gtk3
```

### 3. Icon Format

Use PNG format for tray icons on Linux:
- Recommended size: 22x22 pixels
- Place in `assets/tray.png`

---

## 🪟 Windows Setup

### 1. System Tray

Windows has built-in system tray support. No additional configuration needed.

### 2. Icon Format

Use ICO or PNG format:
- PNG recommended: 16x16 or 32x32 pixels
- Place in `assets/tray.png`

### 3. Startup Configuration

For launch at startup to work, the app must be built in release mode:

```bash
flutter build windows --release
```

---

## 🚀 Testing

### macOS
```bash
flutter run -d macos
```

### Linux
```bash
flutter run -d linux
```

### Windows
```bash
flutter run -d windows
```

---

## 🐛 Troubleshooting

### macOS: App shows in Dock
- Verify `LSUIElement` is set to `true` in `Info.plist`
- Clean build: `flutter clean && flutter pub get`

### Linux: Tray icon not showing
- Install AppIndicator extension (GNOME)
- Check system tray is enabled in your DE settings
- Verify libappindicator3 is installed

### Windows: Icon not showing
- Check icon file exists at `assets/tray.png`
- Try rebuilding: `flutter clean && flutter build windows`

### All Platforms: Window position wrong
- Check screen retriever is working
- Verify window_manager initialization

---

## 📚 Additional Resources

- [tray_manager Documentation](https://pub.dev/packages/tray_manager)
- [window_manager Documentation](https://pub.dev/packages/window_manager)
- [Flutter Desktop Documentation](https://docs.flutter.dev/desktop)
