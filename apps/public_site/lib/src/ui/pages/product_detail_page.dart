import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:public_site/l10n/app_localizations.dart';

import '../../data/providers.dart';

typedef L10n = AppLocalizations;

class ProductDetailPage extends ConsumerWidget {
  final String productSlug;

  const ProductDetailPage({super.key, required this.productSlug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;

    final productAsync = ref.watch(productBySlugProvider(productSlug));

    return productAsync.when(
      data: (product) {
        if (product == null) {
          return Center(child: Text(l10n.notFound));
        }
        return _ProductBody(product: product);
      },
      loading: () => Center(child: Text(l10n.loading)),
      error: (error, stackTrace) => const Center(child: Text('Ürün yüklenemedi.')),
    );
  }
}

class _ProductBody extends ConsumerWidget {
  final Product product;

  const _ProductBody({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    final theme = Theme.of(context);
    const whatsappGreen = Color(0xFF25D366);

    final categoryAsync = ref.watch(categoryByIdProvider(product.categoryId));
    final mediaAsync = ref.watch(productMediaProvider(product.id));
    final phoneAsync = ref.watch(whatsappPhoneProvider);
    final config = ref.watch(appConfigProvider);

    final pageUrl = config.publicSiteBaseUri.replace(path: '/u/${product.slug}').toString();

    return LayoutBuilder(
      builder: (context, c) {
        final isMobile = c.maxWidth < 600;

        return Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: theme.textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    categoryAsync.when(
                      data: (cat) => Text(cat?.name ?? '—', style: theme.textTheme.bodyLarge),
                      loading: () => const SizedBox.shrink(),
                      error: (error, stackTrace) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 16),
                    mediaAsync.when(
                      data: (media) {
                        final images = media.where((m) => m.kind == ProductMediaKind.image).toList();
                        if (images.isEmpty) {
                          return Container(
                            height: 320,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          );
                        }
                        return _ImageGallery(urls: images.map((e) => e.url).toList());
                      },
                      loading: () => Container(
                        height: 320,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      error: (error, stackTrace) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 24),

                    if ((product.shortDesc ?? '').trim().isNotEmpty) ...[
                      Text(product.shortDesc!, style: theme.textTheme.bodyLarge),
                      const SizedBox(height: 16),
                    ],

                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: whatsappGreen,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: phoneAsync.whenOrNull(
                        data: (phone) => () async {
                          final categoryName = categoryAsync.asData?.value?.name ?? '—';
                          final msg = buildProductWhatsAppMessage(
                            productName: product.name,
                            productSlugOrCode: product.slug,
                            categoryName: categoryName,
                            config: config,
                          );
                          final url = buildWhatsAppUrl(phoneE164Digits: phone, message: msg);
                          await launchUrl(Uri.parse(url), mode: LaunchMode.platformDefault);
                        },
                      ),
                      child: Text(l10n.ctaWhatsApp),
                    ),

                    const SizedBox(height: 24),
                    Text('Teknik Bilgiler', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 12),
                    _TechTable(product: product),

                    const SizedBox(height: 24),
                    if ((product.longDesc ?? '').trim().isNotEmpty) ...[
                      Text('Açıklama', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 12),
                      MarkdownBody(data: product.longDesc!),
                      const SizedBox(height: 24),
                    ],

                    mediaAsync.when(
                      data: (media) {
                        final pdfs = media.where((m) => m.kind == ProductMediaKind.pdf).toList();
                        if (pdfs.isEmpty) return const SizedBox.shrink();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('PDF / Teknik Föy', style: theme.textTheme.titleLarge),
                            const SizedBox(height: 12),
                            for (final pdf in pdfs)
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.picture_as_pdf),
                                title: Text(pdf.altText?.trim().isNotEmpty == true ? pdf.altText! : 'PDF indir'),
                                subtitle: Text(pdf.url),
                                onTap: () => launchUrl(Uri.parse(pdf.url), mode: LaunchMode.platformDefault),
                              ),
                          ],
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (error, stackTrace) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: isMobile
              ? _StickyCtaBar(
                  pageUrl: pageUrl,
                  product: product,
                )
              : null,
        );
      },
    );
  }
}

