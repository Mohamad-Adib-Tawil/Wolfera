import 'package:injectable/injectable.dart';
import 'package:wolfera/core/api/result.dart';
import 'package:wolfera/core/config/use_case/use_case.dart';
import 'package:wolfera/features/auth/data/data_sources/auth_datasource.dart';

@injectable
class LogoutUsecase extends UseCaseNoParam<Result<bool>> {
  LogoutUsecase({required AuthDatasource source}) : _datasource = source;

  final AuthDatasource _datasource;

  @override
  Future<Result<bool>> call() => _datasource.logout();
}
