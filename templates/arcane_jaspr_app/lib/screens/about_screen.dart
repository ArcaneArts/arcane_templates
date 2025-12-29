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
                // Page title using ArcaneSectionHeader
                ArcaneSectionHeader(
                  heading: 'About',
                  description:
                      '${AppConstants.appName} is a modern web application template built with Jaspr - the Dart web framework.',
                  align: TextAlign.left,
                ),

                // Description text
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
                    margin: MarginPreset.topXl,
                  ),
                  children: [
                    ArcaneSectionHeader(
                      label: 'Quick Start',
                      heading: 'Getting Started',
                      align: TextAlign.left,
                    ),
                  ],
                ),

                // Getting started checklist using ArcaneCheckList
                ArcaneCard(
                  child: ArcaneDiv(
                    styles: const ArcaneStyleData(
                      padding: PaddingPreset.lg,
                    ),
                    children: [
                      ArcaneCheckList(
                        items: [
                          'Run jaspr serve to start the development server',
                          'Edit screens in lib/screens/',
                          'Add routes in lib/routes/app_router.dart',
                          'Build for production with jaspr build',
                        ],
                        iconStyle: CheckListIconStyle.arrow,
                      ),
                    ],
                  ),
                ),

                // Tech stack section
                ArcaneDiv(
                  styles: const ArcaneStyleData(
                    margin: MarginPreset.topXl,
                  ),
                  children: [
                    ArcaneSectionHeader(
                      label: 'Built With',
                      heading: 'Tech Stack',
                      align: TextAlign.left,
                    ),
                  ],
                ),

                // Tech stack badges
                ArcaneRow(
                  style: const ArcaneStyleData(
                    gap: Gap.sm,
                    flexWrap: FlexWrap.wrap,
                  ),
                  children: [
                    ArcaneStatusBadge(
                      label: 'Dart',
                      variant: StatusBadgeVariant.info,
                    ),
                    ArcaneStatusBadge(
                      label: 'Jaspr',
                      variant: StatusBadgeVariant.success,
                    ),
                    ArcaneStatusBadge(
                      label: 'Arcane UI',
                      variant: StatusBadgeVariant.info,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
