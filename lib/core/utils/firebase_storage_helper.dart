import 'package:wolfera/services/supabase_service.dart';
import 'dart:io';

class SupabaseStorageHelper {
  static Future<String> uploadFile(File file, String storagePath) async {
    final bytes = await file.readAsBytes();
    
    await SupabaseService.client.storage
        .from('uploads')
        .uploadBinary(storagePath, bytes);
    
    final publicUrl = SupabaseService.client.storage
        .from('uploads')
        .getPublicUrl(storagePath);
    
    return publicUrl;
  }
  
  static Future<void> deleteFile(String storagePath) async {
    await SupabaseService.client.storage
        .from('uploads')
        .remove([storagePath]);
  }
}
