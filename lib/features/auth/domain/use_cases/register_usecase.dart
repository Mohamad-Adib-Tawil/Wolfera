import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:wolfera/core/api/result.dart';
import 'package:wolfera/core/use_case/use_case.dart';
import 'package:wolfera/features/auth/data/data_sources/auth_datasource.dart';

@injectable
class RegisterUsecase extends UseCase<Result<User>, RegisterParams> {
  RegisterUsecase(this._datasource);
  final AuthDatasource _datasource;
  @override
  Future<Result<User>> call(RegisterParams params) {
    return _datasource.register(params);
  }
}

class RegisterParams {
  const RegisterParams({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });

  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;
}
