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
        avatarUrl = await StorageService.uploadAvatar(
          userId: user.id,
          imageFile: params.avatar!,
        );
      }

      // Update user metadata in Supabase Auth
      await SupabaseService.client.auth.updateUser(
        UserAttributes(
          email: params.email,
          data: {
            'display_name': params.displayName,
            if (avatarUrl != null) 'avatar_url': avatarUrl,
          },
        ),
      );

      // Update user profile in users table
      await SupabaseService.client
          .from('users')
          .upsert({
        'id': user.id,
        'phone_number': params.phoneNumber,
        'email': params.email,
        'full_name': params.displayName,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'id');

      return SupabaseService.currentUser!;
    }

    return toApiResult(() => throwAppException(fun));
  }
}
