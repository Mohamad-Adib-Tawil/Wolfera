import 'package:easy_localization/easy_localization.dart';

/// Utility class to translate car values from database to localized strings
class CarValueTranslator {
  /// Translate transmission type
  static String translateTransmission(String? value) {
    if (value == null || value.isEmpty || value == 'null') return '-';
    
    final lower = value.toLowerCase();
    if (lower.contains('auto') && !lower.contains('semi')) {
      return 'transmission_types.automatic'.tr();
    } else if (lower.contains('manual')) {
      return 'transmission_types.manual'.tr();
    } else if (lower.contains('semi')) {
      return 'transmission_types.semi_automatic'.tr();
    }
    return value;
  }

  /// Detect ISO-2 country code from a raw country string, or null if unknown.
  static String? detectCountryIso2(String? value) {
    if (value == null) return null;
    final lower = value.toLowerCase().trim();
    final alnum = lower.replaceAll(RegExp(r"[^a-z0-9]"), "");
    const Map<String, String> iso2 = {
      'ae': 'ae', 'sa': 'sa', 'qa': 'qa', 'kw': 'kw', 'om': 'om', 'bh': 'bh',
      'jo': 'jo', 'lb': 'lb', 'eg': 'eg', 'iq': 'iq', 'sy': 'sy', 'ye': 'ye',
      'ps': 'ps', 'ma': 'ma', 'dz': 'dz', 'tn': 'tn', 'ly': 'ly', 'sd': 'sd',
      'tr': 'tr', 'us': 'us', 'gb': 'gb', 'uk': 'gb', 'de': 'de', 'fr': 'fr',
      'it': 'it', 'es': 'es', 'in': 'in', 'pk': 'pk',
    };
    if (alnum.length == 2 && iso2.containsKey(alnum)) return iso2[alnum];
    const Map<String, String> iso3 = {
      'are': 'ae','sau': 'sa','qat': 'qa','kwt': 'kw','omn': 'om','bhr': 'bh',
      'jor': 'jo','lbn': 'lb','egy': 'eg','irq': 'iq','syr': 'sy','yem': 'ye',
      'pse': 'ps','mar': 'ma','dza': 'dz','tun': 'tn','lby': 'ly','sdn': 'sd',
      'tur': 'tr','usa': 'us','gbr': 'gb','deu': 'de','fra': 'fr','ita': 'it',
      'esp': 'es','ind': 'in','pak': 'pk',
    };
    if (alnum.length == 3 && iso3.containsKey(alnum)) return iso3[alnum];
    // Names
    final cleaned = lower.replaceAll(RegExp(r"[^a-z\u0600-\u06FF0-9\s]"), " ").replaceAll(RegExp(r"\s+"), " ");
    if (cleaned.contains('united arab') || cleaned.contains('الإمارات') || cleaned.contains('الامارات')) return 'ae';
    if (cleaned.contains('saudi') || cleaned.contains('السعود')) return 'sa';
    if (cleaned.contains('qatar') || cleaned.contains('قطر')) return 'qa';
    if (cleaned.contains('kuwait') || cleaned.contains('الكويت')) return 'kw';
    if (cleaned.contains('oman') || cleaned.contains('عمان')) return 'om';
    if (cleaned.contains('bahrain') || cleaned.contains('البحرين')) return 'bh';
    if (cleaned.contains('jordan') || cleaned.contains('الاردن') || cleaned.contains('الأردن')) return 'jo';
    if (cleaned.contains('lebanon') || cleaned.contains('لبنان')) return 'lb';
    if (cleaned.contains('egypt') || cleaned.contains('مصر')) return 'eg';
    if (cleaned.contains('iraq') || cleaned.contains('العراق')) return 'iq';
    if (cleaned.contains('syria') || cleaned.contains('سوريا')) return 'sy';
    if (cleaned.contains('yemen') || cleaned.contains('اليمن')) return 'ye';
    if (cleaned.contains('palestine') || cleaned.contains('فلسطين')) return 'ps';
    if (cleaned.contains('morocco') || cleaned.contains('المغرب')) return 'ma';
    if (cleaned.contains('algeria') || cleaned.contains('الجزائر')) return 'dz';
    if (cleaned.contains('tunisia') || cleaned.contains('تونس')) return 'tn';
    if (cleaned.contains('libya') || cleaned.contains('ليبيا')) return 'ly';
    if (cleaned.contains('sudan') || cleaned.contains('السودان')) return 'sd';
    return null;
  }

