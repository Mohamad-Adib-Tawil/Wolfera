import 'package:injectable/injectable.dart';
import 'package:wolfera/core/api/api_utils.dart';
import 'package:wolfera/core/api/result.dart';
import 'package:wolfera/core/utils/firebase_storage_helper.dart';
import 'package:wolfera/features/my_car/domain/usecases/sell_my_car_usecase.dart';
import 'package:wolfera/services/supabase_service.dart';

@injectable
class MyCarDatasouce {
  Future<Result<bool>> sellMyCar(SellMyCarParams params) async {
    Future<bool> fun() async {
      final List<String> uploadedUrls = [];
      for (final image in params.carImages) {
        if (image != null) {
          final url = await SupabaseStorageHelper.uploadFile(
            image,
            'car_images/${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}',
          );
          uploadedUrls.add(url);
        }
      }
      final carData = params.toMapWithUrls(uploadedUrls);

      // Insert car data into Supabase
      await SupabaseService.addCar(carData);

      return true;
    }

    return toApiResult(() => throwAppException(fun));
  }
}
