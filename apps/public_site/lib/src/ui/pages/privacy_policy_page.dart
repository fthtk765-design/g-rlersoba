import 'package:flutter/material.dart';

import 'package:public_site/l10n/app_localizations.dart';

typedef L10n = AppLocalizations;

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  static const _companyName = 'Gürler Soba';
  static const _address = 'ÖRNEK MAH. KUM YOLU MEVKİİ KÜME EVLER NO:34 MANAVGAT/ANTALYA';
  static const _phoneDisplay = '+90 506 136 60 56';

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 980),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.privacyTitle, style: theme.textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text(
                'Bu metin, $_companyName ("Biz") tarafından işletilen web sitesi üzerinden işlenen kişisel verilere ilişkin genel bilgilendirme amacıyla hazırlanmıştır.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              _Section(
                title: '1) Veri sorumlusu ve iletişim',
                body:
                    'Ünvan: $_companyName\nAdres: $_address\nTelefon/WhatsApp: $_phoneDisplay',
              ),
              _Section(
                title: '2) Hangi verileri işliyoruz?',
                body:
                    'Sitemiz üzerinden doğrudan üyelik/hesap oluşturma bulunmamaktadır. Ancak sizinle iletişim kurabilmek için şu veriler işlenebilir:\n\n- İletişim verileri (telefon numarası gibi)\n- WhatsApp üzerinden gönderdiğiniz mesaj içeriği\n- Teknik veriler (IP adresi, tarayıcı bilgisi, hata kayıtları gibi)\n\nNot: WhatsApp üzerinden paylaştığınız içerik, WhatsApp servis sağlayıcısı tarafından ayrıca işlenebilir.',
              ),
              _Section(
                title: '3) Amaçlar',
                body:
                    'Veriler; talebinizi yanıtlamak, ürünler hakkında bilgi vermek, satış/servis süreçlerini yürütmek ve sitemizin güvenliğini sağlamak amaçlarıyla işlenebilir.',
              ),
              _Section(
                title: '4) Hukuki sebepler',
                body:
                    'İletişim taleplerinin yanıtlanması ve süreçlerin yürütülmesi kapsamında ilgili mevzuatta öngörülen veya meşru menfaat/iletişim süreçlerinin gerektirdiği ölçüde işleme yapılabilir.',
              ),
              _Section(
                title: '5) Üçüncü taraflar ve aktarım',
                body:
                    'WhatsApp iletişimi kullanıldığında, mesajlaşma altyapısı üçüncü taraf (WhatsApp) tarafından sağlanır. Bu nedenle iletişim verileri ve mesaj içeriği ilgili sağlayıcının politikalarına tabi olabilir. Ayrıca barındırma/altyapı sağlayıcıları, güvenlik ve performans amaçlarıyla teknik kayıtlar tutabilir.',
              ),
              _Section(
                title: '6) Saklama süreleri',
                body:
                    'İletişim kayıtları, talebin sonuçlandırılması için gerekli süre boyunca ve gerektiğinde yasal yükümlülükler kapsamında saklanabilir; sonrasında silinir veya anonimleştirilir.',
              ),
              _Section(
                title: '7) Haklarınız',
                body:
                    'Kişisel verilerinize ilişkin taleplerinizi bize iletebilirsiniz. Talebinizi $_phoneDisplay üzerinden WhatsApp ile veya telefonla iletmeniz yeterlidir.',
              ),
              _Section(
                title: '8) Güncellemeler',
                body:
                    'Bu metin zaman zaman güncellenebilir. Güncellemeler sitede yayınlandığı tarihten itibaren geçerli olur.\n\nYürürlük tarihi: 17.02.2026',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String body;

  const _Section({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(body, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
