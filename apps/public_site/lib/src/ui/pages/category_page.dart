import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

import 'package:public_site/l10n/app_localizations.dart';

import '../../data/providers.dart';
import '../widgets/product_card.dart';
import '../widgets/section_header.dart';
import '../widgets/site_footer.dart';

typedef L10n = AppLocalizations;

class CategoryPage extends ConsumerWidget {
  final String categorySlug;

  const CategoryPage({super.key, required this.categorySlug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    final categoryAsync = ref.watch(categoryBySlugProvider(categorySlug));

    return categoryAsync.when(
      data: (category) {
        if (category == null) {
          return Center(child: Text(l10n.notFound));
        }
        return _CategoryBody(category: category);
      },
      loading: () => Center(child: Text(l10n.loading)),
      error: (error, stackTrace) => const Center(child: Text('Kategori yüklenemedi.')),
    );
  }
}

class _CategoryBody extends ConsumerWidget {
  final Category category;

  const _CategoryBody({required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;

    final filters = ref.watch(categoryFiltersProvider);
    final sort = ref.watch(categorySortProvider);

    final productsAsync = ref.watch(productsByCategoryProvider(category.id));

    return LayoutBuilder(
      builder: (context, c) {
        final width = c.maxWidth;
        final isMobile = width < 600;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title: category.name),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (isMobile)
                    OutlinedButton.icon(
                      onPressed: () => _openFilterSheet(context, ref, filters),
                      icon: const Icon(Icons.tune),
                      label: const Text('Filtrele'),
                    )
                  else
                    const SizedBox.shrink(),
                  const SizedBox(width: 12),
                  DropdownButton<ProductSort>(
                    value: sort,
                    onChanged: (v) {
                      if (v == null) return;
                      ref.read(categorySortProvider.notifier).setSort(v);
                    },
                    items: const [
                      DropdownMenuItem(value: ProductSort.nameAsc, child: Text('Ada göre (A–Z)')),
                      DropdownMenuItem(value: ProductSort.nameDesc, child: Text('Ada göre (Z–A)')),
                      DropdownMenuItem(value: ProductSort.powerAsc, child: Text('Güce göre (Artan)')),
                      DropdownMenuItem(value: ProductSort.powerDesc, child: Text('Güce göre (Azalan)')),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isMobile)
                      SizedBox(
                        width: 280,
                        child: _FiltersSidebar(
                          initial: filters,
                          onApply: (next) => ref.read(categoryFiltersProvider.notifier).setFilters(next),
                        ),
                      ),
                    if (!isMobile) const SizedBox(width: 16),
                    Expanded(
                      child: productsAsync.when(
                        data: (products) {
                          if (products.isEmpty) {
                            return Center(child: Text(l10n.emptyProducts));
                          }

                          return LayoutBuilder(
                            builder: (context, c2) {
                              final w = c2.maxWidth;
                              final columns = w >= 1024 ? 3 : (w >= 600 ? 2 : 1);
                              final gap = 12.0;
                              final cardWidth = (w - gap * (columns - 1)) / columns;

                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Wrap(
                                      spacing: gap,
                                      runSpacing: gap,
                                      children: [
                                        for (final p in products)
                                          SizedBox(
                                            width: cardWidth,
                                            child: ProductCard(
                                              product: p,
                                              categoryName: category.name,
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
                        error: (error, stackTrace) => const Center(child: Text('Ürünler yüklenemedi.')),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openFilterSheet(BuildContext context, WidgetRef ref, ProductFilters current) async {
    final next = await showModalBottomSheet<ProductFilters>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
        ),
        child: _FiltersEditor(
          initial: current,
          showHeader: true,
        ),
      ),
    );

    if (next != null) {
      ref.read(categoryFiltersProvider.notifier).setFilters(next);
    }
  }
}

class _FiltersSidebar extends StatelessWidget {
  final ProductFilters initial;
  final ValueChanged<ProductFilters> onApply;

  const _FiltersSidebar({required this.initial, required this.onApply});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _FiltersEditor(
          initial: initial,
          onApply: onApply,
        ),
      ),
    );
  }
}

class _FiltersEditor extends StatefulWidget {
  final ProductFilters initial;
  final bool showHeader;
  final ValueChanged<ProductFilters>? onApply;

  const _FiltersEditor({
    required this.initial,
    this.showHeader = false,
    this.onApply,
  });

  @override
  State<_FiltersEditor> createState() => _FiltersEditorState();
}

class _FiltersEditorState extends State<_FiltersEditor> {
  late final TextEditingController _powerMin;
  late final TextEditingController _powerMax;
  late final TextEditingController _areaMin;
  late final TextEditingController _areaMax;

  String? _fuel;

  @override
  void initState() {
    super.initState();
    _fuel = widget.initial.fuelType;
    _powerMin = TextEditingController(text: widget.initial.powerMin?.toString());
    _powerMax = TextEditingController(text: widget.initial.powerMax?.toString());
    _areaMin = TextEditingController(text: widget.initial.areaMin?.toString());
    _areaMax = TextEditingController(text: widget.initial.areaMax?.toString());
  }

  @override
  void dispose() {
    _powerMin.dispose();
    _powerMax.dispose();
    _areaMin.dispose();
    _areaMax.dispose();
    super.dispose();
  }

  ProductFilters _build() {
    num? parseNum(String s) => num.tryParse(s.replaceAll(',', '.'));
    int? parseInt(String s) => int.tryParse(s);

    return widget.initial.copyWith(
      fuelType: (_fuel ?? '').isEmpty ? null : _fuel,
      powerMin: parseNum(_powerMin.text.trim()),
      powerMax: parseNum(_powerMax.text.trim()),
      areaMin: parseInt(_areaMin.text.trim()),
      areaMax: parseInt(_areaMax.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showHeader) ...[
          Text('Filtreler', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
        ],
        DropdownButtonFormField<String>(
          initialValue: (_fuel ?? '').isEmpty ? null : _fuel,
          decoration: const InputDecoration(labelText: 'Yakıt Tipi'),
          items: const [
            DropdownMenuItem(value: 'wood', child: Text('Odun')),
            DropdownMenuItem(value: 'pellet', child: Text('Pelet')),
            DropdownMenuItem(value: 'gas', child: Text('Gaz')),
            DropdownMenuItem(value: 'electric', child: Text('Elektrik')),
          ],
          onChanged: (v) => setState(() => _fuel = v),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _powerMin,
                decoration: const InputDecoration(labelText: 'Min kW'),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _powerMax,
                decoration: const InputDecoration(labelText: 'Max kW'),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _areaMin,
                decoration: const InputDecoration(labelText: 'Min m²'),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _areaMax,
                decoration: const InputDecoration(labelText: 'Max m²'),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () {
              final next = _build();
              if (widget.onApply != null) {
                widget.onApply!(next);
              }
              Navigator.of(context).pop(next);
            },
            child: const Text('Uygula'),
          ),
        ),
      ],
    );
  }
}
