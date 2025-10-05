import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_user.freezed.dart';
part 'local_user.g.dart';

@freezed
class LocalUser with _$LocalUser {
  factory LocalUser({
    required String uid,
    String? email,
    String? displayName,
    bool? emailVerified,
    String? photoURL,
    String? phoneNumber,
  }) = _LocalUser;

  factory LocalUser.fromJson(Map<String, dynamic> json) =>
      _$LocalUserFromJson(json);
}
