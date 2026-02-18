import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:public_site/l10n/app_localizations.dart';

import '../../data/providers.dart';
import '../widgets/category_card.dart';
import '../widgets/product_card.dart';
import '../widgets/section_header.dart';

typedef L10n = AppLocalizations;

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    final categoriesAsync = ref.watch(categoriesProvider);
    final featuredAsync = ref.watch(featuredProductsProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Hero(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(title: l10n.sectionCategories),
                const SizedBox(height: 20),
                categoriesAsync.when(
                  data: (cats) {
                    return LayoutBuilder(
                      builder: (context, c) {
                        final width = c.maxWidth;
                        final columns = width >= 1024 ? 3 : (width >= 600 ? 2 : 1);
                        final gap = 12.0;
                        final cardWidth = (width - gap * (columns - 1)) / columns;

                        return Wrap(
                          spacing: gap,
                          runSpacing: gap,
                          children: [
                            for (final cat in cats)
                              SizedBox(
                                width: cardWidth,
                                child: CategoryCard(
                                  title: cat.name,
                                  onTap: () => context.go('/k/${cat.slug}'),
                                ),
                              ),
                          ],
                        );
                      },
                    );
                  },
                  loading: () => Text(l10n.loading),
                  error: (error, stackTrace) => const Text('Kategoriler yüklenemedi.'),
                ),

                const SizedBox(height: 56),
                SectionHeader(title: l10n.sectionFeatured),
                const SizedBox(height: 20),
                featuredAsync.when(
                  data: (products) {
                    if (products.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return LayoutBuilder(
                      builder: (context, c) {
                        final width = c.maxWidth;
                        final columns = width >= 1024 ? 3 : (width >= 600 ? 2 : 1);
                        final gap = 12.0;
                        final cardWidth = (width - gap * (columns - 1)) / columns;

                        return Wrap(
                          spacing: gap,
                          runSpacing: gap,
                          children: [
                            for (final p in products)
                              SizedBox(
                                width: cardWidth,
                                child: ProductCard(
                                  product: p,
                                ),
                              ),
                          ],
                        );
                      },
                    );
                  },
                  loading: () => Text(l10n.loading),
                  error: (error, stackTrace) => const Text('Ürünler yüklenemedi.'),
                ),

                const SizedBox(height: 44),
                const Divider(),
                const SizedBox(height: 20),
                Text(
                  'Sorularınız için WhatsApp’tan yazabilir veya bizi arayabilirsiniz.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    FilledButton(
                      onPressed: () => context.go('/iletisim'),
                      child: Text(l10n.navContact),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 56, 16, 56),
      color: theme.colorScheme.surface,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: LayoutBuilder(
            builder: (context, c) {
              final isDesktop = c.maxWidth >= 1024;

              final content = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.heroTitle, style: theme.textTheme.displaySmall),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Text(l10n.heroSubtitle, style: theme.textTheme.bodyLarge),
                  ),
                  const SizedBox(height: 28),
                  FilledButton(
                    onPressed: () => context.go('/kategoriler'),
                    child: Text(l10n.navCategories),
                  ),
                ],
              );

              if (!isDesktop) return content;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: content),
                  const SizedBox(width: 32),
                  SizedBox(
                    width: 420,
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: theme.colorScheme.outlineVariant),
                          color: theme.colorScheme.surfaceContainerHighest,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.local_fire_department_outlined,
                            size: 56,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
