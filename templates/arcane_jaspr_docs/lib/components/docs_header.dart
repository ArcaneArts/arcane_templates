import 'package:arcane_jaspr/arcane_jaspr.dart';

import '../utils/constants.dart';

/// Documentation site header with navigation, search, and theme toggle
class DocsHeader extends StatelessComponent {
  final bool isDark;
  final VoidCallback? onThemeToggle;

  const DocsHeader({
    super.key,
    this.isDark = false,
    this.onThemeToggle,
  });

  @override
  Component build(BuildContext context) {
    final base = AppConstants.baseUrl;
    return ArcaneBar(
      leading: [
        // Logo/title link using ArcaneLink
        ArcaneLink(
          href: '$base/',
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
                children: [ArcaneText(AppConstants.siteName)],
              ),
            ],
          ),
        ),
      ],
      trailing: [
        // Search bar using ArcaneSearch (updated SVG icons in 2.7.0)
        ArcaneDiv(
          styles: const ArcaneStyleData(
            margin: MarginPreset.rightMd,
            widthCustom: '240px',
          ),
          children: [
            ArcaneSearch(
              placeholder: 'Search docs...',
            ),
          ],
        ),

        // Navigation links using ArcaneLink
        ArcaneLink(
          href: '$base/docs',
          styles: const ArcaneStyleData(
            textDecoration: TextDecoration.none,
          ),
          child: ArcaneButton.ghost(
            label: 'Docs',
            onPressed: () {},
          ),
        ),
        ArcaneLink(
          href: '$base/guides',
          styles: const ArcaneStyleData(
            textDecoration: TextDecoration.none,
          ),
          child: ArcaneButton.ghost(
            label: 'Guides',
            onPressed: () {},
          ),
        ),
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

        // Theme toggle using the new ArcaneThemeToggle component
        ArcaneThemeToggle(
          isDark: isDark,
          onChanged: onThemeToggle != null ? (_) => onThemeToggle!() : null,
        ),
      ],
    );
  }
}
