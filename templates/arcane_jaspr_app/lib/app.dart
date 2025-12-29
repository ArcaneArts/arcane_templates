import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:fast_log/fast_log.dart';

import 'routes/app_router.dart';

/// arcane_jaspr_app - Main application component with theming
class App extends StatefulComponent {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _isDark = true; // Default to dark theme

  @override
  void initState() {
    super.initState();
    verbose('App initializing with dark mode: $_isDark');
  }

  void _toggleTheme() {
    setState(() => _isDark = !_isDark);
    verbose('Theme toggled to: ${_isDark ? "dark" : "light"}');
  }

  @override
  Component build(BuildContext context) {
    verbose('Building App component');

    final theme = ArcaneTheme.green.copyWith(
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      uniformBackgrounds: true, // Sleek dark design with unified backgrounds
    );

    // Use ArcaneApp wrapper for theming
    return ArcaneApp(
      theme: theme,
      includeFallbackScripts: false, // Client app doesn't need static fallbacks
      child: AppRouter(
        isDark: _isDark,
        onThemeToggle: _toggleTheme,
      ),
    );
  }
}
