import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:public_site/l10n/app_localizations.dart';

typedef L10n = AppLocalizations;

class PublicShell extends StatelessWidget {
  final Widget child;

  const PublicShell({super.key, required this.child});

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
