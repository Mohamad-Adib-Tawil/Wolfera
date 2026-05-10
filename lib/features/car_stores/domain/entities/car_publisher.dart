import 'package:equatable/equatable.dart';

class CarPublisher extends Equatable {
  const CarPublisher({
    required this.id,
    required this.name,
    required this.carsCount,
    this.avatarUrl,
    this.city,
    this.country,
    this.isDealer = false,
    this.previewImageUrls = const [],
    this.latestCarTitle,
    this.latestPublishedAt,
  });

  final String id;
  final String name;
  final String? avatarUrl;
  final String? city;
  final String? country;
  final bool isDealer;
  final int carsCount;
  final List<String> previewImageUrls;
  final String? latestCarTitle;
  final DateTime? latestPublishedAt;

  @override
  List<Object?> get props => [
        id,
        name,
        avatarUrl,
        city,
        country,
        isDealer,
        carsCount,
        previewImageUrls,
        latestCarTitle,
        latestPublishedAt,
      ];
}
