import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:wolfera/core/api/result.dart';
import 'package:wolfera/core/use_case/use_case.dart';
import '../../data/data_sources/auth_datasource.dart';

@injectable
class GoogleLoginUsecase extends UseCase<Result<User>, NoParams> {
  GoogleLoginUsecase(this._datasource);

  final AuthDatasource _datasource;

  @override
  Future<Result<User>> call(NoParams params) {
    return _datasource.loginWithGoogle();
  }
}

class NoParams {
  const NoParams();
}
