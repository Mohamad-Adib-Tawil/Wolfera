import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:wolfera/common/constants/route.dart';
import 'package:wolfera/common/models/pagination_model.dart';
import 'package:wolfera/common/models/response_wrapper/response_wrapper.dart';
import 'package:wolfera/core/api/client.dart';
import 'package:wolfera/core/api/result.dart';
import '../../../../core/api/api_utils.dart';
import '../../../../core/api/client_config.dart';

@injectable
class HomeDatasource {
  HomeDatasource({required ClientApi clientApi}) : _clientApi = clientApi;

  final ClientApi _clientApi;

  // Future<Result<ResponseWrapper<HomeData>>> getHomeData(
  //     Map<String, dynamic> queryParameters) async {
  //   fun() async {
  //     final response = await _clientApi.request(
  //       RequestConfig(
  //         endpoint: EndPoints.home.pages,
  //         clientMethod: ClientMethod.get,
  //         responseType: ResponseType.json,
  //         queryParameters: queryParameters,
  //       ),
  //     );

  //     return ResponseWrapper<HomeData>.fromJson(
  //       response.data,
  //       (json) {
  //         final data = HomeData.fromJson(json);

  //         return data;
  //       },
  //     );
  //   }

  //   return toApiResult(() => throwAppException(fun));
  // }
}
