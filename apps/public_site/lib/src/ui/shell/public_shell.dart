import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:public_site/l10n/app_localizations.dart';

typedef L10n = AppLocalizations;

class PublicShell extends StatelessWidget {
  final Widget child;
  static final Uri _instagramUri = Uri.parse('https://www.instagram.com/gurler.soba.manavgat/');

  const PublicShell({super.key, required this.child});

  Future<void> _openInstagram() async {
    await launchUrl(_instagramUri, mode: LaunchMode.platformDefault);
  }

  Widget _buildHeader(BuildContext context, L10n l10n) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final compactNav = width < 760;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          InkWell(
            onTap: () => context.go('/'),
            borderRadius: BorderRadius.circular(12),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                border: Border.all(color: theme.colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Image.asset(
                  'assets/brand/logo.png',
                  height: 30,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) {
                    return Text(
                      l10n.appTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge,
                    );
                  },
                ),
              ),
            ),
          ),
          const Spacer(),
          if (compactNav)
            PopupMenuButton<String>(
              onSelected: (location) => context.go(location),
              itemBuilder: (context) => [
                PopupMenuItem(value: '/', child: Text(l10n.navHome)),
                PopupMenuItem(value: '/kategoriler', child: Text(l10n.navCategories)),
                PopupMenuItem(value: '/iletisim', child: Text(l10n.navContact)),
              ],
            )
          else ...[
            _NavButton(label: l10n.navHome, location: '/'),
            _NavButton(label: l10n.navCategories, location: '/kategoriler'),
            _NavButton(label: l10n.navContact, location: '/iletisim'),
          ],
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, L10n l10n) {
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

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, l10n),
            Expanded(child: child),
            _buildFooter(context, l10n),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final String location;

  const _NavButton({required this.label, required this.location});

  @override
  Widget build(BuildContext context) {
    bool isActive;
    try {
      isActive = GoRouterState.of(context).uri.toString() == location;
    } catch (_) {
      isActive = false;
    }

    return TextButton(
      onPressed: () => context.go(location),
      child: Text(
        label,
        style: TextStyle(fontWeight: isActive ? FontWeight.w700 : FontWeight.w500),
      ),
    );
  }
}
