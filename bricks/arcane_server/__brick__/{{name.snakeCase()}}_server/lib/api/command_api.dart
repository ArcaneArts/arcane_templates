import 'dart:convert';

import 'package:{{name.snakeCase()}}_server/main.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// Command API endpoints for server command handling
class CommandAPI implements Routing {
  @override
  String get prefix => "/api/command";

  @override
  Router get router => Router()
    ..post("/execute", _executeCommand)
    ..get("/status/<commandId>", _getCommandStatus);

  /// Execute a server command
  Future<Response> _executeCommand(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body);
      final userId = request.userId;

      if (userId == null) {
        return Response.forbidden('{"error": "Not authenticated"}');
      }

      final commandId = await {{class_name.pascalCase()}}Server.svcCommand.executeCommand(
        userId: userId,
        commandData: data,
      );

      return Response.ok(
        jsonEncode({'commandId': commandId, 'status': 'queued'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(body: '{"error": "$e"}');
    }
  }

  /// Get command status
  Future<Response> _getCommandStatus(Request request, String commandId) async {
    try {
      final status = await {{class_name.pascalCase()}}Server.svcCommand.getCommandStatus(commandId);

      if (status == null) {
        return Response.notFound('{"error": "Command not found"}');
      }

      return Response.ok(
        jsonEncode(status),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(body: '{"error": "$e"}');
    }
  }
}

/// Extension for request authentication
extension _RequestAuth on Request {
  String? get userId => headers["x-user-id"];
}
