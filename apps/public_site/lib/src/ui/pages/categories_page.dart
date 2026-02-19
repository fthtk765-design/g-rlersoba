import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:public_site/l10n/app_localizations.dart';

import '../../data/providers.dart';
import '../widgets/category_card.dart';
import '../widgets/section_header.dart';
import '../widgets/site_footer.dart';

typedef L10n = AppLocalizations;

class CategoriesPage extends ConsumerWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    final categoriesAsync = ref.watch(categoriesProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: l10n.navCategories),
          const SizedBox(height: 20),
          Expanded(
            child: categoriesAsync.when(
              data: (cats) {
                return LayoutBuilder(
                  builder: (context, c) {
                    final width = c.maxWidth;
                    final columns = width >= 1024 ? 3 : (width >= 600 ? 2 : 1);
                    final gap = 12.0;
                    final cardWidth = (width - gap * (columns - 1)) / columns;

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Wrap(
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
                          ),
                          const SizedBox(height: 28),
                          const SiteFooter(),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => Center(child: Text(l10n.loading)),
              error: (error, stackTrace) => const Center(child: Text('Kategoriler yüklenemedi.')),
            ),
          ),
        ],
      ),
    );
  }
}
