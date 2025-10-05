import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:wolfera/core/api/result.dart';
import 'package:wolfera/core/use_case/use_case.dart';
import '../../data/data_sources/auth_datasource.dart';

@injectable
class LoginUsecase extends UseCase<Result<User>, LoginParams> {
  LoginUsecase(this._datasource);

  final AuthDatasource _datasource;

  @override
  Future<Result<User>> call(LoginParams params) {
    return _datasource.login(email: params.email, password: params.password);
  }
}

class LoginParams {
  const LoginParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}
