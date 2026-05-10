import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wolfera/features/car_stores/domain/entities/car_publisher.dart';
import 'package:wolfera/services/app_settings_service.dart';
import 'package:wolfera/services/supabase_service.dart';

class SellerCarsRepository {
  SellerCarsRepository({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  final SupabaseClient _client;

  Future<List<Map<String, dynamic>>> fetchSellerCars(String sellerId) async {
    final data = await _client
        .from('cars')
        .select('*')
        .eq('user_id', sellerId)
        .order('created_at', ascending: false);

    final cars = List<Map<String, dynamic>>.from(data as List);
    return AppSettingsService.instance.filterCars(cars);
  }

  Future<List<CarPublisher>> fetchCarPublishers() async {
    final data = await _client
        .from('cars')
        .select('*')
        .order('created_at', ascending: false);

    final cars = AppSettingsService.instance
        .filterCars(List<Map<String, dynamic>>.from(data as List))
        .where(_isPublishedCar)
        .toList();
    final groupedCars = _groupCarsBySeller(cars);
    if (groupedCars.isEmpty) return const [];

    final users = await _fetchUsersByIds(groupedCars.keys.toList());

    final publishers = groupedCars.entries
        .map(
          (entry) => _mapPublisher(
            sellerId: entry.key,
            cars: entry.value,
            user: users[entry.key],
          ),
        )
        .toList();

    publishers.sort((a, b) {
      final aDate = a.latestPublishedAt;
      final bDate = b.latestPublishedAt;
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return bDate.compareTo(aDate);
    });

    return publishers;
  }

  Map<String, List<Map<String, dynamic>>> _groupCarsBySeller(
    List<Map<String, dynamic>> cars,
  ) {
    final groupedCars = <String, List<Map<String, dynamic>>>{};
    for (final car in cars) {
      final sellerId = car['user_id']?.toString();
      if (sellerId == null || sellerId.isEmpty) continue;
      groupedCars
          .putIfAbsent(sellerId, () => <Map<String, dynamic>>[])
          .add(car);
    }
    return groupedCars;
  }

  Future<Map<String, Map<String, dynamic>>> _fetchUsersByIds(
    List<String> userIds,
  ) async {
    if (userIds.isEmpty) return const {};

    try {
      final data =
          await _client.from('users').select('*').inFilter('id', userIds);

      final users = List<Map<String, dynamic>>.from(data as List);
      return {
        for (final user in users)
          if (user['id'] != null) user['id'].toString(): user,
      };
    } catch (_) {
      return const {};
    }
  }

  bool _isPublishedCar(Map<String, dynamic> car) {
    final status = car['status']?.toString().trim().toLowerCase();
    return status == null || status == 'active' || status == 'available';
  }

  CarPublisher _mapPublisher({
    required String sellerId,
    required List<Map<String, dynamic>> cars,
    required Map<String, dynamic>? user,
  }) {
    final latestCar = cars.first;
    final displayName = _firstNonEmpty([
      user?['dealer_name'],
      user?['full_name'],
      latestCar['seller_name'],
    ]);
    final avatarUrl = _firstNonEmpty([
      user?['avatar_url'],
      latestCar['seller_avatar'],
    ]);

    return CarPublisher(
      id: sellerId,
      name: displayName ?? 'seller',
      avatarUrl: avatarUrl,
      city: _firstNonEmpty([user?['city'], latestCar['city']]),
      country: _firstNonEmpty([user?['country'], latestCar['country']]),
      isDealer: user?['is_dealer'] == true,
      carsCount: cars.length,
      previewImageUrls: cars
          .map(_resolveCarImage)
          .whereType<String>()
          .where((image) => image.isNotEmpty)
          .take(3)
          .toList(),
      latestCarTitle: _resolveCarTitle(latestCar),
      latestPublishedAt: DateTime.tryParse(
        latestCar['created_at']?.toString() ?? '',
      ),
    );
  }

  String? _resolveCarImage(Map<String, dynamic> car) {
    final imageUrls = car['image_urls'];
    if (imageUrls is List && imageUrls.isNotEmpty) {
      final first = imageUrls.first?.toString();
      if (first != null && first.trim().isNotEmpty) return first;
    }

    return _firstNonEmpty([car['main_image_url']]);
  }

  String? _resolveCarTitle(Map<String, dynamic> car) {
    final explicitTitle = _firstNonEmpty([car['title']]);
    if (explicitTitle != null) return explicitTitle;

    final titleParts = [
      car['year']?.toString(),
      car['brand']?.toString(),
      car['model']?.toString(),
    ].where((part) => part != null && part.trim().isNotEmpty);

    final title = titleParts.join(' ');
    return title.isEmpty ? null : title;
  }

  String? _firstNonEmpty(List<Object?> values) {
    for (final value in values) {
      final text = value?.toString().trim();
      if (text != null && text.isNotEmpty) return text;
    }
    return null;
  }
}
