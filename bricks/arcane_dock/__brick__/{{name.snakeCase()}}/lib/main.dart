import 'dart:io';

import 'package:arcane/arcane.dart';
import 'package:{{name.snakeCase()}}/screens/dock_screen.dart';
import 'package:{{name.snakeCase()}}/util/window_manager.dart';
import 'package:fast_log/fast_log.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

/// Global Hive boxes for persistent storage
late Box box;
late Box boxSettings;

/// Package information
late PackageInfo packageInfo;

/// Application configuration path
late String configPath;

void main() async {
  try {
    await _initializeApp();
    runApp("{{name.snakeCase()}}", const {{class_name.pascalCase()}}());
  } catch (e, stackTrace) {
    error("FATAL ERROR: $e");
    error("STACK TRACE: $stackTrace");
  }
}

/// Initialize all app dependencies and configurations
Future<void> _initializeApp() async {
  // Setup debugging and Flutter binding
  lDebugMode = true;
  setupArcaneDebug();
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app directories and logging
  await _setupDirectoriesAndLogging();

  // Initialize app settings and state
  await _setupAppSettings();

  // Log successful initialization
  success("{{class_name.pascalCase()}} initialized successfully");
  success("=====================================");
}

/// Set up application directories and logging configuration
Future<void> _setupDirectoriesAndLogging() async {
  // Set up app directory
  final Directory appDocDir = await getApplicationDocumentsDirectory();
  configPath = "${appDocDir.path}/{{class_name.pascalCase()}}";
  await Directory(configPath).create(recursive: true);
  info("App directory: $configPath");

  // Configure logging with file rotation
  await _setupLogging();
}

/// Set up log file with rotation
Future<void> _setupLogging() async {
  final File logFile = File("$configPath/{{name.snakeCase()}}.log");

  // Rotate log file if too large (1MB limit)
  if (await logFile.exists()) {
    final int fileSize = await logFile.length();
    if (fileSize > 1024 * 1024) {
      await logFile.delete();
      verbose("Log file rotated (exceeded 1MB)");
    }
  }

  // Configure log handler to write to file
  final IOSink logSink = logFile.openWrite(mode: FileMode.writeOnlyAppend);
  lLogHandler = (LogCategory category, String message) {
    logSink.writeln("${category.name}: $message");
  };
}

/// Set up application settings, database, and startup configuration
Future<void> _setupAppSettings() async {
  verbose("Getting package info");
  final Future<PackageInfo> packageInfoFuture = PackageInfo.fromPlatform();

  // Initialize Hive database
  await Hive.initFlutter(configPath);
  verbose("Opening Hive boxes");

  // Open main data box (unencrypted for simplicity)
  box = await Hive.openBox("data");

  // Open settings box
  verbose("Opening settings box");
  boxSettings = await Hive.openBox("settings");

  // Initialize window manager and tray
  verbose("Initializing window manager");
  await WindowManager.init();

  // Configure startup settings
  await _configureStartup(packageInfoFuture);
}

/// Configure application startup behavior
Future<void> _configureStartup(Future<PackageInfo> packageInfoFuture) async {
  // Wait for package info
  verbose("Waiting for PackageInfo");
  await packageInfoFuture.then((value) {
    packageInfo = value;
    verbose("PackageInfo: ${packageInfo.version}");
    verbose("Configuring launch at startup");

    // Set up launch at startup
    launchAtStartup.setup(
      appName: packageInfo.appName,
      appPath: Platform.resolvedExecutable,
    );
  });

  // Apply autolaunch setting
  verbose("Checking if autolaunch is enabled");
  final bool autolaunchEnabled = boxSettings.get(
    "autolaunch",
    defaultValue: false,
  );

  if (autolaunchEnabled) {
    await launchAtStartup.enable();
    verbose("Autolaunch enabled");
  } else {
    await launchAtStartup.disable();
    verbose("Autolaunch disabled");
  }
}

/// Main application widget
class {{class_name.pascalCase()}} extends StatefulWidget {
  const {{class_name.pascalCase()}}({super.key});

  @override
  State<{{class_name.pascalCase()}}> createState() => _{{class_name.pascalCase()}}State();
}

class _{{class_name.pascalCase()}}State extends State<{{class_name.pascalCase()}}> {
  @override
  Widget build(BuildContext context) => ArcaneApp(
    debugShowCheckedModeBanner: false,
    title: '{{class_name.pascalCase()}}',
    theme: ArcaneTheme(
      themeMode: ThemeMode.system,
      scheme: ContrastedColorScheme(
        dark: ColorSchemes.darkDefaultColor,
        light: ColorSchemes.lightDefaultColor,
      ),
    ),
    home: const DockScreen(),
  );
}
