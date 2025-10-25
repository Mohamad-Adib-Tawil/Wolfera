import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:wolfera/core/api/result.dart';
import 'package:wolfera/features/app/domin/repositories/prefs_repository.dart';
import 'package:wolfera/features/auth/domain/use_cases/register_usecase.dart';
import 'package:wolfera/services/supabase_service.dart';
import '../../../../core/api/api_utils.dart';

@injectable
class AuthDatasource {
  AuthDatasource(this._prefsRepository);

  final PrefsRepository _prefsRepository;

  Future<Result<User>> register(RegisterParams params) async {
    Future<User> fun() async {
      final response = await SupabaseService.signUp(
        email: params.email,
        password: params.password,
        data: {
          'display_name': params.fullName,  // Use display_name for consistency
          'full_name': params.fullName,     // Keep full_name for backward compatibility
          'phone_number': params.phoneNumber,
        },
      );

      final user = response.user!;

      // Upsert user data into users table (idempotent)
      await SupabaseService.client
          .from('users')
          .upsert({
        'id': user.id,
        'full_name': params.fullName,
        'email': params.email,
        'phone_number': params.phoneNumber,
        'created_at': DateTime.now().toIso8601String(),
      }, onConflict: 'id');

      return user;
    }

    return toApiResult(() => throwAppException(fun));
  }

  Future<Result<User>> login(
      {required String email, required String password}) async {
    fun() async {
      final response = await SupabaseService.signIn(
        email: email,
        password: password,
      );
      return response.user!;
    }

    return toApiResult(() => throwAppException(fun));
  }

  // Google Sign In
  Future<Result<User>> loginWithGoogle() async {
    fun() async {
      print('🔄 Starting Google login process...');
      final response = await SupabaseService.signInWithGoogle();
      final user = response.user!;
      print('✅ Google authentication successful for: ${user.email}');
      
      // Check if user exists in users table, if not create one
      print('🔍 Checking if user exists in database...');
      dynamic existingUser;
      try {
        existingUser = await SupabaseService.client
            .from('users')
            .select('id')
            .eq('id', user.id)
            .maybeSingle()
            .timeout(Duration(seconds: 10));
        print('✅ Database query successful');
      } catch (e) {
        print('❌ Database query failed: $e');
        // If database query fails, still return the user (authentication was successful)
        print('⚠️ Continuing without database check - user authenticated successfully');
        return user;
      }
      
      if (existingUser == null) {
        print('📝 Creating new user record in database...');
        try {
          // Get user name from Google metadata
          final displayName = user.userMetadata?['full_name'] ?? 
                             user.userMetadata?['name'] ?? 
                             user.email?.split('@').first;
          
          // Create user record
          await SupabaseService.client
              .from('users')
              .upsert({
            'id': user.id,
            'full_name': displayName,
            'email': user.email,
            'phone_number': user.phone ?? '',
            'avatar_url': user.userMetadata?['avatar_url'] ?? user.userMetadata?['picture'],
            'created_at': DateTime.now().toIso8601String(),
          }, onConflict: 'id').timeout(Duration(seconds: 10));
          
          // Also update auth metadata to ensure consistency
          try {
            await SupabaseService.client.auth.updateUser(
              UserAttributes(
                data: {
                  'display_name': displayName,
                  'avatar_url': user.userMetadata?['avatar_url'] ?? user.userMetadata?['picture'],
                },
              ),
            );
          } catch (e) {
            print('⚠️ Could not update auth metadata: $e');
          }
          print('✅ User record created successfully');
        } catch (e) {
          print('❌ Failed to create user record: $e');
          print('⚠️ Continuing anyway - user is authenticated');
        }
      } else {
        print('✅ User already exists in database');
      }
      
      return user;
    }

    return toApiResult(() => throwAppException(fun));
  }

  Future<Result<bool>> resetPassword(String email) async {
    Future<bool> fun() async {
      // Check if user exists in Supabase
      final users = await SupabaseService.client
          .from('users')
          .select('email')
          .eq('email', email);
      
      if (users.isNotEmpty) {
        await SupabaseService.client.auth.resetPasswordForEmail(email);
      }
      return users.isNotEmpty;
    }

    return toApiResult(() => throwAppException(fun));
  }

  Future<Result<bool>> verification() async {
    Future<bool> fun() async {
      final user = SupabaseService.currentUser;
      
      if (user != null) {
        // Resend confirmation email
        await SupabaseService.client.auth.resend(
          type: OtpType.signup,
          email: user.email!,
        );
      }

      return true;
    }

    return toApiResult(() => throwAppException(fun));
  }

  Future<Result<bool>> logout() async {
    fun() async {
      await SupabaseService.signOut();
      return true;
    }

    return toApiResult(() => throwAppException(fun));
  }
}
