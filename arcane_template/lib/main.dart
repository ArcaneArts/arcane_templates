import 'package:arcane_template/screens/home_screen.dart';
import 'package:arcane/arcane.dart';

void main() {
  runApp("arcane_template", const ArcaneTemplateApp());
}

/// Root app widget with theme management. Cycles: light → dark → system
class ArcaneTemplateApp extends StatefulWidget {
  const ArcaneTemplateApp({super.key});

  @override
  State<ArcaneTemplateApp> createState() => _ArcaneTemplateAppState();
}

class _ArcaneTemplateAppState extends State<ArcaneTemplateApp> {
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
    return ArcaneApp(
      debugShowCheckedModeBanner: false,
      theme: ArcaneTheme(
        scheme: ContrastedColorScheme(
          light: ColorSchemes.blue(ThemeMode.light),
          dark: ColorSchemes.blue(ThemeMode.dark),
        ),
        themeMode: _themeMode,
      ),
      home: const HomeScreen(),
    );
  }
}

/// Access theme controls: context.toggleTheme() or context.currentThemeMode
extension ArcaneTemplateAppContext on BuildContext {
  void toggleTheme() {
    final state = findAncestorStateOfType<_ArcaneTemplateAppState>();
    state?._toggleTheme();
  }

  ThemeMode get currentThemeMode {
    final state = findAncestorStateOfType<_ArcaneTemplateAppState>();
    return state?._themeMode ?? ThemeMode.system;
  }
}
