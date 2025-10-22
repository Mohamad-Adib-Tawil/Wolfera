import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/config/supabase_config.dart';

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    SupabaseConfig.ensureConfigured();
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
    );
  }

  // Auth methods
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: data,
    );
  }

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Google Sign In - Direct integration with Google Cloud Console
  static Future<AuthResponse> signInWithGoogle() async {
    try {
      // Google Sign-In v7+: use singleton + initialize + authenticate
      await GoogleSignIn.instance.initialize(
        serverClientId: SupabaseConfig.googleWebClientId,
      );

      // Start interactive authentication with scope hints
      final account = await GoogleSignIn.instance.authenticate(
        scopeHint: const ['email', 'profile'],
      );

      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw 'No ID Token found.';
      }

      // Supabase requires idToken for Google; accessToken is optional
      final response = await client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );

      print('✅ Google Sign-In successful: ${response.user?.email}');
      return response;
    } catch (e) {
      // Handle specific Google Sign-In errors
      String errorMessage = e.toString();
      print('❌ Google Sign-In error: $errorMessage');

      if (errorMessage.contains('ApiException: 10')) {
        throw 'خطأ في إعداد Google Sign-In:\n'
            '1. تحقق من SHA1 fingerprint في Google Cloud Console\n'
            '2. تحقق من Package name: com.wolfera.wolfera\n'
            '3. تحقق من Web Client ID في الكود';
      } else if (errorMessage.contains('sign_in_canceled') ||
          errorMessage.contains('cancelled')) {
        throw 'تم إلغاء تسجيل الدخول بواسطة المستخدم';
      } else if (errorMessage.contains('network_error') ||
          errorMessage.contains('SocketException')) {
        throw 'خطأ في الشبكة. تحقق من اتصال الإنترنت';
      } else if (errorMessage.contains('ApiException: 7')) {
        throw 'خطأ في الشبكة. تحقق من اتصال الإنترنت';
      } else if (errorMessage.contains('ApiException: 12500')) {
        throw 'Google Play Services غير متوفر أو قديم';
      } else if (errorMessage.contains('AuthException') ||
          errorMessage.contains('Invalid')) {
        throw 'خطأ في المصادقة. تحقق من إعدادات Supabase';
      } else {
        throw 'فشل تسجيل الدخول بـ Google: $errorMessage';
      }
    }
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  static User? get currentUser => client.auth.currentUser;

  // Check if user is authenticated
  static bool get isAuthenticated => currentUser != null;

  // Get current session
  static Session? get currentSession => client.auth.currentSession;

  // Database methods
  static Future<List<Map<String, dynamic>>> getCars() async {
    final response = await client.from('cars').select('*');
    return response;
  }

  static Future<Map<String, dynamic>> addCar(
      Map<String, dynamic> carData) async {
    final response =
        await client.from('cars').insert(carData).select().single();
    return response;
  }

  static Future<void> updateCar(String id, Map<String, dynamic> carData) async {
    await client.from('cars').update(carData).eq('id', id);
  }

  static Future<void> deleteCar(String id) async {
    await client.from('cars').delete().eq('id', id);
  }
}
