import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:wolfera/core/api/api_utils.dart';
import 'package:wolfera/core/api/result.dart';
import 'package:wolfera/features/my_car/domain/usecases/sell_my_car_usecase.dart';
import 'package:wolfera/services/supabase_service.dart';
import 'package:wolfera/services/storage_service.dart';

@injectable
class MyCarDatasouce {
  static const _uuid = Uuid();
  
  Future<Result<bool>> sellMyCar(SellMyCarParams params) async {
    Future<bool> fun() async {
      // Generate a unique car ID for this listing
      final carId = _uuid.v4();
      
      // Get current user ID
      final userId = StorageService.currentUserId;
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      
      // Upload car images using the new StorageService
      final List<String> uploadedUrls = [];
      
      // Filter out null images and upload them
      final validImages = params.carImages.where((img) => img != null).toList();
      
      if (validImages.isNotEmpty) {
        // Upload images and get their URLs
        uploadedUrls.addAll(await StorageService.uploadCarImages(
          userId: userId,
          carId: carId,
          imageFiles: validImages,
        ));
      }
      
      // Prepare car data with uploaded image URLs
      final carData = params.toMapWithUrls(uploadedUrls);
      carData['id'] = carId; // Add the car ID to the data

      // Insert car data into Supabase with schema sanitization (remove unknown columns)
      await _insertCarWithSchemaSanitization(carData);

      return true;
    }

    return toApiResult(() => throwAppException(fun));
  }

  Future<void> _insertCarWithSchemaSanitization(
      Map<String, dynamic> carData) async {
    final data = Map<String, dynamic>.from(carData);
    while (true) {
      try {
        await SupabaseService.addCar(data);
        return;
      } on PostgrestException catch (e) {
        final message = e.message;
        final match =
            RegExp(r"Could not find the '([^']+)' column").firstMatch(message);
        if (match != null) {
          final missingColumn = match.group(1)!;
          // Remove the missing column and retry
          data.remove(missingColumn);
          continue;
        }
        rethrow;
      }
    }
  }
}
