import 'package:flutter/material.dart';

import 'package:public_site/l10n/app_localizations.dart';
import '../widgets/site_footer.dart';

typedef L10n = AppLocalizations;

class CookiePolicyPage extends StatelessWidget {
  const CookiePolicyPage({super.key});

  static const _companyName = 'Gürler Soba';

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
              Text(l10n.cookieTitle, style: theme.textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text(
                'Bu Çerez Politikası, $_companyName tarafından işletilen web sitesinde çerezlerin nasıl kullanıldığını açıklar.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              _Section(
                title: '1) Çerez nedir?',
                body:
                    'Çerezler, ziyaret ettiğiniz web siteleri tarafından tarayıcınıza kaydedilebilen küçük metin dosyalarıdır. Bazı çerezler sitenin çalışması için zorunludur.',
              ),
              _Section(
                title: '2) Hangi çerezleri kullanıyoruz?',
                body:
                    'Sitede temel işlevsellik ve güvenlik için gerekli olabilecek zorunlu çerezler kullanılabilir.\n\nBu sürümde; üyelik/oturum gibi bir mekanizma olmadığı için profil oluşturma amaçlı çerez kullanımını hedeflemiyoruz. Üçüncü taraf analitik/reklam çerezleri kullanılıyorsa, bu sayfa güncellenir.',
              ),
              _Section(
                title: '3) Çerezleri nasıl kontrol edebilirsiniz?',
                body:
                    'Tarayıcı ayarlarınızdan çerezleri silebilir, engelleyebilir veya belirli siteler için izinleri yönetebilirsiniz. Çerezleri devre dışı bırakmanız bazı özelliklerin beklenenden farklı çalışmasına neden olabilir.',
              ),
              _Section(
                title: '4) Güncellemeler',
                body:
                    'Bu politika zaman zaman güncellenebilir. Güncellemeler sitede yayınlandığı tarihten itibaren geçerli olur.\n\nYürürlük tarihi: 17.02.2026',
              ),
              const SizedBox(height: 28),
              const SiteFooter(),
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
