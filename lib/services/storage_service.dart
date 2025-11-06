import 'dart:io';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:path/path.dart' as path; // Commented out - not in dependencies
import 'package:uuid/uuid.dart';
import 'package:wolfera/services/nsfw_moderation_service.dart';

class StorageService {
  static final SupabaseClient _client = Supabase.instance.client;
  static const _uuid = Uuid();
  
  // Bucket names
  static const String userAvatarsBucket = 'user-avatars';
  static const String carImagesBucket = 'car-images';
  static const String chatAttachmentsBucket = 'chat-attachments';

  /// Upload user avatar
  /// Returns the public URL of the uploaded avatar
  static Future<String?> uploadAvatar({
    required String userId,
    required dynamic imageFile, // Can be File or Uint8List
  }) async {
    try {
      // Prepare file data
      Uint8List fileBytes;
      String fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      if (imageFile is File) {
        fileBytes = await imageFile.readAsBytes();
      } else if (imageFile is Uint8List) {
        fileBytes = imageFile;
      } else {
        throw Exception('Invalid image file type');
      }

      // On-device NSFW moderation (fail-open inside service). Return null to block upload.
      final _allowedAvatar = await NsfwModerationService.isImageAllowed(fileBytes);
      if (!_allowedAvatar) {
        return null;
      }

      // Upload path following RLS policy: {userId}/filename
      final uploadPath = '$userId/$fileName';
      
      // Delete old avatar if exists
      try {
        final List<FileObject> files = await _client.storage
            .from(userAvatarsBucket)
            .list(path: '$userId/');
        
        for (final file in files) {
          if (file.name.startsWith('avatar_')) {
            await _client.storage
                .from(userAvatarsBucket)
                .remove(['$userId/${file.name}']);
          }
        }
      } catch (e) {
        // Ignore errors when listing/deleting old avatars
        // Could not clean old avatars: $e
      }
      
      // Upload new avatar
      await _client.storage
          .from(userAvatarsBucket)
          .uploadBinary(
            uploadPath,
            fileBytes,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true,
            ),
          );
      
      // Get public URL
      final publicUrl = _client.storage
          .from(userAvatarsBucket)
          .getPublicUrl(uploadPath);
      
      // Avatar uploaded successfully
      return publicUrl;
    } catch (e) {
      // Avatar upload failed: $e
      return null;
    }
  }

  /// Upload car image
  /// Returns the public URL of the uploaded image
  static Future<String?> uploadCarImage({
    required String userId,
    required String carId,
    required dynamic imageFile, // Can be File or Uint8List
    String? customFileName,
  }) async {
    try {
      // Prepare file data
      Uint8List fileBytes;
      String fileName = customFileName ??
          'car_${DateTime.now().millisecondsSinceEpoch}_${_uuid.v4().substring(0, 8)}.jpg';
      
      if (imageFile is File) {
        fileBytes = await imageFile.readAsBytes();
        // Use original extension if available
        if (customFileName == null) {
          // Force .jpg to align with our UI conversion
          fileName = 'car_${DateTime.now().millisecondsSinceEpoch}_${_uuid.v4().substring(0, 8)}.jpg';
        }
      } else if (imageFile is Uint8List) {
        fileBytes = imageFile;
      } else {
        throw Exception('Invalid image file type');
      }

      // On-device NSFW moderation (fail-open inside service). Return null to block upload.
      final _allowedCarImg = await NsfwModerationService.isImageAllowed(fileBytes);
      if (!_allowedCarImg) {
        return null;
      }

      // Upload path following RLS policy: {userId}/{carId}/filename
      final uploadPath = '$userId/$carId/$fileName';
      
      // Upload image
      await _client.storage
          .from(carImagesBucket)
          .uploadBinary(
            uploadPath,
            fileBytes,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false, // Don't overwrite car images
              contentType: 'image/jpeg',
            ),
          );
      
      // Get public URL
      final publicUrl = _client.storage
          .from(carImagesBucket)
          .getPublicUrl(uploadPath);
      
      // Car image uploaded successfully
      return publicUrl;
    } catch (e) {
      // Car image upload failed: $e
      return null;
    }
  }

  /// Upload multiple car images
  /// Returns a list of public URLs
  static Future<List<String>> uploadCarImages({
    required String userId,
    required String carId,
    required List<dynamic> imageFiles, // List of File or Uint8List
  }) async {
    final List<String> uploadedUrls = [];
    
    for (int i = 0; i < imageFiles.length; i++) {
      final url = await uploadCarImage(
        userId: userId,
        carId: carId,
        imageFile: imageFiles[i],
        customFileName: 'car_${i + 1}_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      
      if (url != null) {
        uploadedUrls.add(url);
      }
    }
    
    return uploadedUrls;
  }

  /// Upload chat attachment
  /// Returns the URL of the uploaded attachment
  static Future<String?> uploadChatAttachment({
    required String userId,
    required String conversationId,
    required dynamic attachmentFile, // Can be File or Uint8List
    String? customFileName,
  }) async {
    try {
      // Prepare file data
      Uint8List fileBytes;
      String fileName = customFileName ?? 
          'attachment_${DateTime.now().millisecondsSinceEpoch}_${_uuid.v4().substring(0, 8)}';
      
      if (attachmentFile is File) {
        fileBytes = await attachmentFile.readAsBytes();
        // Use original extension if available
        if (customFileName == null) {
          final ext = attachmentFile.path.split('.').last;
          if (ext.isNotEmpty) {
            fileName = 'attachment_${DateTime.now().millisecondsSinceEpoch}_${_uuid.v4().substring(0, 8)}$ext';
          }
        }
      } else if (attachmentFile is Uint8List) {
        fileBytes = attachmentFile;
      } else {
        throw Exception('Invalid attachment file type');
      }

      // Upload path following RLS policy: {userId}/{conversationId}/filename
      final uploadPath = '$userId/$conversationId/$fileName';
      
      // Upload attachment
      await _client.storage
          .from(chatAttachmentsBucket)
          .uploadBinary(
            uploadPath,
            fileBytes,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false,
            ),
          );
      
      // Get signed URL for private bucket (valid for 1 hour)
      final signedUrl = await _client.storage
          .from(chatAttachmentsBucket)
          .createSignedUrl(uploadPath, 3600);
      
      // Chat attachment uploaded successfully
      return signedUrl;
    } catch (e) {
      // Chat attachment upload failed: $e
      return null;
    }
  }

  /// Get public URL for a file in a public bucket
  static String getPublicUrl(String bucket, String path) {
    return _client.storage
        .from(bucket)
        .getPublicUrl(path);
  }

  /// Get signed URL for a file in a private bucket
  static Future<String> getSignedUrl(String bucket, String path, {int expiresIn = 3600}) async {
    return await _client.storage
        .from(bucket)
        .createSignedUrl(path, expiresIn);
  }

  /// Delete a file from storage
  static Future<bool> deleteFile(String bucket, String path) async {
    try {
      await _client.storage
          .from(bucket)
          .remove([path]);
      // File deleted successfully
      return true;
    } catch (e) {
      // File deletion failed: $e
      return false;
    }
  }

  /// Delete multiple files from storage
  static Future<void> deleteFiles(String bucket, List<String> paths) async {
    try {
      await _client.storage
          .from(bucket)
          .remove(paths);
      // Files deleted successfully
    } catch (e) {
      // Files deletion failed: $e
    }
  }

  /// List files in a directory
  static Future<List<FileObject>> listFiles(String bucket, String path) async {
    try {
      final files = await _client.storage
          .from(bucket)
          .list(path: path);
      return files;
    } catch (e) {
      // Failed to list files: $e
      return [];
    }
  }

  /// Delete all car images for a specific car
  static Future<void> deleteCarImages({
    required String userId,
    required String carId,
  }) async {
    try {
      final files = await listFiles(carImagesBucket, '$userId/$carId');
      final paths = files.map((f) => '$userId/$carId/${f.name}').toList();
      
      if (paths.isNotEmpty) {
        await deleteFiles(carImagesBucket, paths);
      }
    } catch (e) {
      // Failed to delete car images: $e
    }
  }

  /// Get the current user ID
  static String? get currentUserId {
    return Supabase.instance.client.auth.currentUser?.id;
  }

  /// Validate file size (max 10MB by default)
  static bool isFileSizeValid(File file, {int maxSizeInMB = 10}) {
    final fileSize = file.lengthSync();
    final maxSize = maxSizeInMB * 1024 * 1024; // Convert MB to bytes
    return fileSize <= maxSize;
  }

  /// Validate file size for Uint8List
  static bool isByteSizeValid(Uint8List bytes, {int maxSizeInMB = 10}) {
    final maxSize = maxSizeInMB * 1024 * 1024; // Convert MB to bytes
    return bytes.length <= maxSize;
  }

  /// Get file extension from file path
  static String getFileExtension(String filePath) {
    final parts = filePath.split('.');
    if (parts.length > 1) {
      return '.${parts.last.toLowerCase()}';
    }
    return '';
  }

  /// Check if file is an image
  static bool isImageFile(String filePath) {
    final ext = getFileExtension(filePath);
    const imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'];
    return imageExtensions.contains(ext);
  }
}
