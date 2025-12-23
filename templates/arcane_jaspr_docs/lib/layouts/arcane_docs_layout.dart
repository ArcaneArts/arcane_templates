import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:jaspr/dom.dart' show RawText;
import 'package:jaspr_content/jaspr_content.dart';

import '../components/docs_sidebar.dart';
import '../components/docs_header.dart';

/// Custom documentation layout using Arcane UI components
class ArcaneDocsLayout extends PageLayoutBase {
  const ArcaneDocsLayout();

  @override
  Pattern get name => 'docs';

  /// Generate CSS variable declarations for a theme
  static String _generateThemeCss(ArcaneTheme theme) {
    final vars = theme.cssVariables;
    return vars.entries.map((e) => '  ${e.key}: ${e.value};').join('\n');
  }

  /// All available theme presets with their CSS class names
  static const List<(String id, String name, ArcaneTheme theme)> _allThemes = [
    // Primary colors
    ('red', 'Red', ArcaneTheme.red),
    ('orange', 'Orange', ArcaneTheme.orange),
    ('yellow', 'Yellow', ArcaneTheme.yellow),
    ('green', 'Green', ArcaneTheme.green),
    ('blue', 'Blue', ArcaneTheme.blue),
    ('indigo', 'Indigo', ArcaneTheme.indigo),
    ('purple', 'Purple', ArcaneTheme.purple),
    ('pink', 'Pink', ArcaneTheme.pink),
    // Neutrals
    ('dark-grey', 'Dark Grey', ArcaneTheme.darkGrey),
    ('grey', 'Grey', ArcaneTheme.grey),
    ('light-grey', 'Light Grey', ArcaneTheme.lightGrey),
    ('white', 'White', ArcaneTheme.white),
    ('black', 'Black', ArcaneTheme.black),
    // OLED
    ('oled-red', 'OLED Red', ArcaneTheme.oledRed),
    ('oled-green', 'OLED Green', ArcaneTheme.oledGreen),
    ('oled-blue', 'OLED Blue', ArcaneTheme.oledBlue),
    ('oled-purple', 'OLED Purple', ArcaneTheme.oledPurple),
    ('oled-white', 'OLED White', ArcaneTheme.oledWhite),
  ];

  @override
  Iterable<Component> buildHead(Page page) sync* {
    yield* super.buildHead(page);
    yield link(rel: 'icon', type: 'image/x-icon', href: '/favicon.ico');
    yield meta(name: 'viewport', content: 'width=device-width, initial-scale=1');

    // Generate CSS variables for ALL themes (dark and light modes)
    final cssBuffer = StringBuffer();

    // Default theme (green dark) for :root
    final defaultTheme =
        ArcaneTheme.green.copyWith(themeMode: ThemeMode.dark);
    cssBuffer.writeln(':root {');
    cssBuffer.writeln(_generateThemeCss(defaultTheme));
    cssBuffer.writeln('}');

    // Generate CSS for each theme in both dark and light modes
    for (final (id, _, theme) in _allThemes) {
      final darkTheme = theme.copyWith(themeMode: ThemeMode.dark);
      final lightTheme = theme.copyWith(themeMode: ThemeMode.light);

      cssBuffer.writeln('html.theme-$id-dark, .theme-$id-dark {');
      cssBuffer.writeln(_generateThemeCss(darkTheme));
      cssBuffer.writeln('}');

      cssBuffer.writeln('html.theme-$id-light, .theme-$id-light {');
      cssBuffer.writeln(_generateThemeCss(lightTheme));
      cssBuffer.writeln('}');
    }

    yield Component.element(
      tag: 'style',
      attributes: {'id': 'arcane-theme-vars'},
      children: [RawText(cssBuffer.toString())],
    );

    // Load stylesheet AFTER theme variables so our overrides take precedence
    yield link(rel: 'stylesheet', href: '/styles.css');

    // Theme initialization script - runs before page renders to prevent flash
    yield script(content: '''
      (function() {
        var savedTheme = localStorage.getItem('arcane-theme-preset') || 'green';
        var savedMode = localStorage.getItem('arcane-theme-mode') || 'dark';
        document.documentElement.className = 'theme-' + savedTheme + '-' + savedMode;
      })();
    ''');
  }

  @override
  Component buildBody(Page page, Component child) {
    final pageData = page.data.page;
    return _ThemedDocsPage(
      title: pageData['title'] as String?,
      description: pageData['description'] as String?,
      toc: page.data['toc'] as TableOfContents?,
      currentPath: page.url,
      content: child,
    );
  }
}

/// Stateful wrapper for theme toggling
class _ThemedDocsPage extends StatefulComponent {
  final String? title;
  final String? description;
  final TableOfContents? toc;
  final String currentPath;
  final Component content;

