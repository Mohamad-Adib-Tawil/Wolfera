import 'package:injectable/injectable.dart';
import 'package:wolfera/core/api/result.dart';
import 'package:wolfera/core/use_case/use_case.dart';
import 'package:wolfera/features/auth/data/data_sources/auth_datasource.dart';

@injectable
class VerificationUsecase extends UseCaseNoParam<Result<bool>> {
  VerificationUsecase(this._datasource);
  final AuthDatasource _datasource;
  @override
  Future<Result<bool>> call() {
    return _datasource.verification();
  }
}
