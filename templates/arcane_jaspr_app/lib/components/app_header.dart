import 'package:arcane_jaspr/arcane_jaspr.dart';

import '../utils/constants.dart';

/// Shared application header with navigation and theme toggle
class AppHeader extends StatelessComponent {
  final bool isDark;
  final VoidCallback? onThemeToggle;
  final String currentPath;

  const AppHeader({
    super.key,
    this.isDark = true,
    this.onThemeToggle,
    this.currentPath = '/',
  });

  @override
  Component build(BuildContext context) {
    return ArcaneBar(
      leading: [
        // Logo/Brand link
        ArcaneLink(
          href: AppRoutes.home,
          styles: const ArcaneStyleData(
            textDecoration: TextDecoration.none,
          ),
          child: ArcaneDiv(
            styles: const ArcaneStyleData(
              display: Display.flex,
              alignItems: AlignItems.center,
              gap: Gap.sm,
            ),
            children: [
              ArcaneDiv(
                styles: const ArcaneStyleData(
                  fontWeight: FontWeight.bold,
                  fontSize: FontSize.lg,
                  textColor: TextColor.primary,
                ),
                children: [ArcaneText(AppConstants.appName)],
              ),
            ],
          ),
        ),
      ],
      trailing: [
        // Navigation links
        _buildNavLink('Home', AppRoutes.home),
        _buildNavLink('About', AppRoutes.about),

        // GitHub link (if configured)
        if (AppConstants.githubUrl.isNotEmpty)
          ArcaneLink.external(
            href: AppConstants.githubUrl,
            styles: const ArcaneStyleData(
              textDecoration: TextDecoration.none,
            ),
            child: ArcaneButton.ghost(
              label: 'GitHub',
              onPressed: () {},
            ),
          ),

        // Theme toggle button
        _buildThemeToggle(),
      ],
    );
  }

  Component _buildNavLink(String label, String href) {
    final isActive = currentPath == href;

    return ArcaneLink(
      href: href,
      styles: const ArcaneStyleData(
        textDecoration: TextDecoration.none,
      ),
      child: ArcaneButton.ghost(
        label: label,
        onPressed: () {},
        styles: ArcaneStyleData(
          textColor: isActive ? TextColor.accent : TextColor.onSurfaceVariant,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  /// Theme toggle button with sun/moon icons
  Component _buildThemeToggle() {
    return ArcaneDiv(
      id: 'theme-toggle',
      styles: const ArcaneStyleData(
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        widthCustom: '40px',
        heightCustom: '40px',
        border: BorderPreset.subtle,
        borderRadius: Radius.md,
        background: Background.surface,
        textColor: TextColor.primary,
        cursor: Cursor.pointer,
        transition: Transition.allFast,
      ),
      events: {
        'click': (_) {
          onThemeToggle?.call();
        },
      },
      children: [
        ArcaneDiv(
          styles: const ArcaneStyleData(
            display: Display.flex,
            lineHeight: LineHeight.none,
          ),
          children: [
            if (isDark) ArcaneIcon.sun(size: IconSize.lg),
            if (!isDark) ArcaneIcon.moon(size: IconSize.lg),
          ],
        ),
      ],
    );
  }
}
