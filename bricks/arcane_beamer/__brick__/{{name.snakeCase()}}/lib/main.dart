import 'package:{{name.snakeCase()}}/routes.dart';
import 'package:arcane/arcane.dart';
import 'package:beamer/beamer.dart';

void main() {
  // Set Beamer to use path URL strategy (for web - removes the # from URLs)
  Beamer.setPathUrlStrategy();

  runApp("{{name.snakeCase()}}", const {{class_name.pascalCase()}}App());
}

class {{class_name.pascalCase()}}App extends StatefulWidget {
  const {{class_name.pascalCase()}}App({super.key});

  @override
  State<{{class_name.pascalCase()}}App> createState() => _{{class_name.pascalCase()}}AppState();
}

class _{{class_name.pascalCase()}}AppState extends State<{{class_name.pascalCase()}}App> {
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
        // You can customize the color scheme here
        scheme: ContrastedColorScheme(
          light: ColorSchemes.blue(ThemeMode.light),
          dark: ColorSchemes.blue(ThemeMode.dark),
        ),
        themeMode: _themeMode,
      ),
    );
  }
}

/// Extension to provide easy access to theme mode toggle
extension {{class_name.pascalCase()}}AppContext on BuildContext {
  void toggleTheme() {
    final state = findAncestorStateOfType<_{{class_name.pascalCase()}}AppState>();
    state?._toggleTheme();
  }

  ThemeMode get currentThemeMode {
    final state = findAncestorStateOfType<_{{class_name.pascalCase()}}AppState>();
    return state?._themeMode ?? ThemeMode.system;
  }
}
