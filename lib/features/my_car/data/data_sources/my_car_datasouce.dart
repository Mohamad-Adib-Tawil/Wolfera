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
      print('\n🚗 ========== SELL MY CAR START ==========');
      
      // Generate a unique car ID for this listing
      final carId = _uuid.v4();
      print('📝 Generated Car ID: $carId');
      
      // Get current user ID
      final userId = StorageService.currentUserId;
      print('👤 Current User ID: $userId');
      
      if (userId == null) {
        print('❌ ERROR: User not authenticated');
        throw Exception('User not authenticated');
      }
      
      // Upload car images using the new StorageService
      final List<String> uploadedUrls = [];
      
      // Filter out null images and upload them
      final validImages = params.carImages.where((img) => img != null).toList();
      print('📸 Total images to upload: ${validImages.length}');
      
      if (validImages.isNotEmpty) {
        // Upload images and get their URLs
        print('⬆️  Uploading images...');
        uploadedUrls.addAll(await StorageService.uploadCarImages(
          userId: userId,
          carId: carId,
          imageFiles: validImages,
        ));
        print('✅ Images uploaded successfully. URLs count: ${uploadedUrls.length}');
      } else {
        print('⚠️  No images to upload');
      }
      
      // Prepare car data with uploaded image URLs
      print('\n📦 Preparing car data...');
      final carData = params.toMapWithUrls(uploadedUrls);
      carData['id'] = carId; // Add the car ID to the data
      
      print('📋 Car data keys: ${carData.keys.toList()}');
      print('🔑 user_id in data: ${carData['user_id']}');
      print('🏷️  car_maker: ${carData['car_maker']}');
      print('🏷️  car_model: ${carData['car_model']}');
      print('💰 car_price: ${carData['car_price']}');
      print('📍 car_location: ${carData['car_location']}');
      print('🖼️  car_images count: ${(carData['car_images'] as List?)?.length ?? 0}');

      // Insert car data into Supabase with schema sanitization (remove unknown columns)
      print('\n💾 Inserting into Supabase...');
      await _insertCarWithSchemaSanitization(carData);

      print('✅ Car inserted successfully!');
      print('🚗 ========== SELL MY CAR END ==========\n');
      return true;
    }

    return toApiResult(() => throwAppException(fun));
  }

  Future<void> _insertCarWithSchemaSanitization(
      Map<String, dynamic> carData) async {
    final data = Map<String, dynamic>.from(carData);
    int attempt = 1;
    
    while (true) {
      try {
        print('🔄 Insert attempt #$attempt with ${data.keys.length} fields');
        await SupabaseService.addCar(data);
        print('✅ Insert successful!');
        return;
      } on PostgrestException catch (e) {
        print('❌ PostgrestException caught:');
        print('   Code: ${e.code}');
        print('   Message: ${e.message}');
        print('   Details: ${e.details}');
        
        final message = e.message;
        final match =
            RegExp(r"Could not find the '([^']+)' column").firstMatch(message);
        if (match != null) {
          final missingColumn = match.group(1)!;
          print('🗑️  Removing unknown column: $missingColumn');
          data.remove(missingColumn);
          attempt++;
          continue;
        }
        
        print('💥 Unhandled PostgrestException - rethrowing');
        rethrow;
      } catch (e) {
        print('💥 Unexpected error during insert: $e');
        rethrow;
      }
    }
  }
}
