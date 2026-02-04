import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:wolfera/services/notification_service.dart';
import 'package:wolfera/services/apple_auth_service.dart';

import '../core/config/supabase_config.dart';
import 'package:wolfera/core/config/env.dart';

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    SupabaseConfig.ensureConfigured();
    final url = Env.hasSupabase ? Env.supabaseUrl : SupabaseConfig.supabaseUrl;
    final anon = Env.hasSupabase ? Env.supabaseAnonKey : SupabaseConfig.supabaseAnonKey;
    await Supabase.initialize(
      url: url,
      anonKey: anon,
    );
  }

  // Apple Sign In (iOS 13+) using native sheet + Supabase signInWithIdToken
  static Future<AuthResponse> signInWithApple() async {
    try {
      if (!Platform.isIOS) {
        throw 'apple_signin_not_supported';
      }

      // 1) Get Apple ID credential with nonce (SHA256) and retrieve idToken
      final result = await AppleAuthService.getIdTokenAndUserInfo();

      // 2) Sign in to Supabase with ID token and original (raw) nonce
      final response = await client.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: result.idToken,
        nonce: result.rawNonce,
      );

      // 3) If Apple provided display name on first login, persist as auth metadata (best effort)
      try {
        if (result.displayName != null && result.displayName!.isNotEmpty) {
          await client.auth.updateUser(
            UserAttributes(
              data: {
                'display_name': result.displayName,
              },
            ),
          );
        }
      } catch (_) {}

      // 4) Ensure user row exists in 'users'
      try { await _ensureUserRow(); } catch (_) {}

      return response;
    } catch (e, st) {
      final error = e.toString();
      if (kDebugMode) {
        // ignore: avoid_print
        print('apple_signin_error_raw: $error');
        // ignore: avoid_print
        print('apple_signin_error_stack: $st');
      }
      if (error.contains('apple_signin_canceled')) {
        throw 'apple_signin_canceled';
      }
      if (error.contains('network') || error.contains('SocketException')) {
        throw 'apple_signin_network_error';
      }
      if (error.contains('apple_signin_not_supported')) {
        throw 'apple_signin_not_supported';
      }
      if (error.contains('apple_no_identity_token')) {
        throw 'apple_no_identity_token';
      }
      if (error.contains('already') && error.contains('registered')) {
        // Supabase may return messages like: 'User already registered'
        throw 'apple_email_already_in_use';
      }
      // Generic
      throw 'apple_signin_failed';
    }
  }

  static Future<void> _ensureUserRow() async {
    final u = Supabase.instance.client.auth.currentUser;
    if (u == null) return;
    final md = u.userMetadata ?? const <String, dynamic>{};
    final fullName = (md['display_name'] ?? md['full_name'] ?? '').toString();
    final avatar = (md['avatar_url'] ?? md['picture'] ?? '').toString();
    final data = <String, dynamic>{
      'id': u.id,
      'email': u.email,
      if (fullName.isNotEmpty) 'full_name': fullName,
      if (avatar.isNotEmpty) 'avatar_url': avatar,
      'updated_at': DateTime.now().toIso8601String(),
    };
    await client.from('users').upsert(data, onConflict: 'id');
  }

  // Update preferred language for current user
  static Future<void> updateUserLanguage(String languageCode) async {
    final uid = currentUser?.id;
    if (uid == null) return;
    try {
      await client
          .from('users')
          .update({'preferred_language': languageCode})
          .eq('id', uid);
    } catch (_) {}
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
      if (Platform.isIOS) {
        final iosClientId = Env.googleIosClientId;
        if (iosClientId.isNotEmpty) {
          await GoogleSignIn.instance.initialize(clientId: iosClientId);
        } else {
          // Fallback to default configuration (if plugin can resolve from Info.plist)
          await GoogleSignIn.instance.initialize();
        }
      } else {
        final webClientId = Env.googleWebClientId.isNotEmpty
            ? Env.googleWebClientId
            : SupabaseConfig.googleWebClientId; // fallback to existing config if provided locally
        if (webClientId.isNotEmpty) {
          await GoogleSignIn.instance.initialize(serverClientId: webClientId);
        } else {
          await GoogleSignIn.instance.initialize();
        }
      }

      // Start interactive authentication with scope hints
      final account = await GoogleSignIn.instance.authenticate(
        scopeHint: const ['email', 'profile'],
      );

      // In GoogleSignIn v7, you must await the authentication
      final googleAuth = await account.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        throw 'No ID Token found.';
      }

      // Supabase requires idToken for Google; accessToken is optional
      final response = await client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );

      // Ensure user row exists in 'users'
      try { await _ensureUserRow(); } catch (_) {}

      // Google Sign-In successful
      return response;
    } catch (e, st) {
      // Handle specific Google Sign-In errors and map to i18n keys
      final error = e.toString();
      if (kDebugMode) {
        // Debug log the raw error to help diagnose platform issues (iOS vs Android)
        // Avoid verbose logs in release for security/UX
        // ignore: avoid_print
        print('google_signin_error_raw: $error');
        // ignore: avoid_print
        print('google_signin_error_stack: $st');
      }
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
        .inFilter('status', ['active', 'available'])
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
    // جلب بيانات السيارة الحالية للمقارنة
    final currentCar = await client
        .from('cars')
        .select('price, title, rental_price_per_day, rental_price_per_week, rental_price_per_month, rental_price_per_3months, rental_price_per_6months, rental_price_per_year')
        .eq('id', id)
        .single();
    
    // تحديث السيارة
    await client.from('cars').update(carData).eq('id', id);
    
    // التحقق من تغيير أي سعر وإرسال الإشعارات
    final carTitle = currentCar['title']?.toString() ?? 'Unknown Car';
    
    // التحقق من تغيير سعر البيع (قارن فقط إذا كان الحقل موجوداً في التحديث)
    final rentalFields = [
      'rental_price_per_day',
      'rental_price_per_week',
      'rental_price_per_month',
      'rental_price_per_3months',
      'rental_price_per_6months',
      'rental_price_per_year',
    ];

    bool priceChanged = false;
    String? oldPriceDisplay, newPriceDisplay;
    String? changedField;

    bool _changed(dynamic oldVal, dynamic newVal) {
      final hasOld = oldVal != null;
      final hasNew = newVal != null;
      if (hasOld != hasNew) return true; // null <-> non-null
      if (!hasOld && !hasNew) return false; // both null
      // Try numeric comparison
      num? o = oldVal is num ? oldVal : num.tryParse(oldVal.toString());
      num? n = newVal is num ? newVal : num.tryParse(newVal.toString());
      if (o != null && n != null) return o != n;
      return oldVal.toString() != newVal.toString();
    }

    if (carData.containsKey('price')) {
      final oldSale = currentCar['price'];
      final newSale = carData['price'];
      if (_changed(oldSale, newSale)) {
        priceChanged = true;
        changedField = 'price';
        oldPriceDisplay = oldSale?.toString();
        newPriceDisplay = newSale?.toString();
      }
    }

    // التحقق من تغيير أسعار الإيجار (قارن فقط الحقول الموجودة في التحديث)
    if (!priceChanged) {
      for (final field in rentalFields) {
        if (!carData.containsKey(field)) continue; // لم يتم تحديث هذا الحقل
        final oldValue = currentCar[field];
        final newValue = carData[field];
        if (_changed(oldValue, newValue)) {
          priceChanged = true;
          changedField = field;
          oldPriceDisplay = oldValue?.toString();
          newPriceDisplay = newValue?.toString();
          break;
        }
      }
    }
    
    if (priceChanged && oldPriceDisplay != null && newPriceDisplay != null) {
      print('💰 Price change detected for car: $id');
      print('   Title: $carTitle');
      if (changedField != null) {
        print('   Changed field: $changedField');
      }
      print('   Old Price: ${oldPriceDisplay ?? '—'}');
      print('   New Price: ${newPriceDisplay ?? '—'}');
      
      // إرسال إشعار تغيير السعر للمستخدمين الذين أضافوا السيارة للمفضلة
      await NotificationService.sendPriceChangeNotification(
        carId: id,
        carTitle: carTitle,
        oldPrice: oldPriceDisplay,
        newPrice: newPriceDisplay,
      );
    } else {
      print('ℹ️ No price change detected for car: $id');
      print('   priceChanged: $priceChanged');
      print('   oldPriceDisplay: $oldPriceDisplay');
      print('   newPriceDisplay: $newPriceDisplay');
    }
  }

  static Future<void> deleteCar(String id) async {
    await client.from('cars').delete().eq('id', id);
  }

  // Admin/SuperAdmin: remove any car with a reason (soft delete)
  static Future<void> adminRemoveCar({
    required String carId,
    required String reason,
  }) async {
    // Ensure privileges
    final isAdmin = await isCurrentUserAdmin();
    if (!isAdmin) {
      throw Exception('admin_only_action');
    }

    // Fetch car owner and title
    final car = await client
        .from('cars')
        .select('id,user_id,title,status')
        .eq('id', carId)
        .maybeSingle();
    if (car == null) {
      throw Exception('car_not_found');
    }
    final sellerId = car['user_id']?.toString();
    final carTitle = car['title']?.toString() ?? 'Car';

    // Update status to inactive + optional removal fields if present
    var updated = false;
    try {
      await client.from('cars').update({
        'status': 'inactive',
        'removed_by': currentUser?.id,
        'removed_at': DateTime.now().toIso8601String(),
        'removal_reason': reason,
      }).eq('id', carId);
      updated = true;
    } catch (e) {
      // Fallback if columns don't exist: update status only
      try {
        await client.from('cars').update({'status': 'inactive'}).eq('id', carId);
        updated = true;
      } catch (e2) {
        // RLS or other error – propagate to caller
        throw Exception('car_update_failed');
      }
    }

    // Notify seller ONLY if update succeeded
    if (!updated) {
      throw Exception('car_update_failed');
    }
    if (sellerId != null && sellerId.isNotEmpty) {
      await NotificationService.sendCarRemovedNotification(
        recipientId: sellerId,
        carTitle: carTitle,
        reason: reason,
        carId: carId,
      );
    }
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
