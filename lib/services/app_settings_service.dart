import 'package:wolfera/services/supabase_service.dart';

/// خدمة إدارة إعدادات التطبيق العامة (مثل إخفاء/إظهار سوريا ومراجعة السيارات)
/// يتم جلب الإعدادات مرة واحدة عند بدء التطبيق لتحسين الأداء
class AppSettingsService {
  static AppSettingsService? _instance;
  static AppSettingsService get instance =>
      _instance ??= AppSettingsService._();

  AppSettingsService._();

  // الإعدادات المخزنة مؤقتاً
  bool _isSyriaHidden = false;
  bool _requireCarApproval = false;
  bool _isInitialized = false;

  /// هل سوريا مخفية حالياً؟
  bool get isSyriaHidden => _isSyriaHidden;

  /// هل يجب أن يوافق الأدمن على السيارة قبل نشرها؟
  bool get requireCarApproval => _requireCarApproval;

  /// هل تم تحميل الإعدادات؟
  bool get isInitialized => _isInitialized;

  /// تحميل الإعدادات من Supabase مرة واحدة عند بدء التطبيق
  Future<void> initialize() async {
    try {
      print('📋 Loading app settings from Supabase...');

      final response = await SupabaseService.client
          .from('app_settings')
          .select('key, value')
          .inFilter('key', ['hide_syria', 'require_car_approval']);

      if (response.isNotEmpty) {
        for (final row in response) {
          final key = row['key']?.toString();
          final parsedValue = _parseBool(row['value']);
          if (key == 'hide_syria') {
            _isSyriaHidden = parsedValue;
          } else if (key == 'require_car_approval') {
            _requireCarApproval = parsedValue;
          }
        }
        print('✅ Syria visibility: ${_isSyriaHidden ? "HIDDEN" : "VISIBLE"}');
        print('✅ Car approval: ${_requireCarApproval ? "REQUIRED" : "DIRECT"}');
      } else {
        _isSyriaHidden = false;
        _requireCarApproval = false;
        print(
            'ℹ️ No app settings found, defaulting to safe visible/direct values');
      }

      _isInitialized = true;
    } catch (e) {
      print('⚠️ Failed to load app settings: $e');
      // في حالة الفشل، نعتبر سوريا ظاهرة لتجنب مشاكل
      _isSyriaHidden = false;
      _requireCarApproval = false;
      _isInitialized = true;
    }
  }

  bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }

  /// قراءة إعداد مراجعة السيارات مباشرة من Supabase.
  ///
  /// يستخدم عند نشر السيارة حتى لا نعتمد على قيمة cached قديمة في التطبيق.
  Future<bool> fetchRequireCarApproval() async {
    try {
      final response = await SupabaseService.client
          .from('app_settings')
          .select('value')
          .eq('key', 'require_car_approval')
          .maybeSingle();

      if (response == null) {
        _requireCarApproval = true;
        return _requireCarApproval;
      }

      _requireCarApproval = _parseBool(response['value']);
      return _requireCarApproval;
    } catch (e) {
      print('⚠️ Failed to fetch car approval setting: $e');
      return _requireCarApproval;
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
      await SupabaseService.client.from('app_settings').update({
        'value': hide,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('key', 'hide_syria');

      // تحديث القيمة المحلية
      _isSyriaHidden = hide;
      print('✅ Syria visibility updated successfully');
    } catch (e) {
      print('🔴 Failed to update Syria visibility: $e');
      rethrow;
    }
  }

  /// تحديث إعداد مراجعة السيارات قبل النشر (للسوبر أدمن فقط)
  Future<void> setCarApprovalRequired(bool required) async {
    try {
      print('🔄 Updating car approval requirement to: $required');

      final isSuperAdmin = await SupabaseService.isCurrentUserSuperAdmin();
      if (!isSuperAdmin) {
        throw Exception('Only super admin can change this setting');
      }

      await SupabaseService.client.from('app_settings').upsert({
        'key': 'require_car_approval',
        'value': required,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'key');

      _requireCarApproval = required;
      print('✅ Car approval setting updated successfully');
    } catch (e) {
      print('🔴 Failed to update car approval setting: $e');
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
