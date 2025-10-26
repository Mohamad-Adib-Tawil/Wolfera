import 'package:equatable/equatable.dart';

// حالة المفضلة: تحتوي على قائمة السيارات المفضلة وحالة التحميل
class FavoriteState extends Equatable {
  const FavoriteState({
    this.favoriteCars = const [],
    this.isLoading = false,
  });

  // قائمة السيارات المفضلة (كائنات Map من نفس شكل carData)
  final List<Map<String, dynamic>> favoriteCars;

  // هل هناك عملية تحميل جارية
  final bool isLoading;

  FavoriteState copyWith({
    List<Map<String, dynamic>>? favoriteCars,
    bool? isLoading,
  }) {
    return FavoriteState(
      favoriteCars: favoriteCars ?? this.favoriteCars,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [favoriteCars, isLoading];
}
