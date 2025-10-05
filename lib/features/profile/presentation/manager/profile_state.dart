part of 'profile_bloc.dart';

@immutable
class ProfileState {
  ProfileState({
    this.updateProfileStatus = const BlocStatus.initial(),
    this.phone,
    Country? selectedCountry,
    this.selectedFile,
  }) : selectedCountry = selectedCountry ?? AuthBloc.initCountry;

  final BlocStatus updateProfileStatus;
  final File? selectedFile;
  final String? phone;

  Country selectedCountry;

  @override
  List<Object?> get props =>
      [updateProfileStatus, selectedFile, selectedCountry, phone];
  ProfileState copyWith({
    BlocStatus? updateProfileStatus,
    Nullable<File?>? selectedFile,
    final String? phone,
    Nullable<Country?>? selectedCountry,
  }) =>
      ProfileState(
        updateProfileStatus: updateProfileStatus ?? this.updateProfileStatus,
        selectedFile:
            selectedFile != null ? selectedFile.value : this.selectedFile,
        phone: phone ?? this.phone,
        selectedCountry: selectedCountry != null
            ? selectedCountry.value
            : this.selectedCountry,
      );
}
