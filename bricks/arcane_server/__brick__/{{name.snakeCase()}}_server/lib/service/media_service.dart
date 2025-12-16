import 'dart:typed_data';

import 'package:fast_log/fast_log.dart';
import 'package:google_cloud/google_cloud.dart';
import 'package:mime/mime.dart';
import 'package:uuid/uuid.dart';

import 'package:{{name.snakeCase()}}_server/main.dart';

/// Service for handling media uploads and storage
class MediaService {
  late final Storage _storage;
  final Uuid _uuid = const Uuid();

  MediaService() {
    _storage = Storage();
    verbose("MediaService initialized");
  }

  /// Upload media to Firebase Storage
  Future<String> uploadMedia({
    required String userId,
    required Uint8List data,
    required String fileName,
    String? folder,
  }) async {
    try {
      final mimeType = lookupMimeType(fileName) ?? 'application/octet-stream';
      final id = _uuid.v4();
      final path = folder != null
          ? '$folder/$userId/$id/$fileName'
          : 'media/$userId/$id/$fileName';

      verbose("Uploading media to $path");

      // Upload to Firebase Storage
      final bucketRef = _storage.bucket(bucket);
      final fileRef = bucketRef.file(path);

      await fileRef.writeAsBytes(data, contentType: mimeType);

      // Make the file publicly accessible and get URL
      await fileRef.makePublic();
      final downloadUrl = fileRef.publicUrl;

      verbose("Media uploaded successfully: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      error("Failed to upload media for user $userId: $e");
      rethrow;
    }
  }

  /// Delete media from Firebase Storage
  Future<void> deleteMedia(String path) async {
    try {
      verbose("Deleting media at $path");

      final bucketRef = _storage.bucket(bucket);
      final fileRef = bucketRef.file(path);

      await fileRef.delete();
      verbose("Media deleted successfully");
    } catch (e) {
      error("Failed to delete media at $path: $e");
      rethrow;
    }
  }

  /// Get signed URL for private media
  Future<String> getSignedUrl(String path, {Duration? expiry}) async {
    try {
      final bucketRef = _storage.bucket(bucket);
      final fileRef = bucketRef.file(path);

      // Generate a signed URL (valid for specified duration)
      final url = await fileRef.signedUrl(
        expiry ?? const Duration(hours: 1),
      );

      return url;
    } catch (e) {
      error("Failed to get signed URL for $path: $e");
      rethrow;
    }
  }
}
