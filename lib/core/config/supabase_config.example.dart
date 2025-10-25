/// Supabase Configuration Template
/// ================================
/// 1. Copy this file and rename to: supabase_config.dart
/// 2. Replace the placeholder values with your actual Supabase credentials
/// 3. Keep supabase_config.dart in .gitignore for security

class SupabaseConfig {
  // Get these from your Supabase project settings
  // https://app.supabase.com/project/YOUR_PROJECT/settings/api
  static const String supabaseUrl = 'https://YOUR_PROJECT_ID.supabase.co';
  static const String supabaseAnonKey = 'YOUR_ANON_KEY_HERE';
  
  // Google Sign-In Configuration
  // Get this from Google Cloud Console
  // https://console.cloud.google.com/apis/credentials
  static const String googleWebClientId = 'YOUR_GOOGLE_WEB_CLIENT_ID.apps.googleusercontent.com';
  
  // Storage Bucket Names
  static const String carImagesBucket = 'car-images';
  static const String userAvatarsBucket = 'user-avatars';
  static const String chatAttachmentsBucket = 'chat-attachments';
  
  // Optional: Edge Functions URLs (if you use them)
  static const String edgeFunctionsUrl = 'https://YOUR_PROJECT_ID.supabase.co/functions/v1';
  
  // Ensure configuration is valid
  static void ensureConfigured() {
    if (supabaseUrl.contains('YOUR_PROJECT_ID') || 
        supabaseAnonKey.contains('YOUR_ANON_KEY')) {
      throw Exception('''
        ⚠️ Supabase configuration is not set up!
        
        Please follow these steps:
        1. Create a Supabase project at https://app.supabase.com
        2. Copy your project URL and anon key from the Settings > API page
        3. Update lib/core/config/supabase_config.dart with your credentials
        4. Make sure supabase_config.dart is in .gitignore
      ''');
    }
  }
}
