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

      // Google Sign-In successful
      return response;
    } catch (e) {
      // Handle specific Google Sign-In errors and map to i18n keys
      final error = e.toString();
      if (error.contains('ApiException: 10') ||
          error.contains('Developer console is not set up correctly')) {
        throw 'google_signin_misconfigured';
      }
      if (error.contains('sign_in_canceled') || error.contains('cancelled')) {
        throw 'google_signin_canceled';
      }
      if (error.contains('network_error') ||
          error.contains('SocketException') ||
          error.contains('ApiException: 7')) {
        throw 'google_signin_network_error';
      }
      if (error.contains('ApiException: 12500')) {
        throw 'google_play_services_missing';
      }
      if (error.contains('AuthException') || error.contains('Invalid')) {
        throw 'google_auth_error';
      }
      throw 'google_signin_failed';
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

  // Featured cars only (for RecommendedSection)
  static Future<List<Map<String, dynamic>>> getFeaturedCars() async {
    final response = await client
        .from('cars')
        .select('*')
        .eq('is_featured', true)
        .order('created_at', ascending: false);
    return (response as List).cast<Map<String, dynamic>>();
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

  // Toggle is_featured flag (admin-only via RLS policy)
  static Future<void> setCarFeatured(String id, bool isFeatured) async {
    await client.from('cars').update({'is_featured': isFeatured}).eq('id', id);
  }

  // Check if current user is admin (treat super admin as admin too)
  static Future<bool> isCurrentUserAdmin() async {
    try {
      final uid = currentUser?.id;
      if (uid == null) return false;
      final res = await client
          .from('users')
          .select('is_admin, is_super_admin')
          .eq('id', uid)
          .maybeSingle();
      if (res == null) return false;
      final adm = res['is_admin'];
      final sadm = res['is_super_admin'];
      bool bAdm = adm is bool ? adm : (adm is int ? adm == 1 : false);
      bool bSAdm = sadm is bool ? sadm : (sadm is int ? sadm == 1 : false);
      return bAdm || bSAdm;
    } catch (_) {
      // If column doesn't exist or any error, treat as non-admin
      return false;
    }
  }

  // Check if current user is SUPER ADMIN (requires users.is_super_admin boolean column)
  static Future<bool> isCurrentUserSuperAdmin() async {
    try {
      final uid = currentUser?.id;
      if (uid == null) return false;
      final res = await client
          .from('users')
          .select('is_super_admin')
          .eq('id', uid)
          .maybeSingle();
      if (res == null) return false;
      final val = res['is_super_admin'];
      if (val is bool) return val;
      if (val is int) return val == 1;
      return false;
    } catch (_) {
      return false;
    }
  }

  // Super admin can promote a user to admin by email (RLS must allow this)
  static Future<void> promoteUserToAdminByEmail(String email) async {
    // 1) find the user id by email
    final userRow = await client
        .from('users')
        .select('id')
        .eq('email', email)
        .maybeSingle();
    if (userRow == null) {
      throw Exception('User not found');
    }
    final uid = userRow['id']?.toString();
    if (uid == null || uid.isEmpty) {
      throw Exception('Invalid user id');
    }
    // 2) update is_admin
    await client
        .from('users')
        .update({'is_admin': true, 'updated_at': DateTime.now().toIso8601String()})
        .eq('id', uid);
  }
}