  const _ThemedDocsPage({
    this.title,
    this.description,
    this.toc,
    required this.currentPath,
    required this.content,
  });

  @override
  State<_ThemedDocsPage> createState() => _ThemedDocsPageState();
}

class _ThemedDocsPageState extends State<_ThemedDocsPage> {
  bool _isDark = true; // Default to dark theme

  @override
  void initState() {
    super.initState();
    // Theme is read from localStorage via JavaScript on client side
    // The initial _isDark value stays true (dark mode default)
    // JavaScript in the page handles initial theme application
  }

  void _toggleTheme() {
    setState(() => _isDark = !_isDark);
    // The actual DOM update happens via JavaScript called from the button onClick
    // This state update is just for re-rendering components with the new theme
  }

  @override
  Component build(BuildContext context) {
    final theme = ArcaneTheme.green.copyWith(
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
    );

    // Don't use ArcaneApp - it applies inline CSS that overrides class-based theming
    // Instead use a simple wrapper that respects CSS variables from <head>
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
          _buildPageLayout(),
          _buildScripts(),
        ],
      ),
    );
  }

  /// Main page layout structure
  Component _buildPageLayout() {
    return div(
      styles: const Styles(raw: {
        'display': 'flex',
        'min-height': '100vh',
        'background': 'var(--arcane-surface)',
        'color': 'var(--arcane-on-surface)',
        'font-family': 'inherit',
      }),
      [
        DocsSidebar(currentPath: component.currentPath),
        _buildMainArea(),
      ],
    );
  }

  /// Main content area with header
  Component _buildMainArea() {
    return ArcaneDiv(
      styles: const ArcaneStyleData(
        flexGrow: 1,
        display: Display.flex,
        flexDirection: FlexDirection.column,
        minHeight: '100vh',
      ),
      children: [
        DocsHeader(isDark: _isDark, onThemeToggle: _toggleTheme),
        _buildContentArea(),
      ],
    );
  }

  /// Content area with main content and TOC
  Component _buildContentArea() {
    return ArcaneDiv(
      styles: const ArcaneStyleData(
        display: Display.flex,
        gap: Gap.xl,
        padding: PaddingPreset.xl,
        maxWidth: MaxWidth.container,
        margin: MarginPreset.autoX,
        flexGrow: 1,
      ),
      children: [
        _buildMainContent(),
        if (component.toc != null) _buildTableOfContents(),
      ],
    );
  }

  /// Main content section
  Component _buildMainContent() {
    return ArcaneDiv(
      styles: const ArcaneStyleData(
        flexGrow: 1,
        raw: {'min-width': '0'},
      ),
      children: [
        if (component.title != null) _buildTitle(),
        if (component.description != null) _buildDescription(),
        div(classes: 'prose', [component.content]),
      ],
    );
  }

  Component _buildTitle() {
    return ArcaneDiv(
      styles: const ArcaneStyleData(
        margin: MarginPreset.bottomLg,
        fontSize: FontSize.xl3,
        fontWeight: FontWeight.bold,
        textColor: TextColor.primary,
      ),
      children: [ArcaneText(component.title!)],
    );
  }

  Component _buildDescription() {
    return ArcaneDiv(
      styles: const ArcaneStyleData(
        margin: MarginPreset.bottomXl,
        textColor: TextColor.muted,
        fontSize: FontSize.lg,
      ),
      children: [ArcaneText(component.description!)],
    );
  }

  /// Table of contents sidebar
  Component _buildTableOfContents() {
    return ArcaneDiv(
      styles: const ArcaneStyleData(
        widthCustom: '240px',
        flexShrink: 0,
        position: Position.sticky,
        overflow: Overflow.auto,
        raw: {
          'top': '80px',
          'align-self': 'flex-start',
          'max-height': 'calc(100vh - 100px)',
        },
      ),
      children: [
        ArcaneDiv(
          styles: const ArcaneStyleData(
            padding: PaddingPreset.md,
            borderRadius: Radius.lg,
            background: Background.surface,
            border: BorderPreset.subtle,
          ),
          children: [
            ArcaneDiv(
              styles: const ArcaneStyleData(
                fontSize: FontSize.xs,
                fontWeight: FontWeight.w700,
                margin: MarginPreset.bottomMd,
                textTransform: TextTransform.uppercase,
                letterSpacing: LetterSpacing.wide,
                textColor: TextColor.onSurfaceVariant,
                padding: PaddingPreset.bottomMd,
                borderBottom: BorderPreset.subtle,
              ),
              children: [ArcaneText('On this page')],
            ),
            div(classes: 'toc-content', [component.toc!.build()]),
          ],
        ),
      ],
    );
  }

  /// JavaScript for static site functionality
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
          updateThemeButtons(preset);
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
        function updateThemeButtons(activePreset) {
          document.querySelectorAll('[data-theme-preset]').forEach(function(btn) {
            var isActive = btn.dataset.themePreset === activePreset;
            btn.style.outline = isActive ? '2px solid var(--arcane-accent)' : 'none';
            btn.style.outlineOffset = isActive ? '2px' : '0';
          });
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

        // ===== THEME PRESET BUTTONS =====
        document.querySelectorAll('[data-theme-preset]').forEach(function(btn) {
          btn.addEventListener('click', function() {
            var preset = this.dataset.themePreset;
            setTheme(preset, getCurrentMode());
          });
        });

        // Initialize button states
        updateThemeButtons(getCurrentTheme());

        // ===== SEARCH FUNCTIONALITY =====
        var searchInput = document.getElementById('docs-search');
        var searchResults = document.getElementById('search-results');

        // Build search index from sidebar navigation
        var searchIndex = [];
        document.querySelectorAll('nav a').forEach(function(link) {
          var text = link.textContent.trim();
          var href = link.getAttribute('href');
          if (text && href && href.includes('/docs')) {
            // Extract category from URL
            var parts = href.split('/');
            var category = parts.length > 2 ? parts[2] : 'docs';
            category = category.charAt(0).toUpperCase() + category.slice(1).replace(/-/g, ' ');

            searchIndex.push({
              title: text,
              href: href,
              category: category,
              searchText: text.toLowerCase()
            });
          }
        });

        function showResults(results) {
          if (!searchResults) return;

          if (results.length === 0) {
            searchResults.innerHTML = '<div style="padding: 12px; color: var(--arcane-on-surface-variant); text-align: center;">No results found</div>';
            searchResults.style.display = 'block';
            return;
          }

          var html = results.map(function(item) {
            return '<a href="' + item.href + '" style="display: block; padding: 10px 12px; text-decoration: none; border-bottom: 1px solid var(--arcane-outline-variant); transition: background 0.15s;">' +
              '<div style="font-weight: 500; color: var(--arcane-on-surface);">' + item.title + '</div>' +
              '<div style="font-size: 12px; color: var(--arcane-on-surface-variant);">' + item.category + '</div>' +
            '</a>';
          }).join('');

          searchResults.innerHTML = html;
          searchResults.style.display = 'block';

          // Add hover effects
          searchResults.querySelectorAll('a').forEach(function(link) {
            link.addEventListener('mouseenter', function() {
              this.style.background = 'var(--arcane-surface-variant)';
            });
            link.addEventListener('mouseleave', function() {
              this.style.background = 'transparent';
            });
          });
        }

        function hideResults() {
          if (searchResults) {
            searchResults.style.display = 'none';
          }
        }

        if (searchInput) {
          searchInput.addEventListener('input', function() {
            var query = this.value.toLowerCase().trim();

            if (query.length < 2) {
              hideResults();
              return;
            }

            var results = searchIndex.filter(function(item) {
              return item.searchText.includes(query);
            }).slice(0, 10);

            showResults(results);
          });

          searchInput.addEventListener('focus', function() {
            if (this.value.length >= 2) {
              var query = this.value.toLowerCase().trim();
              var results = searchIndex.filter(function(item) {
                return item.searchText.includes(query);
              }).slice(0, 10);
              showResults(results);
            }
          });

          // Close results when clicking outside
          document.addEventListener('click', function(e) {
            if (!searchInput.contains(e.target) && !searchResults.contains(e.target)) {
              hideResults();
            }
          });

          // Keyboard navigation
          searchInput.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
              hideResults();
              this.blur();
            }
          });
        }

        // ===== CODE BLOCK COPY BUTTONS =====
        document.querySelectorAll('pre').forEach(function(pre) {
          var wrapper = document.createElement('div');
          wrapper.className = 'code-block-wrapper';
          pre.parentNode.insertBefore(wrapper, pre);
          wrapper.appendChild(pre);

          var copyBtn = document.createElement('button');
          copyBtn.className = 'copy-code-btn';
          copyBtn.innerHTML = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path></svg>';
          copyBtn.title = 'Copy code';
          wrapper.appendChild(copyBtn);

          copyBtn.addEventListener('click', function() {
            var code = pre.querySelector('code') || pre;
            navigator.clipboard.writeText(code.textContent).then(function() {
              copyBtn.innerHTML = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"></polyline></svg>';
              copyBtn.classList.add('copied');
              setTimeout(function() {
                copyBtn.innerHTML = '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path></svg>';
                copyBtn.classList.remove('copied');
              }, 2000);
            });
          });
        });

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
