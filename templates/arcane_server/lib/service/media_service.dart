import 'dart:io';
import 'dart:typed_data';

import 'package:arcane_admin/arcane_admin.dart';
import 'package:arcane_server/main.dart';
import 'package:fast_log/fast_log.dart';
import 'package:mime/mime.dart';
import 'package:uuid/uuid.dart';

/// Service for managing media files (images, videos, etc.)
/// Uses Firebase Storage via ArcaneAdmin
class MediaService {
  final _uuid = const Uuid();

  MediaService() {
    verbose("MediaService initialized with bucket: $bucket");
  }

  /// Upload a file to Cloud Storage
  Future<String> uploadFile({
    required File file,
    required String userId,
    String? customName,
  }) async {
    try {
      final fileName = customName ?? _uuid.v4();
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      final extension = mimeType.split('/').last;
      final fullName = '$fileName.$extension';
      final path = 'users/$userId/media/$fullName';

      verbose("Uploading file to $path");

      final bytes = await file.readAsBytes();
      await _uploadToStorage(path, bytes);

      verbose("File uploaded successfully: $path");
      return path;
    } catch (e) {
      error("Failed to upload file: $e");
      rethrow;
    }
  }

  /// Upload bytes directly
  Future<String> uploadBytes({
    required List<int> bytes,
    required String userId,
    required String fileName,
    String? mimeType,
  }) async {
    try {
      final path = 'users/$userId/media/$fileName';

      verbose("Uploading bytes to $path");

      await _uploadToStorage(path, Uint8List.fromList(bytes));

      verbose("Bytes uploaded successfully: $path");
      return path;
    } catch (e) {
      error("Failed to upload bytes: $e");
      rethrow;
    }
  }

  /// Internal upload method using Firebase Admin Storage
  Future<void> _uploadToStorage(String path, Uint8List bytes) async {
    final storageRef = ArcaneAdmin.storage.bucket(bucket).ref(path);
    await storageRef.write(bytes);
  }

  /// Read a file from storage
  Future<Uint8List> readFile(String path) async {
    try {
      final storageRef = ArcaneAdmin.storage.bucket(bucket).ref(path);
      return await storageRef.read();
    } catch (e) {
      error("Failed to read file $path: $e");
      rethrow;
    }
  }

  /// Get the storage path for a user's file
  /// Note: Use this to construct URLs or reference files
  String getStoragePath(String userId, String fileName) {
    return 'users/$userId/media/$fileName';
  }

  /// Get the full GCS URI for a file (gs://bucket/path)
  String getGcsUri(String path) {
    return 'gs://$bucket/$path';
  }
}
