class SettingsRepository {
  final String? _whatsappPhoneDigits;
  final Map<String, String> _overrides;

  SettingsRepository({String? whatsappPhoneDigits, Map<String, String>? overrides})
      : _whatsappPhoneDigits = _sanitizeDigits(whatsappPhoneDigits ?? ''),
        _overrides = overrides ?? <String, String>{};

  Future<String?> getSettingValue(String key) async {
    if (_overrides.containsKey(key)) return _overrides[key];
    if (key == 'whatsapp_phone') return _whatsappPhoneDigits;
    return null;
  }

  Future<String> getWhatsAppPhoneOrFallback({String fallback = '90XXXXXXXXXX'}) async {
    final value = await getSettingValue('whatsapp_phone');
    final sanitized = _sanitizeDigits(value ?? '');
    return sanitized.isEmpty ? fallback : sanitized;
  }

  Future<void> upsertSetting({required String key, required String value}) async {
    _overrides[key] = value;
  }

  static String _sanitizeDigits(String input) {
    return input.replaceAll(RegExp(r'[^0-9]'), '');
  }
}
