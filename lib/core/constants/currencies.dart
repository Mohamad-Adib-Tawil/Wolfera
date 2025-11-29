class CurrencyOption {
  final String code; // e.g., USD, EUR, SYP
  final String symbol; // e.g., $, €, ل.س
  final String name; // e.g., US Dollar, Euro
  const CurrencyOption({required this.code, required this.symbol, required this.name});
}

class CurrenciesData {
  // Currency list with symbols
  static const List<CurrencyOption> list = [
    CurrencyOption(code: 'USD', symbol: r'$', name: 'US Dollar'),
    CurrencyOption(code: 'EUR', symbol: '€', name: 'Euro'),
    CurrencyOption(code: 'SYP', symbol: 'ل.س', name: 'Syrian Pound'),
    CurrencyOption(code: 'SAR', symbol: '﷼', name: 'Saudi Riyal'),
    CurrencyOption(code: 'AED', symbol: 'د.إ', name: 'UAE Dirham'),
    CurrencyOption(code: 'QAR', symbol: 'ر.ق', name: 'Qatari Riyal'),
    CurrencyOption(code: 'KWD', symbol: 'د.ك', name: 'Kuwaiti Dinar'),
    CurrencyOption(code: 'BHD', symbol: 'د.ب', name: 'Bahraini Dinar'),
    CurrencyOption(code: 'OMR', symbol: 'ر.ع.', name: 'Omani Rial'),
    CurrencyOption(code: 'LBP', symbol: 'ل.ل', name: 'Lebanese Pound'),
    CurrencyOption(code: 'EGP', symbol: 'E£', name: 'Egyptian Pound'),
    CurrencyOption(code: 'TRY', symbol: '₺', name: 'Turkish Lira'),
    CurrencyOption(code: 'GBP', symbol: '£', name: 'British Pound'),
    CurrencyOption(code: 'JPY', symbol: '¥', name: 'Japanese Yen'),
    CurrencyOption(code: 'CNY', symbol: '¥', name: 'Chinese Yuan'),
    CurrencyOption(code: 'INR', symbol: '₹', name: 'Indian Rupee'),
  ];

  static CurrencyOption defaultCurrency() =>
      list.firstWhere((c) => c.code == 'USD');

  static CurrencyOption? findByCode(String? code) {
    if (code == null) return null;
    final upper = code.toUpperCase();
    for (final c in list) {
      if (c.code == upper) return c;
    }
    return null;
  }

  static String symbolFor(String? codeOrSymbol) {
    if (codeOrSymbol == null || codeOrSymbol.isEmpty) return r'$';
    // If already a symbol (1 char) or known multi-char Arabic symbols, return as-is
    if (codeOrSymbol.length == 1 ||
        codeOrSymbol == 'ل.س' ||
        codeOrSymbol == 'د.إ' ||
        codeOrSymbol == 'ر.ق' ||
        codeOrSymbol == 'د.ك' ||
        codeOrSymbol == 'د.ب' ||
        codeOrSymbol == 'ر.ع.' ||
        codeOrSymbol == 'ل.ل' ||
        codeOrSymbol == 'E£') {
      return codeOrSymbol;
    }
    final opt = findByCode(codeOrSymbol);
    return opt?.symbol ?? codeOrSymbol;
  }

  // Map known country codes to preferred currency codes
  static const Map<String, String> _countryToCurrency = {
    'WW': 'USD', // Worldwide defaults to USD
    'AE': 'AED',
    'QA': 'QAR',
    'SA': 'SAR',
    'KW': 'KWD',
    'BH': 'BHD',
    'OM': 'OMR',
    'SY': 'SYP',
    'LB': 'LBP',
    'EG': 'EGP',
    'TR': 'TRY',
    'DE': 'EUR',
    'GB': 'GBP',
    'US': 'USD',
  };

  /// Returns the default currency code for a given country code.
  /// If code is null or unknown, returns 'USD'.
  static String codeForCountry(String? countryCode) {
    if (countryCode == null || countryCode.isEmpty) return 'USD';
    final up = countryCode.toUpperCase();
    return _countryToCurrency[up] ?? 'USD';
  }

  /// Returns the default currency option for a given country or worldwide.
  static CurrencyOption defaultForCountry(String? countryCode) {
    final code = codeForCountry(countryCode);
    return findByCode(code) ?? defaultCurrency();
  }

  /// Optional helper in case we need to map from a symbol back to option
  static CurrencyOption? findBySymbol(String symbol) {
    try {
      return list.firstWhere((c) => c.symbol == symbol);
    } catch (_) {
      return null;
    }
  }
}
