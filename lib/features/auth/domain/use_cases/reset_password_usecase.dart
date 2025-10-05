import 'package:injectable/injectable.dart';
import 'package:wolfera/common/models/response_wrapper/response_wrapper.dart';
import 'package:wolfera/core/api/result.dart';
import 'package:wolfera/core/use_case/use_case.dart';
import 'package:wolfera/features/auth/data/data_sources/auth_datasource.dart';

@injectable
class ResetPasswordUsecase extends UseCase<Result<bool>, ResetPasswordParams> {
  ResetPasswordUsecase(this._datasource);
  final AuthDatasource _datasource;
  @override
  Future<Result<bool>> call(ResetPasswordParams params) {
    return _datasource.resetPassword(params.email);
  }
}

class ResetPasswordParams {
  const ResetPasswordParams({
    required this.email,
  });

  final String email;
}