  /// Translate city names only for Arab countries; otherwise keep as-is.
  static String translateCity(String? city, {String? country}) {
    if (city == null || city.trim().isEmpty) return '-';
    final code = detectCountryIso2(country);
    const arab = {
      'ae','sa','qa','kw','om','bh','jo','lb','eg','iq','sy','ye','ps','ma','dz','tn','ly','sd'
    };
    if (code == null || !arab.contains(code)) return city; // non-Arab: keep original

    final key = city.toLowerCase().trim().replaceAll(RegExp(r"[^a-z\u0600-\u06FF0-9\s]"), "").replaceAll(RegExp(r"\s+"), " ");
    // Common Arabic cities mapping (best-effort)
    const Map<String, String> m = {
      // UAE
      'dubai': 'دبي','abu dhabi': 'أبوظبي','sharjah': 'الشارقة','ajman': 'عجمان','fujairah': 'الفجيرة','ras al khaimah': 'رأس الخيمة','umm al quwain': 'أم القيوين',
      // Saudi
      'riyadh': 'الرياض','jeddah': 'جدة','dammam': 'الدمام','khobar': 'الخبر','mecca': 'مكة','makkah': 'مكة','medina': 'المدينة','madinah': 'المدينة',
      // Qatar
      'doha': 'الدوحة','al rayyan': 'الريان',
      // Kuwait & Oman & Bahrain
      'kuwait city': 'مدينة الكويت','muscat': 'مسقط','salalah': 'صلالة','manama': 'المنامة',
      // Jordan & Lebanon
      'amman': 'عمان','irbid': 'إربد','zarqa': 'الزرقاء','beirut': 'بيروت','tripoli': 'طرابلس',
      // Egypt
      'cairo': 'القاهرة','giza': 'الجيزة','alexandria': 'الإسكندرية','mansoura': 'المنصورة','tanta': 'طنطا','aswan': 'أسوان','luxor': 'الأقصر',
      // Iraq
      'baghdad': 'بغداد','basra': 'البصرة','erbil': 'أربيل','mosul': 'الموصل','najaf': 'النجف','karbala': 'كربلاء',
      // Syria
      'damascus': 'دمشق','aleppo': 'حلب','homs': 'حمص','hama': 'حماة','latakia': 'اللاذقية','tartus': 'طرطوس','deraa': 'درعا','daraa': 'درعا','deir ezzor': 'دير الزور','raqqa': 'الرقة',
      // Yemen
      'sanaa': 'صنعاء','aden': 'عدن','taiz': 'تعز','hodeidah': 'الحديدة','ib': 'إب','ibb': 'إب','marib': 'مأرب',
      // Palestine
      'gaza': 'غزة','jerusalem': 'القدس','ramallah': 'رام الله','nablus': 'نابلس','hebron': 'الخليل',
      // Morocco
      'rabat': 'الرباط','casablanca': 'الدار البيضاء','marrakesh': 'مراكش','tangier': 'طنجة','fes': 'فاس','meknes': 'مكناس',
      // Algeria
      'algiers': 'الجزائر','oran': 'وهران','constantine': 'قسنطينة','annaba': 'عنابة','batna': 'باتنة',
      // Tunisia
      'tunis': 'تونس','sfax': 'صفاقس','sousse': 'سوسة','monastir': 'المنستير','gabes': 'قابس',
      // Libya
      'benghazi': 'بنغازي','misrata': 'مصراتة',
      // Sudan
      'khartoum': 'الخرطوم','omdurman': 'أم درمان','port sudan': 'بورتسودان',
    };
    // If already Arabic letters, keep as is
    if (RegExp(r"[\u0600-\u06FF]").hasMatch(city)) return city;
    return m[key] ?? city;
  }

