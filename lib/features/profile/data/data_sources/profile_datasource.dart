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
      String? avatarUrl;

      if (params.avatar != null) {
        // Upload avatar using the new StorageService
        print('📤 Uploading new avatar...');
        avatarUrl = await StorageService.uploadAvatar(
          userId: user.id,
          imageFile: params.avatar!,
        );
        print('✅ Avatar uploaded: $avatarUrl');
      }

      // Get current avatar URL if not uploading a new one
      if (avatarUrl == null) {
        final currentData = await SupabaseService.client
            .from('users')
            .select('avatar_url')
            .eq('id', user.id)
            .maybeSingle();
        avatarUrl = currentData?['avatar_url'] as String?;
      }

      // Update user metadata in Supabase Auth
      print('🔄 Updating user metadata...');
      final authUpdateData = {
        'display_name': params.displayName,
      };
      if (avatarUrl != null) {
        authUpdateData['avatar_url'] = avatarUrl;
      }
      
      final authResponse = await SupabaseService.client.auth.updateUser(
        UserAttributes(
          email: params.email,
          data: authUpdateData,
        ),
      );

      // Update user profile in users table
      print('🔄 Updating users table...');
      final updateData = {
        'id': user.id,
        'phone_number': params.phoneNumber,
        'email': params.email,
        'full_name': params.displayName,
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      // Always include avatar_url to maintain consistency
      if (avatarUrl != null) {
        updateData['avatar_url'] = avatarUrl;
      }
      
      await SupabaseService.client
          .from('users')
          .upsert(updateData, onConflict: 'id');
      
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
