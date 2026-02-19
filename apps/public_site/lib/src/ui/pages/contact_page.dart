import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:public_site/l10n/app_localizations.dart';

import '../../data/providers.dart';
import '../widgets/site_footer.dart';

typedef L10n = AppLocalizations;

class ContactPage extends ConsumerWidget {
  const ContactPage({super.key});

  static const _address = 'ÖRNEK MAH. KUM YOLU MEVKİİ KÜME EVLER NO:34 MANAVGAT/ANTALYA';

  static String _formatPhoneDisplay(String digits) {
    final d = digits.replaceAll(RegExp(r'[^0-9]'), '');
    if (d.length == 12 && d.startsWith('90')) {
      return '+${d.substring(0, 2)} ${d.substring(2, 5)} ${d.substring(5, 8)} ${d.substring(8, 10)} ${d.substring(10, 12)}';
    }
    return d.isEmpty ? '' : '+$d';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    final phoneAsync = ref.watch(whatsappPhoneProvider);
    const whatsappGreen = Color(0xFF25D366);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.navContact, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            Text(
              'Bize WhatsApp üzerinden yazabilir veya arayabilirsiniz.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            phoneAsync.when(
              data: (phone) {
                final display = _formatPhoneDisplay(phone);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Telefon: $display', style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 8),
                    Text('Adres: $_address', style: Theme.of(context).textTheme.bodyLarge),
                  ],
                );
              },
              loading: () => Text('Adres: $_address', style: Theme.of(context).textTheme.bodyLarge),
              error: (error, stackTrace) => Text('Adres: $_address', style: Theme.of(context).textTheme.bodyLarge),
            ),
            const SizedBox(height: 24),
            phoneAsync.when(
              data: (phone) {
                final tel = '+${phone.replaceAll(RegExp(r'[^0-9]'), '')}';
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    FilledButton.icon(
                      onPressed: () => launchUrl(Uri.parse('tel:$tel'), mode: LaunchMode.platformDefault),
                      icon: const Icon(Icons.call),
                      label: Text(l10n.ctaCall),
                    ),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: whatsappGreen,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        final url = buildWhatsAppUrl(
                          phoneE164Digits: phone,
                          message: 'Merhaba, bilgi almak istiyorum.',
                        );
                        launchUrl(Uri.parse(url), mode: LaunchMode.platformDefault);
                      },
                      icon: const Icon(Icons.chat),
                      label: const Text('WhatsApp'),
                    ),
                  ],
                );
              },
              loading: () => Text(l10n.loading),
              error: (error, stackTrace) => const Text('İletişim bilgileri yüklenemedi.'),
            ),
            const SizedBox(height: 28),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}
