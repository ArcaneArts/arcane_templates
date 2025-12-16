import 'package:arcane_models/arcane_models.dart';
import 'package:fast_log/fast_log.dart';

/// Service for managing user data and operations
class UserService {
  UserService() {
    verbose("UserService initialized");
  }

  /// Get user by ID
  Future<User?> getUser(String userId) async {
    try {
      return await $crud.getUser(userId);
    } catch (e) {
      error("Failed to get user $userId: $e");
      return null;
    }
  }

  /// Update user information
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      final user = await getUser(userId);
      if (user == null) {
        throw Exception("User not found");
      }

      // Update user fields based on data map
      final updatedUser = User(
        name: data['name'] as String? ?? user.name,
        email: data['email'] as String? ?? user.email,
        profileHash: data['profileHash'] as String? ?? user.profileHash,
      );

      await $crud.setUser(userId, updatedUser);
      verbose("Updated user $userId");
    } catch (e) {
      error("Failed to update user $userId: $e");
      rethrow;
    }
  }

  /// List users with pagination
  Future<List<User>> listUsers({int limit = 10}) async {
    try {
      return await $crud.getUsers((ref) => ref.limit(limit));
    } catch (e) {
      error("Failed to list users: $e");
      return [];
    }
  }

  /// Get user settings
  Future<UserSettings?> getUserSettings(String userId) async {
    try {
      final user = await getUser(userId);
      if (user == null) return null;

      return await $crud.userModel(userId).getUserSettings();
    } catch (e) {
      error("Failed to get settings for user $userId: $e");
      return null;
    }
  }

  /// Update theme mode for user
  Future<void> updateTheme(String userId, ThemeMode themeMode) async {
    try {
      final user = await getUser(userId);
      if (user == null) {
        throw Exception("User not found");
      }

      final updatedSettings = UserSettings(themeMode: themeMode);
      await $crud.userModel(userId).setUserSettings(updatedSettings);

      verbose("Updated theme for user $userId to ${themeMode.name}");
    } catch (e) {
      error("Failed to update theme for user $userId: $e");
      rethrow;
    }
  }

  /// Create a new user
  Future<String> createUser({
    required String name,
    required String email,
    String? profileHash,
  }) async {
    try {
      final user = User(name: name, email: email, profileHash: profileHash);
      final created = await $crud.addUser(user);

      // Create default settings
      await created.setUserSettings(UserSettings(themeMode: ThemeMode.system));

      verbose("Created new user ${created.userId}");
      return created.userId;
    } catch (e) {
      error("Failed to create user: $e");
      rethrow;
    }
  }

  /// Delete a user
  Future<void> deleteUser(String userId) async {
    try {
      await $crud.deleteUser(userId);
      verbose("Deleted user $userId");
    } catch (e) {
      error("Failed to delete user $userId: $e");
      rethrow;
    }
  }
}
