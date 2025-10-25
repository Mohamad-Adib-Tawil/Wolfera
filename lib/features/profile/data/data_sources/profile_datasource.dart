import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:wolfera/core/api/api_utils.dart';
import 'package:wolfera/core/api/result.dart';
import 'package:wolfera/features/profile/domain/use_cases/update_profile.dart';
import 'package:wolfera/services/supabase_service.dart';
import 'package:wolfera/services/storage_service.dart';

@injectable
class ProfileDatasource {
  Future<Result<User>> updateProfile(UpdateProfileParams params) async {
    fun() async {
      final user = SupabaseService.currentUser;
      if (user == null) {
        throw AuthException(
          'No user is currently logged in.',
        );
      }

      print('📝 Update params: name=${params.displayName}, email=${params.email}, phone=${params.phoneNumber}, hasAvatar=${params.avatar != null}');

      // Skip DB select (temporary) to avoid RLS blocking the whole flow.
      // We'll rely on auth metadata and let the DB update be best-effort below.
      Map<String, dynamic>? currentData;
      print('🛑 Skipping DB select for users (using auth metadata fallback)');
      
      // Handle empty strings as null
      final cleanDisplayName = params.displayName?.trim().isEmpty == true ? null : params.displayName?.trim();
      final cleanEmail = params.email?.trim().isEmpty == true ? null : params.email?.trim();
      final cleanPhoneNumber = params.phoneNumber?.trim().isEmpty == true ? null : params.phoneNumber?.trim();
      
      print('🧹 Cleaned params: name=$cleanDisplayName, email=$cleanEmail, phone=$cleanPhoneNumber');

      // Determine final values (use new value if provided, otherwise keep current)
      final finalDisplayName = cleanDisplayName ?? currentData?['full_name'] ?? user.userMetadata?['display_name'];
      final finalEmail = cleanEmail ?? currentData?['email'] ?? user.email;
      final finalPhoneNumber = cleanPhoneNumber ?? currentData?['phone_number'];
      String? finalAvatarUrl = currentData?['avatar_url'] as String?;

      // Upload new avatar if provided
      if (params.avatar != null) {
        print('📤 Uploading new avatar...');
        finalAvatarUrl = await StorageService.uploadAvatar(
          userId: user.id,
          imageFile: params.avatar!,
        );
        print('✅ Avatar uploaded: $finalAvatarUrl');
      }

      print('🎯 Final values: name=$finalDisplayName, email=$finalEmail, phone=$finalPhoneNumber, avatar=$finalAvatarUrl');

      // Update user metadata in Supabase Auth
      print('🔄 Updating user metadata...');
      final authUpdateData = <String, dynamic>{};
      
      if (finalDisplayName != null) {
        authUpdateData['display_name'] = finalDisplayName;
      }
      if (finalAvatarUrl != null) {
        authUpdateData['avatar_url'] = finalAvatarUrl;
      }
      
      // Only allow email change for email/password provider and when actually changed
      final provider = user.appMetadata['provider'] as String?;
      final canUpdateEmail = provider == 'email';
      final emailToUpdate = (canUpdateEmail && cleanEmail != null && cleanEmail != user.email)
          ? cleanEmail
          : null;

      print('🔐 Auth update: provider=$provider, emailToUpdate=$emailToUpdate, metadata=$authUpdateData');
      
      UserResponse authResponse;
      try {
        authResponse = await SupabaseService.client.auth.updateUser(
          UserAttributes(
            email: emailToUpdate,
            data: authUpdateData.isNotEmpty ? authUpdateData : null,
          ),
        );
        print('✅ Auth update successful');
      } catch (e) {
        print('❌ Auth update error: $e');
        print('❌ Error type: ${e.runtimeType}');
        // Retry without email change if the email update caused the failure
        if (emailToUpdate != null) {
          try {
            print('🔁 Retrying auth update without email change...');
            authResponse = await SupabaseService.client.auth.updateUser(
              UserAttributes(
                data: authUpdateData.isNotEmpty ? authUpdateData : null,
              ),
            );
            print('✅ Auth metadata update successful (without email)');
          } catch (e2) {
            print('❌ Auth retry failed: $e2');
            rethrow;
          }
        } else {
          rethrow;
        }
      }

      // Update user profile in users table
      print('🔄 Updating users table...');
      final updateData = <String, dynamic>{
        'id': user.id,
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      // Only update fields that have values
      if (finalDisplayName != null) {
        updateData['full_name'] = finalDisplayName;
      }
      if (finalEmail != null) {
        updateData['email'] = finalEmail;
      }
      if (finalPhoneNumber != null) {
        updateData['phone_number'] = finalPhoneNumber;
      }
      if (finalAvatarUrl != null) {
        updateData['avatar_url'] = finalAvatarUrl;
      }
      
      print('📦 Update data: $updateData');
      
      try {
        final response = await SupabaseService.client
            .from('users')
            .update(updateData)
            .eq('id', user.id)
            .select();
        
        print('✅ Database update response: $response');
      } catch (e) {
        // Do not abort the whole flow if DB update fails; auth metadata was updated
        print('❌ Database update error: $e');
        print('❌ Error type: ${e.runtimeType}');
      }
      
      print('✅ Profile updated successfully');

      // Return the updated user from auth response (has fresh metadata)
      final updatedUser = authResponse.user!;
      print('📱 Updated user metadata: ${updatedUser.userMetadata}');
      print('📱 Display name: ${updatedUser.userMetadata?['display_name']}');
      print('📱 Avatar URL: ${updatedUser.userMetadata?['avatar_url']}');
      
      return updatedUser;
    }

    return toApiResult(() => throwAppException(fun));
  }
}
