/// Application constants
class AppConstants {
  AppConstants._();

  /// Application name displayed in header
  static const String appName = 'ArcaneJasprApp';

  /// Application description
  static const String appDescription = 'A modern web application built with Jaspr and Arcane UI';

  /// GitHub repository URL (leave empty to hide GitHub link)
  static const String githubUrl = '';
}

/// Route constants for the application
abstract class AppRoutes {
  static const String home = '/';
  static const String about = '/about';
}

/// API configuration
abstract class ApiConfig {
  // Server API URL - update with your production URL
  static const String? serverApiUrl = null;
}