  /// Translate fuel type
  static String translateFuelType(String? value) {
    if (value == null || value.isEmpty || value == 'null') return '-';
    
    final lower = value.toLowerCase();
    if (lower.contains('gasoline') || lower.contains('بنزين')) {
      return 'fuel_types.gasoline'.tr();
    } else if (lower.contains('diesel') || lower.contains('ديزل') || lower.contains('مازوت')) {
      return 'fuel_types.diesel'.tr();
    } else if (lower.contains('petrol') || lower.contains('بترول')) {
      return 'fuel_types.petrol'.tr();
    } else if (lower.contains('electric') || lower.contains('كهرباء')) {
      return 'fuel_types.electric'.tr();
    } else if (lower.contains('hybrid') || lower.contains('هجين')) {
      return 'fuel_types.hybrid'.tr();
    }
    return value;
  }

  /// Translate body type
  static String translateBodyType(String? value) {
    if (value == null || value.isEmpty || value == 'null') return '-';
    
    final lower = value.toLowerCase();
    if (lower.contains('sedan')) {
      return 'body_types.sedan'.tr();
    } else if (lower.contains('suv')) {
      return 'body_types.suv'.tr();
    } else if (lower.contains('hatchback')) {
      return 'body_types.hatchback'.tr();
    } else if (lower.contains('coupe')) {
      return 'body_types.coupe'.tr();
    } else if (lower.contains('convertible')) {
      return 'body_types.convertible'.tr();
    } else if (lower.contains('wagon')) {
      return 'body_types.wagon'.tr();
    } else if (lower.contains('pickup')) {
      return 'body_types.pickup'.tr();
    } else if (lower.contains('van')) {
      return 'body_types.van'.tr();
    } else if (lower.contains('truck')) {
      return 'body_types.truck'.tr();
    }
    return value;
  }

  /// Translate color
  static String translateColor(String? value) {
    if (value == null || value.isEmpty || value == 'null') return '-';
    
    final lower = value.toLowerCase();
    if (lower.contains('beige')) {
      return 'colors.beige'.tr();
    } else if (lower.contains('black') || lower.contains('أسود')) {
      return 'colors.black'.tr();
    } else if (lower.contains('blue') || lower.contains('أزرق')) {
      return 'colors.blue'.tr();
    } else if (lower.contains('white') || lower.contains('أبيض')) {
      return 'colors.white'.tr();
    } else if (lower.contains('brown') || lower.contains('بني')) {
      return 'colors.brown'.tr();
    } else if (lower.contains('gold') || lower.contains('ذهبي')) {
      return 'colors.gold'.tr();
    } else if (lower.contains('green') || lower.contains('أخضر')) {
      return 'colors.green'.tr();
    } else if (lower.contains('grey') || lower.contains('gray') || lower.contains('رمادي')) {
      return 'colors.grey'.tr();
    } else if (lower.contains('orange') || lower.contains('برتقالي')) {
      return 'colors.orange'.tr();
    } else if (lower.contains('red') || lower.contains('أحمر')) {
      return 'colors.red'.tr();
    } else if (lower.contains('silver') || lower.contains('فضي')) {
      return 'colors.silver'.tr();
    }
    return value;
  }

  /// Translate condition
  static String translateCondition(String? value) {
    if (value == null || value.isEmpty || value == 'null') return '-';
    
    final lower = value.toLowerCase();
    if (lower.contains('new') || lower.contains('جديد')) {
      return 'car_conditions.new'.tr();
    } else if (lower.contains('used') || lower.contains('مستعمل')) {
      return 'car_conditions.used'.tr();
    } else if (lower.contains('excellent') || lower.contains('ممتاز')) {
      return 'car_conditions.excellent'.tr();
    } else if (lower.contains('very') && lower.contains('good')) {
      return 'car_conditions.very_good'.tr();
    } else if (lower.contains('good') || lower.contains('جيد')) {
      return 'car_conditions.good'.tr();
    } else if (lower.contains('fair') || lower.contains('مقبول')) {
      return 'car_conditions.fair'.tr();
    } else if (lower.contains('poor') || lower.contains('ضعيف')) {
      return 'car_conditions.poor'.tr();
    }
    return value;
  }

