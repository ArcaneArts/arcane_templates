import 'package:arcane_jaspr/arcane_jaspr.dart';

import '../components/app_header.dart';
import '../utils/constants.dart';

/// Home screen - landing page for the application
class HomeScreen extends StatelessComponent {
  final bool isDark;
  final VoidCallback? onThemeToggle;

  const HomeScreen({
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
          currentPath: AppRoutes.home,
        ),

        // Hero section
        _HeroSection(),

        // Features section
        _FeaturesSection(),
      ],
    );
  }
}

class _HeroSection extends StatelessComponent {
  const _HeroSection();

  @override
  Component build(BuildContext context) {
    return ArcaneDiv(
      styles: const ArcaneStyleData(
        padding: PaddingPreset.heroY,
        textAlign: TextAlign.center,
      ),
      children: [
        ArcaneColumn(
          crossAxisAlignment: CrossAxisAlignment.center,
          style: const ArcaneStyleData(gap: Gap.lg),
          children: [
            ArcaneDiv(
              styles: const ArcaneStyleData(
                fontSize: FontSize.mega,
                fontWeight: FontWeight.w800,
                textColor: TextColor.primary,
                lineHeight: LineHeight.tight,
              ),
              children: [ArcaneText('Welcome to ${AppConstants.appName}')],
            ),
            ArcaneDiv(
              styles: const ArcaneStyleData(
                fontSize: FontSize.xl,
                textColor: TextColor.muted,
                maxWidth: MaxWidth.text,
              ),
              children: [
                ArcaneText(AppConstants.appDescription),
              ],
            ),
            ArcaneRow(
              mainAxisAlignment: MainAxisAlignment.center,
              style: const ArcaneStyleData(gap: Gap.md),
              children: [
                ArcaneButton(
                  label: 'Get Started',
                  onPressed: () {},
                ),
                ArcaneButton.outline(
                  label: 'Learn More',
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _FeaturesSection extends StatelessComponent {
  const _FeaturesSection();

  @override
  Component build(BuildContext context) {
    return ArcaneDiv(
      styles: const ArcaneStyleData(
        padding: PaddingPreset.sectionY,
        flexGrow: 1,
      ),
      children: [
        ArcaneBox(
          maxWidth: MaxWidth.container,
          margin: MarginPreset.autoX,
          children: [
            ArcaneColumn(
              crossAxisAlignment: CrossAxisAlignment.center,
              style: const ArcaneStyleData(gap: Gap.xxl),
              children: [
                ArcaneDiv(
                  styles: const ArcaneStyleData(
                    fontSize: FontSize.xl3,
                    fontWeight: FontWeight.bold,
                    textColor: TextColor.primary,
                  ),
                  children: [ArcaneText('Features')],
                ),
                ArcaneRow(
                  mainAxisAlignment: MainAxisAlignment.center,
                  style: const ArcaneStyleData(
                    gap: Gap.lg,
                    flexWrap: FlexWrap.wrap,
                  ),
                  children: [
                    _FeatureCard(
                      title: 'Fast & Modern',
                      description:
                          'Built with Dart and Jaspr for blazing fast performance.',
                    ),
                    _FeatureCard(
                      title: 'Arcane Design',
                      description:
                          'Beautiful UI components from the Arcane design system.',
                    ),
                    _FeatureCard(
                      title: 'Full Stack',
                      description:
                          'Works seamlessly with Dart servers and shared models.',
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

class _FeatureCard extends StatelessComponent {
  final String title;
  final String description;

  const _FeatureCard({
    required this.title,
    required this.description,
  });

  @override
  Component build(BuildContext context) {
    return ArcaneCard(
      child: ArcaneDiv(
        styles: const ArcaneStyleData(
          padding: PaddingPreset.lg,
          widthCustom: '320px',
        ),
        children: [
          ArcaneColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            style: const ArcaneStyleData(gap: Gap.sm),
            children: [
              ArcaneDiv(
                styles: const ArcaneStyleData(
                  fontSize: FontSize.lg,
                  fontWeight: FontWeight.w600,
                  textColor: TextColor.primary,
                ),
                children: [ArcaneText(title)],
              ),
              ArcaneDiv(
                styles: const ArcaneStyleData(
                  textColor: TextColor.muted,
                ),
                children: [ArcaneText(description)],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
