import 'package:{{name.snakeCase()}}_models/{{name.snakeCase()}}_models.dart';
import 'package:fast_log/fast_log.dart';

/// Service for handling server commands
class CommandService {
  CommandService() {
    verbose("CommandService initialized");
  }

  /// Execute a server command
  Future<String> executeCommand({
    required String userId,
    required Map<String, dynamic> commandData,
  }) async {
    try {
      // Create command in Firestore
      final command = ServerCommand(user: userId);
      final created = await $crud.addServerCommand(command);

      verbose("Created command ${created.serverCommandId} for user $userId");

      // TODO: Process command based on commandData
      // This is where you would dispatch the command to appropriate handlers

      return created.serverCommandId;
    } catch (e) {
      error("Failed to execute command for user $userId: $e");
      rethrow;
    }
  }

  /// Get command status
  Future<Map<String, dynamic>?> getCommandStatus(String commandId) async {
    try {
      final command = await $crud.getServerCommand(commandId);

      if (command == null) {
        return null;
      }

      // Get response if available
      final response = await command.getServerResponse();

      return {
        'commandId': commandId,
        'userId': command.user,
        'hasResponse': response != null,
        'response': response != null
            ? {
                'user': response.user,
                'type': response.runtimeType.toString(),
              }
            : null,
      };
    } catch (e) {
      error("Failed to get command status for $commandId: $e");
      return null;
    }
  }

  /// Set command response
  Future<void> setCommandResponse(
    String commandId,
    ServerResponse response,
  ) async {
    try {
      final command = await $crud.getServerCommand(commandId);

      if (command == null) {
        throw Exception("Command not found");
      }

      await command.setServerResponse(response);
      verbose("Set response for command $commandId");
    } catch (e) {
      error("Failed to set response for command $commandId: $e");
      rethrow;
    }
  }
}
