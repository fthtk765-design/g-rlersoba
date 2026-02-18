import 'package:flutter/foundation.dart';

class AppConfig {
  final Uri publicSiteBaseUri;
  final String whatsappPhoneDigits;

  const AppConfig({
    required this.publicSiteBaseUri,
    required this.whatsappPhoneDigits,
  });

  factory AppConfig.fromDartDefines() {
    final base = Uri.parse(
      const String.fromEnvironment(
        'PUBLIC_SITE_BASE_URL',
        defaultValue: 'https://gurlersoba.com',
      ),
    );

    final whatsapp = _sanitizeDigits(
      const String.fromEnvironment(
        'WHATSAPP_PHONE',
        defaultValue: '905061366056',
      ),
    );

    if (kReleaseMode) {
      assert(base.toString().isNotEmpty, 'PUBLIC_SITE_BASE_URL dart-define boş olamaz');
    }

    return AppConfig(
      publicSiteBaseUri: base,
      whatsappPhoneDigits: whatsapp,
    );
  }

  static String _sanitizeDigits(String input) {
    return input.replaceAll(RegExp(r'[^0-9]'), '');
  }
}
