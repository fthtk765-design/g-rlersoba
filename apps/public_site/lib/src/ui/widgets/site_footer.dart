import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:public_site/l10n/app_localizations.dart';

typedef L10n = AppLocalizations;

class SiteFooter extends StatelessWidget {
  static final Uri _instagramUri = Uri.parse('https://www.instagram.com/gurler.soba.manavgat/');

  const SiteFooter({super.key});

  Future<void> _openInstagram() async {
    await launchUrl(_instagramUri, mode: LaunchMode.platformDefault);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final theme = Theme.of(context);
    final year = DateTime.now().year;

    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: LayoutBuilder(
              builder: (context, c) {
                final isNarrow = c.maxWidth < 700;

                final brand = Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/brand/logo.png',
                      height: 22,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '© $year ${l10n.appTitle}',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                );

                final links = Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    TextButton.icon(
                      onPressed: _openInstagram,
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text('Instagram'),
                    ),
                    TextButton(
                      onPressed: () => context.go('/gizlilik'),
                      child: Text(l10n.privacyTitle),
                    ),
                    TextButton(
                      onPressed: () => context.go('/cerez-politikasi'),
                      child: Text(l10n.cookieTitle),
                    ),
                  ],
                );

                if (isNarrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      brand,
                      const SizedBox(height: 10),
                      links,
                    ],
                  );
                }

                return Row(
                  children: [
                    brand,
                    const Spacer(),
                    links,
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
