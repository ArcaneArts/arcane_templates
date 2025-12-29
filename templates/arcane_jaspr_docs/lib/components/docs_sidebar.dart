import 'package:arcane_jaspr/arcane_jaspr.dart';

import '../utils/constants.dart';

/// Documentation sidebar with navigation groups
class DocsSidebar extends StatelessComponent {
  final String currentPath;

  const DocsSidebar({
    super.key,
    required this.currentPath,
  });

  @override
  Component build(BuildContext context) {
    return ArcaneSideContent(
      styles: const ArcaneStyleData(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        widthCustom: '280px',
        minHeight: '100vh',
        flexShrink: 0,
        background: Background.surface,
        borderRight: BorderPreset.subtle,
      ),
      children: [
        // Header
        ArcaneDiv(
          styles: const ArcaneStyleData(
            padding: PaddingPreset.lg,
            borderBottom: BorderPreset.subtle,
            background: Background.surfaceVariant,
          ),
          children: [
            ArcaneLink(
              href: '${AppConstants.baseUrl}/',
              styles: const ArcaneStyleData(
                textDecoration: TextDecoration.none,
              ),
              child: ArcaneDiv(
                styles: const ArcaneStyleData(
                  fontWeight: FontWeight.bold,
                  fontSize: FontSize.lg,
                  textColor: TextColor.primary,
                ),
                children: [ArcaneText(AppConstants.siteName)],
              ),
            ),
            ArcaneDiv(
              styles: const ArcaneStyleData(
                fontSize: FontSize.sm,
                textColor: TextColor.muted,
                margin: MarginPreset.topXs,
              ),
              children: [const ArcaneText('Documentation')],
            ),
          ],
        ),

        // Navigation with custom scrollable area
        ArcaneScrollArea(
          maxHeight: 'calc(100vh - 100px)',
          child: ArcaneNav(
            styles: const ArcaneStyleData(
              padding: PaddingPreset.md,
              flexGrow: 1,
            ),
            children: [
              // Getting Started section
              _buildNavSection('Getting Started', [
                _buildNavItem(label: 'Introduction', href: '/docs'),
                _buildNavItem(
                    label: 'Installation', href: '/docs/installation'),
                _buildNavItem(label: 'Quick Start', href: '/docs/quick-start'),
              ]),

              // Guides section
              _buildNavSection('Guides', [
                _buildNavItem(label: 'Deployment', href: '/guides/deployment'),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  Component _buildNavSection(String title, List<Component> items) {
    return ArcaneDiv(
      styles: const ArcaneStyleData(
        margin: MarginPreset.bottomMd,
        borderBottom: BorderPreset.subtle,
        padding: PaddingPreset.bottomMd,
      ),
      children: [
        // Section header with background
        ArcaneDiv(
          styles: const ArcaneStyleData(
            fontSize: FontSize.xs,
            fontWeight: FontWeight.w700,
            margin: MarginPreset.bottomSm,
            textTransform: TextTransform.uppercase,
            letterSpacing: LetterSpacing.wide,
            padding: PaddingPreset.smMd,
            background: Background.surfaceVariant,
            borderRadius: Radius.sm,
            textColor: TextColor.onSurface,
          ),
          children: [ArcaneText(title)],
        ),
        // Navigation items
        ArcaneDiv(
          styles: const ArcaneStyleData(
            padding: PaddingPreset.horizontalSm,
          ),
          children: items,
        ),
      ],
    );
  }

  /// Build a navigation item that links to a page
  Component _buildNavItem({
    required String label,
    required String href,
  }) {
    final fullHref = '${AppConstants.baseUrl}$href';
    final isActive = currentPath == href || currentPath == '$href/';

    return ArcaneLink(
      href: fullHref,
      styles: ArcaneStyleData(
        display: Display.flex,
        gap: Gap.sm,
        fontSize: FontSize.sm,
        borderRadius: Radius.md,
        margin: MarginPreset.bottomXs,
        transition: Transition.allFast,
        crossAxisAlignment: CrossAxisAlignment.center,
        textDecoration: TextDecoration.none,
        padding: PaddingPreset.buttonSm,
        textColor: isActive ? TextColor.accent : TextColor.onSurfaceVariant,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
        background:
            isActive ? Background.accentContainer : Background.transparent,
        borderLeft: isActive ? BorderPreset.accent : BorderPreset.none,
        raw: isActive
            ? const {'border-left-width': '3px'}
            : const {'border-left': '3px solid transparent'},
      ),
      child: ArcaneSpan(child: ArcaneText(label)),
    );
  }
}
