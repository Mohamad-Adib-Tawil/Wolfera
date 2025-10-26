import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wolfera/features/faviorate/data/favorite_repository.dart';
import 'package:wolfera/features/faviorate/presentation/manager/favorite_state.dart';
import 'package:wolfera/services/supabase_service.dart';

// Cubit خاص بإدارة المفضلة
// مسؤول عن: التحميل من التخزين المحلي، الحفظ، والتبديل (إضافة/إزالة)
class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit({FavoriteRepository? repository})
      : _repo = repository ?? FavoriteRepository(GetIt.I<SharedPreferences>()),
        super(const FavoriteState());

  final FavoriteRepository _repo;

  String? get _userId => SupabaseService.currentUser?.id;

  // تهيئة المفضلة عند بدء التطبيق/الصفحة
  Future<void> init() async {
    final uid = _userId;
    if (uid == null) return; // لم يتم تسجيل الدخول
    emit(state.copyWith(isLoading: true));
    final list = await _repo.loadFavorites(uid);
    emit(state.copyWith(favoriteCars: list, isLoading: false));
  }

  // هل السيارة مضافة للمفضلة (حسب المعرف)
  bool isFavoriteById(String? carId) {
    if (carId == null) return false;
    return state.favoriteCars.any((e) => e['id']?.toString() == carId);
  }

  // هل السيارة مضافة للمفضلة (حسب الكائن)
  bool isFavorite(Map<String, dynamic> car) =>
      isFavoriteById(car['id']?.toString());

  // تبديل المفضلة: يضيف إذا غير موجود، ويحذف إذا موجود
  Future<void> toggleFavorite(Map<String, dynamic> car) async {
    final uid = _userId;
    if (uid == null) return; // تجاهل إذا لا يوجد مستخدم

    final id = car['id']?.toString();
    if (id == null) return;

    final List<Map<String, dynamic>> updated = List.of(state.favoriteCars);
    final index = updated.indexWhere((e) => e['id']?.toString() == id);

    if (index >= 0) {
      // إزالة من المفضلة
      updated.removeAt(index);
    } else {
      // إضافة إلى المفضلة
      updated.insert(0, car);
    }

    // تحديث الواجهة فورًا
    emit(state.copyWith(favoriteCars: updated));

    // حفظ في التخزين المحلي
    await _repo.saveFavorites(uid, updated);
  }
}
