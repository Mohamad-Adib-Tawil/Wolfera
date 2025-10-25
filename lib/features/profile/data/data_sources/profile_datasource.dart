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

      // Get current user data from database
      final currentData = await SupabaseService.client
          .from('users')
          .select('full_name, email, phone_number, avatar_url')
          .eq('id', user.id)
          .maybeSingle();

      print('📊 Current data from DB: $currentData');

      // Determine final values (use new value if provided, otherwise keep current)
      final finalDisplayName = params.displayName ?? currentData?['full_name'] ?? user.userMetadata?['display_name'];
      final finalEmail = params.email ?? currentData?['email'] ?? user.email;
      final finalPhoneNumber = params.phoneNumber ?? currentData?['phone_number'];
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
      
      final authResponse = await SupabaseService.client.auth.updateUser(
        UserAttributes(
          email: finalEmail,
          data: authUpdateData.isNotEmpty ? authUpdateData : null,
        ),
      );

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
      
      await SupabaseService.client
          .from('users')
          .update(updateData)
          .eq('id', user.id);
      
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
