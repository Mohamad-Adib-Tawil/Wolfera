import 'package:wolfera/services/supabase_service.dart';

/// خدمة إدارة إعدادات التطبيق العامة (مثل إخفاء/إظهار سوريا)
/// يتم جلب الإعدادات مرة واحدة عند بدء التطبيق لتحسين الأداء
class AppSettingsService {
  static AppSettingsService? _instance;
  static AppSettingsService get instance => _instance ??= AppSettingsService._();
  
  AppSettingsService._();

  // الإعدادات المخزنة مؤقتاً
  bool _isSyriaHidden = false;
  bool _isInitialized = false;

  /// هل سوريا مخفية حالياً؟
  bool get isSyriaHidden => _isSyriaHidden;

  /// هل تم تحميل الإعدادات؟
  bool get isInitialized => _isInitialized;

  /// تحميل الإعدادات من Supabase مرة واحدة عند بدء التطبيق
  Future<void> initialize() async {
    try {
      print('📋 Loading app settings from Supabase...');
      
      final response = await SupabaseService.client
          .from('app_settings')
          .select('key, value')
          .eq('key', 'hide_syria')
          .maybeSingle();

      if (response != null) {
        final value = response['value'];
        // قراءة القيمة من JSONB (قد تكون boolean أو int أو string)
        if (value is bool) {
          _isSyriaHidden = value;
        } else if (value is int) {
          _isSyriaHidden = value == 1;
        } else if (value is String) {
          _isSyriaHidden = value.toLowerCase() == 'true';
        } else {
          _isSyriaHidden = false;
        }
        print('✅ Syria visibility: ${_isSyriaHidden ? "HIDDEN" : "VISIBLE"}');
      } else {
        // إذا لم يوجد السجل، نعتبر سوريا ظاهرة افتراضياً
        _isSyriaHidden = false;
        print('ℹ️ No hide_syria setting found, defaulting to VISIBLE');
      }

      _isInitialized = true;
    } catch (e) {
      print('⚠️ Failed to load app settings: $e');
      // في حالة الفشل، نعتبر سوريا ظاهرة لتجنب مشاكل
      _isSyriaHidden = false;
      _isInitialized = true;
    }
  }

  /// تحديث إعداد إخفاء سوريا (للسوبر أدمن فقط)
  Future<void> setSyriaVisibility(bool hide) async {
    try {
      print('🔄 Updating Syria visibility to: ${hide ? "HIDDEN" : "VISIBLE"}');

      // التحقق من صلاحيات السوبر أدمن
      final isSuperAdmin = await SupabaseService.isCurrentUserSuperAdmin();
      if (!isSuperAdmin) {
        throw Exception('Only super admin can change this setting');
      }

      // تحديث في قاعدة البيانات باستخدام UPDATE بدلاً من UPSERT
      await SupabaseService.client
          .from('app_settings')
          .update({
            'value': hide,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('key', 'hide_syria');

      // تحديث القيمة المحلية
      _isSyriaHidden = hide;
      print('✅ Syria visibility updated successfully');
    } catch (e) {
      print('🔴 Failed to update Syria visibility: $e');
      rethrow;
    }
  }

  /// إعادة تحميل الإعدادات (في حال احتجنا تحديث يدوي)
  Future<void> refresh() async {
    _isInitialized = false;
    await initialize();
  }

  /// فلترة قائمة الدول لإزالة سوريا إذا كانت مخفية
  List<T> filterCountries<T>(
    List<T> countries,
    String Function(T) getCode,
  ) {
    if (!_isSyriaHidden) return countries;
    return countries.where((c) => getCode(c).toUpperCase() != 'SY').toList();
  }

  /// فلترة قائمة السيارات لإزالة السيارات السورية إذا كانت سوريا مخفية
  List<Map<String, dynamic>> filterCars(List<Map<String, dynamic>> cars) {
    if (!_isSyriaHidden) return cars;
    
    return cars.where((car) {
      final country = car['country']?.toString().toUpperCase() ?? '';
      final countryCode = car['country_code']?.toString().toUpperCase() ?? '';
      
      // إزالة السيارات التي:
      // 1. country_code = 'SY'
      // 2. country يحتوي على 'Syria' أو 'سوريا'
      if (countryCode == 'SY') return false;
      if (country.contains('SYRIA') || country.contains('سوريا')) return false;
      
      return true;
    }).toList();
  }

  /// التحقق من أن الكود ليس سوريا (للاستخدام في التحقق من الإدخالات)
  bool isCountryAllowed(String? countryCode) {
    if (!_isSyriaHidden) return true;
    if (countryCode == null) return true;
    return countryCode.toUpperCase() != 'SY';
  }
}
