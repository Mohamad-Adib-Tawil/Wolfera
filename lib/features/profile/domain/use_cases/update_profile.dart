import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:wolfera/core/api/result.dart';
import 'package:wolfera/core/config/use_case/use_case.dart';
import 'package:wolfera/features/profile/data/data_sources/profile_datasource.dart';

@injectable
class UpdateProfileUsecase extends UseCase<Result<User>, UpdateProfileParams> {
  final ProfileDatasource _datasource;

  UpdateProfileUsecase(this._datasource);
  @override
  Future<Result<User>> call(UpdateProfileParams params) {
    return _datasource.updateProfile(params);
  }
}

class UpdateProfileParams {
  const UpdateProfileParams({
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    required this.avatar,
  });

  final String displayName;
  final String email;
  final String phoneNumber;
  final File? avatar;
}
