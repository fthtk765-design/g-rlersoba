import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:public_site/l10n/app_localizations.dart';

import '../../data/providers.dart';

typedef L10n = AppLocalizations;

class ProductCard extends ConsumerWidget {
  final Product product;
  final String? categoryName;

  const ProductCard({super.key, required this.product, this.categoryName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    final theme = Theme.of(context);
    const whatsappGreen = Color(0xFF25D366);

    final imageAsync = ref.watch(primaryImageUrlProvider(product.id));
    final phoneAsync = ref.watch(whatsappPhoneProvider);
    final config = ref.watch(appConfigProvider);
    final categoryAsync = categoryName == null
      ? ref.watch(categoryByIdProvider(product.categoryId))
      : const AsyncValue<Category?>.data(null);

    final resolvedCategoryName = categoryName ?? categoryAsync.asData?.value?.name ?? '—';

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: imageAsync.when(
              data: (url) {
                if ((url ?? '').isEmpty) {
                  return Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.image_outlined, color: theme.colorScheme.onSurfaceVariant),
                          const SizedBox(height: 8),
                          Text(
                            'Görsel yakında',
                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                final imageUrl = url!;
                if (kIsWeb) {
                  return Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: theme.colorScheme.surfaceContainerHighest);
                    },
                  );
                }
                return CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) {
                    return Container(color: theme.colorScheme.surfaceContainerHighest);
                  },
                );
              },
              loading: () => Container(color: theme.colorScheme.surfaceContainerHighest),
              error: (error, stackTrace) => Container(color: theme.colorScheme.surfaceContainerHighest),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _TechPill(label: formatKw(product.powerKw)),
                    _TechPill(label: formatM2Range(product.areaM2Min, product.areaM2Max)),
                    _TechPill(label: formatPct(product.efficiencyPct)),
                    _TechPill(label: product.warrantyYears == null ? '—' : '${product.warrantyYears} yıl garanti'),
                  ],
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, c) {
                    final isVeryNarrow = c.maxWidth < 360;

                    final detailsButton = OutlinedButton(
                      onPressed: () => context.go('/u/${product.slug}'),
                      child: Text(l10n.ctaDetails),
                    );

                    final whatsappButton = FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: whatsappGreen,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: phoneAsync.whenOrNull(
                        data: (phone) => () async {
                          final msg = buildProductWhatsAppMessage(
                            productName: product.name,
                            productSlugOrCode: product.slug,
                            categoryName: resolvedCategoryName,
                            config: config,
                          );
                          final url = buildWhatsAppUrl(phoneE164Digits: phone, message: msg);
                          await launchUrl(Uri.parse(url), mode: LaunchMode.platformDefault);
                        },
                      ),
                      child: Text(l10n.ctaWhatsApp),
                    );

                    if (isVeryNarrow) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          detailsButton,
                          const SizedBox(height: 10),
                          whatsappButton,
                        ],
                      );
                    }

                    return Row(
                      children: [
                        detailsButton,
                        const SizedBox(width: 12),
                        Expanded(child: whatsappButton),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TechPill extends StatelessWidget {
  final String label;

  const _TechPill({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: theme.textTheme.bodyMedium),
    );
  }
}
