part of 'profile_bloc.dart';

class ProfileEvent {}

class UpdateProfile extends ProfileEvent {}

class ChangeProfileImage extends ProfileEvent {
  final File? file;

  ChangeProfileImage({required this.file});
}