  /// Translate any car value based on its field name
  static String translateValue(String fieldName, String? value) {
    if (value == null || value.isEmpty || value == 'null') return '-';
    
    switch (fieldName.toLowerCase()) {
      case 'transmission':
        return translateTransmission(value);
      case 'fuel_type':
      case 'fueltype':
        return translateFuelType(value);
      case 'body_type':
      case 'bodytype':
        return translateBodyType(value);
      case 'color':
        return translateColor(value);
      case 'condition':
        return translateCondition(value);
      case 'country':
      case 'location':
        return translateCountry(value);
      default:
        return value;
    }
  }

  /// Translate country names (best-effort). Falls back to original value.
  static String translateCountry(String? value) {
    if (value == null || value.isEmpty || value == 'null') return '-';
    // Lowercase and trim
    final lower = value.toLowerCase().trim();
    // Remove punctuation, emojis, flags, parentheses content, keep letters/numbers/spaces
    var cleaned = lower
        .replaceAll(RegExp(r"\([^)]+\)"), " ") // remove parentheses content
        .replaceAll(RegExp(r"[^a-z\u0600-\u06FF0-9\s]"), " ") // keep letters/digits/spaces
        .replaceAll(RegExp(r"\s+"), " ")
        .trim();
    // Alnum only for code detection (e.g., "U.A.E" -> "uae")
    final alnum = lower.replaceAll(RegExp(r"[^a-z0-9]"), "");
    
    // 1) Try ISO alpha-2 codes first
    const Map<String, String> codeMap = {
      'ae': 'countries.uae',
      'sa': 'countries.saudi_arabia',
      'qa': 'countries.qatar',
      'kw': 'countries.kuwait',
      'om': 'countries.oman',
      'bh': 'countries.bahrain',
      'jo': 'countries.jordan',
      'lb': 'countries.lebanon',
      'eg': 'countries.egypt',
      'iq': 'countries.iraq',
      'tr': 'countries.turkey',
      'us': 'countries.usa',
      'gb': 'countries.uk', // United Kingdom official code GB
      'uk': 'countries.uk', // common alias
      'de': 'countries.germany',
      'fr': 'countries.france',
      'it': 'countries.italy',
      'es': 'countries.spain',
      'in': 'countries.india',
      'pk': 'countries.pakistan',
      'sy': 'countries.syria',
      'ye': 'countries.yemen',
      'ps': 'countries.palestine',
      'ma': 'countries.morocco',
      'dz': 'countries.algeria',
      'tn': 'countries.tunisia',
      'ly': 'countries.libya',
      'sd': 'countries.sudan',
    };
    if (alnum.length == 2 && codeMap.containsKey(alnum)) {
      final key = codeMap[alnum]!;
      final t = key.tr();
      return t != key ? t : value;
    }
    // 1b) Try ISO alpha-3
    const Map<String, String> codeMap3 = {
      'are': 'countries.uae',
      'sau': 'countries.saudi_arabia',
      'qat': 'countries.qatar',
      'kwt': 'countries.kuwait',
      'omn': 'countries.oman',
      'bhr': 'countries.bahrain',
      'jor': 'countries.jordan',
      'lbn': 'countries.lebanon',
      'egy': 'countries.egypt',
      'irq': 'countries.iraq',
      'tur': 'countries.turkey',
      'usa': 'countries.usa',
      'gbr': 'countries.uk',
      'deu': 'countries.germany',
      'fra': 'countries.france',
      'ita': 'countries.italy',
      'esp': 'countries.spain',
      'ind': 'countries.india',
      'pak': 'countries.pakistan',
      'syr': 'countries.syria',
      'yem': 'countries.yemen',
      'pse': 'countries.palestine',
      'mar': 'countries.morocco',
      'dza': 'countries.algeria',
      'tun': 'countries.tunisia',
      'lby': 'countries.libya',
      'sdn': 'countries.sudan',
    };
    if (alnum.length == 3 && codeMap3.containsKey(alnum)) {
      final key = codeMap3[alnum]!;
      final t = key.tr();
      return t != key ? t : value;
    }
    
    // Normalize common variants - check exact matches first, then contains
    String key;
    
    // UAE variations
    if (alnum == 'uae' || cleaned.contains('united arab emirates') || cleaned.contains('united arab') || cleaned.contains('الامارات') || cleaned.contains('الإمارات')) {
      key = 'countries.uae';
    } 
    // Saudi Arabia variations
    else if (cleaned == 'saudi arabia' || alnum == 'sa' || alnum == 'ksa' ||
        cleaned.contains('saudi') || cleaned.contains('السعود') || 
        cleaned.contains('السعودية')) {
      key = 'countries.saudi_arabia';
    } else if (cleaned.contains('qatar') || cleaned.contains('قطر')) {
      key = 'countries.qatar';
    } else if (cleaned.contains('kuwait') || cleaned.contains('الكويت')) {
      key = 'countries.kuwait';
    } else if (cleaned.contains('oman') || cleaned.contains('عمان')) {
      key = 'countries.oman';
    } else if (cleaned.contains('bahrain') || cleaned.contains('البحرين')) {
      key = 'countries.bahrain';
    } else if (cleaned.contains('jordan') || cleaned.contains('الاردن') || cleaned.contains('الأردن')) {
      key = 'countries.jordan';
    } else if (cleaned.contains('lebanon') || cleaned.contains('لبنان')) {
      key = 'countries.lebanon';
    } else if (cleaned.contains('egypt') || cleaned.contains('مصر')) {
      key = 'countries.egypt';
    } else if (cleaned.contains('iraq') || cleaned.contains('العراق')) {
      key = 'countries.iraq';
    } else if (cleaned.contains('turkey') || cleaned.contains('تركيا')) {
      key = 'countries.turkey';
    } else if (alnum == 'usa' || cleaned.contains('united states of america') || cleaned.contains('united states') || cleaned.contains('america')) {
      key = 'countries.usa';
    } else if (cleaned.contains('united kingdom') || alnum == 'uk' || cleaned.contains('britain') || cleaned.contains('بريطانيا')) {
      key = 'countries.uk';
    } else if (cleaned.contains('germany') || cleaned.contains('المانيا') || cleaned.contains('ألمانيا')) {
      key = 'countries.germany';
    } else if (cleaned.contains('france') || cleaned.contains('فرنسا')) {
      key = 'countries.france';
    } else if (cleaned.contains('italy') || cleaned.contains('ايطاليا') || cleaned.contains('إيطاليا')) {
      key = 'countries.italy';
    } else if (cleaned.contains('spain') || cleaned.contains('اسبانيا') || cleaned.contains('إسبانيا')) {
      key = 'countries.spain';
    } else if (cleaned.contains('india') || cleaned.contains('الهند')) {
      key = 'countries.india';
    } else if (cleaned.contains('pakistan') || cleaned.contains('باكستان')) {
      key = 'countries.pakistan';
    } else if (cleaned.contains('syria') || cleaned.contains('سوريا')) {
      key = 'countries.syria';
    } else if (cleaned.contains('yemen') || cleaned.contains('اليمن')) {
      key = 'countries.yemen';
    } else if (cleaned.contains('palestine') || cleaned.contains('فلسطين')) {
      key = 'countries.palestine';
    } else if (cleaned.contains('morocco') || cleaned.contains('المغرب')) {
      key = 'countries.morocco';
    } else if (cleaned.contains('algeria') || cleaned.contains('الجزائر')) {
      key = 'countries.algeria';
    } else if (cleaned.contains('tunisia') || cleaned.contains('تونس')) {
      key = 'countries.tunisia';
    } else if (cleaned.contains('libya') || cleaned.contains('ليبيا')) {
      key = 'countries.libya';
    } else if (cleaned.contains('sudan') || cleaned.contains('السودان')) {
      key = 'countries.sudan';
    } else {
      // If not recognized, try to find a matching key by checking if value exists in translations
      // This is a fallback - return original value
      return value;
    }
    
    final translated = key.tr();
    // If translation returns the key itself (not found), return original value
    return translated != key ? translated : value;
  }
}
