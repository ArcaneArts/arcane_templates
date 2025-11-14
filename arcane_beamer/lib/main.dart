import 'package:arcane_beamer/routes.dart';
import 'package:arcane/arcane.dart';
import 'package:beamer/beamer.dart';

void main() {
  Beamer.setPathUrlStrategy();
  runApp("arcane_beamer", const ArcaneBeamerApp());
}

/// Root app with Beamer routing and theme management. Routes in lib/routes.dart
class ArcaneBeamerApp extends StatefulWidget {
  const ArcaneBeamerApp({super.key});

  @override
  State<ArcaneBeamerApp> createState() => _ArcaneBeamerAppState();
}

class _ArcaneBeamerAppState extends State<ArcaneBeamerApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode = switch (_themeMode) {
        ThemeMode.light => ThemeMode.dark,
        ThemeMode.dark => ThemeMode.system,
        ThemeMode.system => ThemeMode.light,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return ArcaneApp.router(
      routeInformationParser: BeamerParser(),
      routerDelegate: routerDelegate,
      debugShowCheckedModeBanner: false,
      theme: ArcaneTheme(
        scheme: ContrastedColorScheme(
          light: ColorSchemes.blue(ThemeMode.light),
          dark: ColorSchemes.blue(ThemeMode.dark),
        ),
        themeMode: _themeMode,
      ),
    );
  }
}

/// Access theme controls: context.toggleTheme() or context.currentThemeMode
extension ArcaneBeamerAppContext on BuildContext {
  void toggleTheme() {
    final state = findAncestorStateOfType<_ArcaneBeamerAppState>();
    state?._toggleTheme();
  }

  ThemeMode get currentThemeMode {
    final state = findAncestorStateOfType<_ArcaneBeamerAppState>();
    return state?._themeMode ?? ThemeMode.system;
  }
}
