import '../config/app_config.dart';

String sanitizePhoneDigits(String input) {
  return input.replaceAll(RegExp(r'[^0-9]'), '');
}

String buildWhatsAppUrl({
  required String phoneE164Digits,
  required String message,
}) {
  final phone = sanitizePhoneDigits(phoneE164Digits);
  final encodedMessage = Uri.encodeComponent(message);
  return 'https://wa.me/$phone?text=$encodedMessage';
}

String buildProductWhatsAppMessage({
  required String productName,
  required String productSlugOrCode,
  required String categoryName,
  required AppConfig config,
  String? optionalCity,
  String? optionalNote,
}) {
  final link = config.publicSiteBaseUri
      .replace(path: '/', queryParameters: {'u': productSlugOrCode})
      .toString();

  final cityLine = (optionalCity ?? '').trim().isEmpty ? '' : '\nŞehir/İlçe: ${optionalCity!.trim()}';
  final noteLine = (optionalNote ?? '').trim().isEmpty ? '' : '\nNot: ${optionalNote!.trim()}';

  return 'Merhaba, Gürler Soba sitesinden bir ürün beğendim ve sipariş/teklif almak istiyorum.\n'
      '\nÜrün: $productName\n'
      'Model/Kod: $productSlugOrCode\n'
      'Kategori: $categoryName\n'
      'Link: $link\n'
      '$cityLine\n'
      'Kurulum/Montaj: (Evet/Hayır)'
      '$noteLine';
}
