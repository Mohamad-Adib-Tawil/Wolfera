import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:wolfera/core/api/api_utils.dart';
import 'package:wolfera/core/api/result.dart';
import 'package:wolfera/core/utils/firebase_storage_helper.dart';
import 'package:wolfera/features/profile/domain/use_cases/update_profile.dart';
import 'package:wolfera/services/supabase_service.dart';

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
        avatarUrl = await SupabaseStorageHelper.uploadFile(
          params.avatar!,
          'avatars/${user.id}.jpg',
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
          .update({
        'phone_number': params.phoneNumber,
        'email': params.email,
        'full_name': params.displayName,
        if (avatarUrl != null) 'photo_url': avatarUrl,
      }).eq('id', user.id);

      return SupabaseService.currentUser!;
    }

    return toApiResult(() => throwAppException(fun));
  }
}
