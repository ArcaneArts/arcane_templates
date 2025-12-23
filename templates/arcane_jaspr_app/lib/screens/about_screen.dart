import 'package:arcane_jaspr/arcane_jaspr.dart';

import '../components/app_header.dart';
import '../utils/constants.dart';

/// About screen - information about the application
class AboutScreen extends StatelessComponent {
  final bool isDark;
  final VoidCallback? onThemeToggle;

  const AboutScreen({
    super.key,
    this.isDark = true,
    this.onThemeToggle,
  });

  @override
  Component build(BuildContext context) {
    return ArcaneDiv(
      styles: const ArcaneStyleData(
        minHeight: '100vh',
        display: Display.flex,
        flexDirection: FlexDirection.column,
      ),
      children: [
        // Header
        AppHeader(
          isDark: isDark,
          onThemeToggle: onThemeToggle,
          currentPath: AppRoutes.about,
        ),

        // Content
        _Content(),
      ],
    );
  }
}

class _Content extends StatelessComponent {
  const _Content();

  @override
  Component build(BuildContext context) {
    return ArcaneDiv(
      styles: const ArcaneStyleData(
        padding: PaddingPreset.sectionY,
        flexGrow: 1,
      ),
      children: [
        ArcaneBox(
          maxWidth: MaxWidth.content,
          margin: MarginPreset.autoX,
          children: [
            ArcaneColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              style: const ArcaneStyleData(gap: Gap.lg),
              children: [
                // Page title
                ArcaneDiv(
                  styles: const ArcaneStyleData(
                    fontSize: FontSize.xl3,
                    fontWeight: FontWeight.bold,
                    textColor: TextColor.primary,
                  ),
                  children: [ArcaneText('About')],
                ),

                // Description
                ArcaneDiv(
                  styles: const ArcaneStyleData(
                    fontSize: FontSize.lg,
                    textColor: TextColor.muted,
                    lineHeight: LineHeight.relaxed,
                  ),
                  children: [
                    ArcaneText(
                      '${AppConstants.appName} is a modern web application template built with Jaspr - the Dart web framework.',
                    ),
                  ],
                ),
                ArcaneDiv(
                  styles: const ArcaneStyleData(
                    fontSize: FontSize.lg,
                    textColor: TextColor.muted,
                    lineHeight: LineHeight.relaxed,
                  ),
                  children: [
                    ArcaneText(
                      'This template includes the Arcane design system for beautiful, '
                      'consistent UI components, along with routing, logging, and '
                      'a ready-to-use project structure.',
                    ),
                  ],
                ),

                // Getting Started section
                ArcaneDiv(
                  styles: const ArcaneStyleData(
                    fontSize: FontSize.xl2,
                    fontWeight: FontWeight.bold,
                    textColor: TextColor.primary,
                    margin: MarginPreset.topXl,
                  ),
                  children: [ArcaneText('Getting Started')],
                ),

                ArcaneCard(
                  child: ArcaneDiv(
                    styles: const ArcaneStyleData(
                      padding: PaddingPreset.lg,
                    ),
                    children: [
                      _ListItem(
                          content:
                              'Run jaspr serve to start the development server'),
                      _ListItem(content: 'Edit screens in lib/screens/'),
                      _ListItem(
                          content: 'Add routes in lib/routes/app_router.dart'),
                      _ListItem(
                          content: 'Build for production with jaspr build'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _ListItem extends StatelessComponent {
  final String content;

  const _ListItem({required this.content});

  @override
  Component build(BuildContext context) {
    return ArcaneRow(
      style: const ArcaneStyleData(
        gap: Gap.sm,
        margin: MarginPreset.bottomSm,
      ),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ArcaneDiv(
          styles: const ArcaneStyleData(
            textColor: TextColor.accent,
            fontWeight: FontWeight.bold,
          ),
          children: [ArcaneText('•')],
        ),
        ArcaneDiv(
          styles: const ArcaneStyleData(
            textColor: TextColor.muted,
          ),
          children: [ArcaneText(content)],
        ),
      ],
    );
  }
}
