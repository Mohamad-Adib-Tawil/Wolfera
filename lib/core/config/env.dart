/// Centralized environment configuration.
///
/// Provide values via --dart-define at build/run time, e.g.:
///   flutter run \
///     --dart-define=GOOGLE_IOS_CLIENT_ID=YOUR_IOS_CLIENT_ID \
///     --dart-define=GOOGLE_WEB_CLIENT_ID=YOUR_WEB_CLIENT_ID \
///     --dart-define=FIREBASE_IOS_API_KEY=... \
///     --dart-define=FIREBASE_IOS_APP_ID=... \
///     --dart-define=FIREBASE_IOS_MSG_SENDER_ID=... \
///     --dart-define=FIREBASE_IOS_PROJECT_ID=... \
///     --dart-define=FIREBASE_IOS_STORAGE_BUCKET=...
///
/// Never commit real secrets to source control.
class Env {
  // Google Sign-In
  static const googleIosClientId = String.fromEnvironment('GOOGLE_IOS_CLIENT_ID', defaultValue: '');
  static const googleWebClientId = String.fromEnvironment('GOOGLE_WEB_CLIENT_ID', defaultValue: '');

  // Firebase (iOS) – optional, use only if default plist load fails
  static const firebaseIosApiKey = String.fromEnvironment('FIREBASE_IOS_API_KEY', defaultValue: '');
  static const firebaseIosAppId = String.fromEnvironment('FIREBASE_IOS_APP_ID', defaultValue: '');
  static const firebaseIosMessagingSenderId = String.fromEnvironment('FIREBASE_IOS_MSG_SENDER_ID', defaultValue: '');
  static const firebaseIosProjectId = String.fromEnvironment('FIREBASE_IOS_PROJECT_ID', defaultValue: '');
  static const firebaseIosStorageBucket = String.fromEnvironment('FIREBASE_IOS_STORAGE_BUCKET', defaultValue: '');

  // Supabase
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

  static bool get hasFirebaseIosOptions =>
      firebaseIosApiKey.isNotEmpty &&
      firebaseIosAppId.isNotEmpty &&
      firebaseIosMessagingSenderId.isNotEmpty &&
      firebaseIosProjectId.isNotEmpty &&
      firebaseIosStorageBucket.isNotEmpty;

  static bool get hasSupabase => supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
