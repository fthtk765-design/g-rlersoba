import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError('AppConfig main.dart üzerinden override edilir.');
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final config = ref.read(appConfigProvider);
  return SettingsRepository(whatsappPhoneDigits: config.whatsappPhoneDigits);
});

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return CatalogRepository();
});

final leadsRepositoryProvider = Provider<LeadsRepository>((ref) {
  return LeadsRepository();
});

final whatsappPhoneProvider = FutureProvider<String>((ref) async {
  return ref.read(settingsRepositoryProvider).getWhatsAppPhoneOrFallback();
});

final categoriesProvider = FutureProvider((ref) {
  return ref.read(catalogRepositoryProvider).listActiveCategories();
});

final featuredProductsProvider = FutureProvider((ref) {
  return ref.read(catalogRepositoryProvider).listFeaturedProducts(limit: 8);
});

final categoryBySlugProvider = FutureProvider.family<Category?, String>((ref, slug) {
  return ref.read(catalogRepositoryProvider).getCategoryBySlug(slug);
});

final categoryByIdProvider = FutureProvider.family<Category?, String>((ref, id) {
  return ref.read(catalogRepositoryProvider).getCategoryById(id);
});

final productBySlugProvider = FutureProvider.family<Product?, String>((ref, slug) {
  return ref.read(catalogRepositoryProvider).getProductBySlug(slug);
});

final productMediaProvider = FutureProvider.family<List<ProductMedia>, String>((ref, productId) {
  return ref.read(catalogRepositoryProvider).listProductMedia(productId);
});

final primaryImageUrlProvider = FutureProvider.family<String?, String>((ref, productId) {
  return ref.read(catalogRepositoryProvider).getPrimaryImageUrl(productId);
});

class CategoryFiltersNotifier extends Notifier<ProductFilters> {
  @override
  ProductFilters build() => const ProductFilters();

  void setFilters(ProductFilters next) => state = next;
}

final categoryFiltersProvider = NotifierProvider<CategoryFiltersNotifier, ProductFilters>(
  CategoryFiltersNotifier.new,
);

class CategorySortNotifier extends Notifier<ProductSort> {
  @override
  ProductSort build() => ProductSort.nameAsc;

  void setSort(ProductSort next) => state = next;
}

final categorySortProvider = NotifierProvider<CategorySortNotifier, ProductSort>(
  CategorySortNotifier.new,
);

final productsByCategoryProvider = FutureProvider.family<List<Product>, String>((ref, categoryId) {
  final filters = ref.watch(categoryFiltersProvider);
  final sort = ref.watch(categorySortProvider);
  return ref.read(catalogRepositoryProvider).listProductsByCategory(
        categoryId: categoryId,
        filters: filters,
        sort: sort,
      );
});
