import 'dart:io';

import 'package:arcane/arcane.dart';
import 'package:arcane_dock/screens/dock_screen.dart';
import 'package:arcane_dock/util/window_manager.dart';
import 'package:fast_log/fast_log.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

late Box box;
late Box boxSettings;
late PackageInfo packageInfo;
late String configPath;

void main() async {
  try {
    await _initializeApp();
    runApp("arcane_dock", const ArcaneDock());
  } catch (e, stackTrace) {
    error("FATAL ERROR: $e");
    error("STACK TRACE: $stackTrace");
  }
}

Future<void> _initializeApp() async {
  lDebugMode = true;
  setupArcaneDebug();
  WidgetsFlutterBinding.ensureInitialized();
  await _setupDirectoriesAndLogging();
  await _setupAppSettings();
  success("Arcane Dock initialized");
}

Future<void> _setupDirectoriesAndLogging() async {
  final Directory appDocDir = await getApplicationDocumentsDirectory();
  configPath = "${appDocDir.path}/ArcaneDock";
  await Directory(configPath).create(recursive: true);
  await _setupLogging();
}

/// Rotates log file if > 1MB
Future<void> _setupLogging() async {
  final File logFile = File("$configPath/arcane_dock.log");
  if (await logFile.exists() && await logFile.length() > 1024 * 1024) {
    await logFile.delete();
  }
  final IOSink logSink = logFile.openWrite(mode: FileMode.writeOnlyAppend);
  lLogHandler = (LogCategory category, String message) {
    logSink.writeln("${category.name}: $message");
  };
}

Future<void> _setupAppSettings() async {
  final Future<PackageInfo> packageInfoFuture = PackageInfo.fromPlatform();
  await Hive.initFlutter(configPath);
  box = await Hive.openBox("data");
  boxSettings = await Hive.openBox("settings");
  await WindowManager.init();
  await _configureStartup(packageInfoFuture);
}

Future<void> _configureStartup(Future<PackageInfo> packageInfoFuture) async {
  await packageInfoFuture.then((value) {
    packageInfo = value;
    launchAtStartup.setup(
      appName: packageInfo.appName,
      appPath: Platform.resolvedExecutable,
    );
  });

  final bool autolaunchEnabled =
      boxSettings.get("autolaunch", defaultValue: false);
  if (autolaunchEnabled) {
    await launchAtStartup.enable();
  } else {
    await launchAtStartup.disable();
  }
}

/// Root app widget. Displays in tray popup (see WindowManager)
class ArcaneDock extends StatefulWidget {
  const ArcaneDock({super.key});

  @override
  State<ArcaneDock> createState() => _ArcaneDockState();
}

class _ArcaneDockState extends State<ArcaneDock> {
  @override
  Widget build(BuildContext context) => ArcaneApp(
        debugShowCheckedModeBanner: false,
        title: 'Arcane Dock',
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
