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
    );

    // Use ArcaneThemeProvider for CSS variable-based theming
    return ArcaneThemeProvider(
      theme: theme,
      child: div(
        id: 'arcane-root',
        styles: const Styles(raw: {
          'min-height': '100vh',
          'background-color': 'var(--arcane-surface)',
          'color': 'var(--arcane-on-surface)',
          'font-family':
              '"GeistSans", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif',
          '-webkit-font-smoothing': 'antialiased',
          '-moz-osx-font-smoothing': 'grayscale',
        }),
        [
          AppRouter(
            isDark: _isDark,
            onThemeToggle: _toggleTheme,
          ),
          _buildScripts(),
        ],
      ),
    );
  }

  /// JavaScript for client-side functionality
  Component _buildScripts() {
    return script(content: '''
      document.addEventListener('DOMContentLoaded', function() {
        // ===== THEME UTILITIES =====
        function getCurrentTheme() {
          return localStorage.getItem('arcane-theme-preset') || 'green';
        }
        function getCurrentMode() {
          return localStorage.getItem('arcane-theme-mode') || 'dark';
        }
        function setTheme(preset, mode) {
          localStorage.setItem('arcane-theme-preset', preset);
          localStorage.setItem('arcane-theme-mode', mode);
          document.documentElement.className = 'theme-' + preset + '-' + mode;
          updateModeToggleIcon(mode);
        }
        function updateModeToggleIcon(mode) {
          var themeToggle = document.getElementById('theme-toggle');
          if (!themeToggle) return;
          var iconContainer = themeToggle.querySelector('div > div');
          if (iconContainer) {
            if (mode === 'dark') {
              iconContainer.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="5"></circle><line x1="12" y1="1" x2="12" y2="3"></line><line x1="12" y1="21" x2="12" y2="23"></line><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line><line x1="1" y1="12" x2="3" y2="12"></line><line x1="21" y1="12" x2="23" y2="12"></line><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line></svg>';
            } else {
              iconContainer.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path></svg>';
            }
          }
        }

        // ===== THEME MODE TOGGLE (sun/moon button) =====
        var themeToggle = document.getElementById('theme-toggle');
        if (themeToggle) {
          themeToggle.addEventListener('click', function() {
            var currentMode = getCurrentMode();
            var newMode = currentMode === 'dark' ? 'light' : 'dark';
            setTheme(getCurrentTheme(), newMode);
          });
        }

        // ===== BUTTON CLICK FEEDBACK =====
        document.querySelectorAll('.arcane-button, button[class*="arcane"]').forEach(function(btn) {
          btn.addEventListener('mousedown', function() {
            this.style.transform = 'scale(0.98)';
          });
          btn.addEventListener('mouseup', function() {
            this.style.transform = 'scale(1)';
          });
          btn.addEventListener('mouseleave', function() {
            this.style.transform = 'scale(1)';
          });
        });
      });
    ''');
  }
}
