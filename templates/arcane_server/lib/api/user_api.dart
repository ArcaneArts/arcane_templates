import 'dart:convert';

import 'package:arcane_server/main.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// User API endpoints for user management
class UserAPI implements Routing {
  @override
  String get prefix => "/api/user";

  @override
  Router get router => Router()
    ..get("/info/<userId>", _getUserInfo)
    ..post("/update/<userId>", _updateUser)
    ..get("/list", _listUsers);

  /// Get user information
  Future<Response> _getUserInfo(Request request, String userId) async {
    try {
      // Example: Fetch user from service
      final user = await ArcaneServer.svcUser.getUser(userId);

      if (user == null) {
        return Response.notFound('{"error": "User not found"}');
      }

      return Response.ok(
        jsonEncode({'userId': userId, 'name': user.name, 'email': user.email}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(body: '{"error": "$e"}');
    }
  }

  /// Update user information
  Future<Response> _updateUser(Request request, String userId) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body);

      await ArcaneServer.svcUser.updateUser(userId, data);

      return Response.ok('{"success": true}');
    } catch (e) {
      return Response.internalServerError(body: '{"error": "$e"}');
    }
  }

  /// List all users (paginated)
  Future<Response> _listUsers(Request request) async {
    try {
      final limit = int.tryParse(request.param('limit') ?? '10') ?? 10;

      final users = await ArcaneServer.svcUser.listUsers(limit: limit);

      return Response.ok(
        jsonEncode({
          'users': users
              .map((u) => {'name': u.name, 'email': u.email})
              .toList(),
          'count': users.length,
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(body: '{"error": "$e"}');
    }
  }
}