class _StickyCtaBar extends ConsumerWidget {
  final String pageUrl;
  final Product product;

  const _StickyCtaBar({required this.pageUrl, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    final phoneAsync = ref.watch(whatsappPhoneProvider);
    const whatsappGreen = Color(0xFF25D366);

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: phoneAsync.whenOrNull(
                  data: (phone) => () async {
                    final tel = '+${phone.replaceAll(RegExp(r'[^0-9]'), '')}';
                    await launchUrl(Uri.parse('tel:$tel'), mode: LaunchMode.platformDefault);
                  },
                ),
                icon: const Icon(Icons.call),
                label: Text(l10n.ctaCall),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: whatsappGreen,
                  foregroundColor: Colors.white,
                ),
                onPressed: phoneAsync.whenOrNull(
                  data: (phone) {
                    return () async {
                      final config = ref.read(appConfigProvider);
                      final category = await ref.read(catalogRepositoryProvider).getCategoryById(product.categoryId);
                      final msg = buildProductWhatsAppMessage(
                        productName: product.name,
                        productSlugOrCode: product.slug,
                        categoryName: category?.name ?? '—',
                        config: config,
                      );
                      final url = buildWhatsAppUrl(phoneE164Digits: phone, message: msg);
                      await launchUrl(Uri.parse(url), mode: LaunchMode.platformDefault);
                    };
                  },
                ),
                icon: const Icon(Icons.chat),
                label: Text('WhatsApp'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageGallery extends StatefulWidget {
  final List<String> urls;

  const _ImageGallery({required this.urls});

  @override
  State<_ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<_ImageGallery> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget buildCoverImage(String url) {
      if (kIsWeb) {
        return Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(color: theme.colorScheme.surfaceContainerHighest);
          },
        );
      }
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) {
          return Container(color: theme.colorScheme.surfaceContainerHighest);
        },
      );
    }

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.urls.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (context, i) {
                return buildCoverImage(widget.urls[i]);
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.urls.length, (i) {
            final active = i == _index;
            return Container(
              width: active ? 10 : 8,
              height: active ? 10 : 8,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active ? theme.colorScheme.onSurface : theme.colorScheme.outlineVariant,
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.urls.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              return InkWell(
                onTap: () => _controller.animateToPage(i, duration: const Duration(milliseconds: 250), curve: Curves.easeOut),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: buildCoverImage(widget.urls[i]),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TechTable extends StatelessWidget {
  final Product product;

  const _TechTable({required this.product});

  @override
  Widget build(BuildContext context) {
    final rows = <(String, String)>[
      ('Güç', formatKw(product.powerKw)),
      ('Önerilen Alan', formatM2Range(product.areaM2Min, product.areaM2Max)),
      ('Ölçüler (GxYxD)', _dims(product.dimensions)),
      ('Ağırlık', formatKg(product.weightKg)),
      ('Çıkış Çapı', formatMm(product.flueDiameterMm)),
      ('Verim', formatPct(product.efficiencyPct)),
      ('Malzeme', product.material ?? '—'),
      ('Cam Tipi', product.glassType ?? '—'),
      ('Garanti', product.warrantyYears == null ? '—' : '${product.warrantyYears} yıl'),
    ];

    return Table(
      columnWidths: const {
        0: FixedColumnWidth(160),
      },
      border: TableBorder.all(color: Theme.of(context).colorScheme.outlineVariant),
      children: [
        for (final r in rows)
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(r.$1, style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(r.$2),
              ),
            ],
          ),
      ],
    );
  }

  static String _dims(ProductDimensions d) {
    final w = d.w;
    final h = d.h;
    final depth = d.d;
    if (w == null && h == null && depth == null) return '—';
    final parts = [w, h, depth].map((e) => e?.toString()).toList();
    return '${parts[0] ?? '—'} x ${parts[1] ?? '—'} x ${parts[2] ?? '—'}';
  }
}
