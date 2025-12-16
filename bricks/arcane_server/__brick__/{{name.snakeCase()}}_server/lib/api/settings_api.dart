import 'dart:convert';

import 'package:{{name.snakeCase()}}_server/main.dart';
import 'package:{{name.snakeCase()}}_models/{{name.snakeCase()}}_models.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// Settings API endpoints for user settings management
class SettingsAPI implements Routing {
  @override
  String get prefix => "/api/settings";

  @override
  Router get router => Router()
    ..get("/<userId>", _getSettings)
    ..post("/<userId>/theme", _updateTheme);

  /// Get user settings
  Future<Response> _getSettings(Request request, String userId) async {
    try {
      final settings = await {{class_name.pascalCase()}}Server.svcUser.getUserSettings(userId);

      if (settings == null) {
        return Response.notFound('{"error": "Settings not found"}');
      }

      return Response.ok(
        jsonEncode({'themeMode': settings.themeMode.name}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(body: '{"error": "$e"}');
    }
  }

  /// Update user theme
  Future<Response> _updateTheme(Request request, String userId) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body);
      final themeName = data['themeMode'] as String?;

      if (themeName == null) {
        return Response.badRequest(body: '{"error": "Missing themeMode"}');
      }

      final themeMode = ThemeMode.values.firstWhere(
        (t) => t.name == themeName,
        orElse: () => ThemeMode.system,
      );

      await {{class_name.pascalCase()}}Server.svcUser.updateTheme(userId, themeMode);

      return Response.ok('{"success": true}');
    } catch (e) {
      return Response.internalServerError(body: '{"error": "$e"}');
    }
  }
}
