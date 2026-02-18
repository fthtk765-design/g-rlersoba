import 'package:collection/collection.dart';

import '../models/category.dart';
import '../models/product.dart';
import '../models/product_media.dart';
import 'demo_catalog_data.dart';

enum ProductSort {
  nameAsc,
  nameDesc,
  powerAsc,
  powerDesc,
}

class ProductFilters {
  final String? fuelType;
  final num? powerMin;
  final num? powerMax;
  final int? areaMin;
  final int? areaMax;

  const ProductFilters({
    this.fuelType,
    this.powerMin,
    this.powerMax,
    this.areaMin,
    this.areaMax,
  });

  ProductFilters copyWith({
    String? fuelType,
    num? powerMin,
    num? powerMax,
    int? areaMin,
    int? areaMax,
  }) {
    return ProductFilters(
      fuelType: fuelType ?? this.fuelType,
      powerMin: powerMin ?? this.powerMin,
      powerMax: powerMax ?? this.powerMax,
      areaMin: areaMin ?? this.areaMin,
      areaMax: areaMax ?? this.areaMax,
    );
  }
}

class CatalogRepository {
  final List<Category> _categories;
  final List<Product> _products;
  final List<ProductMedia> _media;

  CatalogRepository({
    List<Category>? categories,
    List<Product>? products,
    List<ProductMedia>? media,
  })  : _categories = categories ?? _demoCategories,
        _products = products ?? _demoProducts,
        _media = media ?? _demoMedia;

  Future<List<Category>> listActiveCategories() async {
    final items = _categories.where((c) => c.isActive).toList(growable: false);
    items.sort((a, b) {
      final bySort = a.sortOrder.compareTo(b.sortOrder);
      if (bySort != 0) return bySort;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return items;
  }

  Future<Category?> getCategoryBySlug(String slug) async {
    return _categories.firstWhereOrNull((c) => c.slug == slug);
  }

  Future<Category?> getCategoryById(String id) async {
    return _categories.firstWhereOrNull((c) => c.id == id);
  }

  Future<List<Product>> listFeaturedProducts({int limit = 8}) async {
    final items = _products.where((p) => p.isPublished && p.isFeatured).toList(growable: false);
    return items.take(limit).toList(growable: false);
  }

  Future<List<Product>> listProductsByCategory({
    required String categoryId,
    required ProductFilters filters,
    required ProductSort sort,
  }) async {
    var items = _products.where((p) => p.isPublished && p.categoryId == categoryId);

    if ((filters.fuelType ?? '').isNotEmpty) {
      items = items.where((p) => (p.fuelType ?? '') == filters.fuelType);
    }
    if (filters.powerMin != null) {
      items = items.where((p) => (p.powerKw ?? double.negativeInfinity) >= filters.powerMin!);
    }
    if (filters.powerMax != null) {
      items = items.where((p) => (p.powerKw ?? double.infinity) <= filters.powerMax!);
    }
    if (filters.areaMin != null) {
      items = items.where((p) => (p.areaM2Max ?? -2147483648) >= filters.areaMin!);
    }
    if (filters.areaMax != null) {
      items = items.where((p) => (p.areaM2Min ?? 2147483647) <= filters.areaMax!);
    }

    final list = items.toList(growable: false);

    int compareNullableNumAsc(num? a, num? b) {
      if (a == null && b == null) return 0;
      if (a == null) return 1;
      if (b == null) return -1;
      return a.compareTo(b);
    }

    int compareNullableNumDesc(num? a, num? b) {
      if (a == null && b == null) return 0;
      if (a == null) return 1;
      if (b == null) return -1;
      return b.compareTo(a);
    }

    switch (sort) {
      case ProductSort.nameAsc:
        list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case ProductSort.nameDesc:
        list.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
        break;
      case ProductSort.powerAsc:
        list.sort((a, b) => compareNullableNumAsc(a.powerKw, b.powerKw));
        break;
      case ProductSort.powerDesc:
        list.sort((a, b) => compareNullableNumDesc(a.powerKw, b.powerKw));
        break;
    }

    return list;
  }

  Future<Product?> getProductBySlug(String slug) async {
    final p = _products.firstWhereOrNull((p) => p.slug == slug);
    if (p == null) return null;
    return p.isPublished ? p : null;
  }

  Future<List<ProductMedia>> listProductMedia(String productId) async {
    final items = _media.where((m) => m.productId == productId).toList(growable: false);
    items.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return items;
  }

  Future<String?> getPrimaryImageUrl(String productId) async {
    final media = await listProductMedia(productId);
    return media.firstWhereOrNull((m) => m.kind == ProductMediaKind.image)?.url;
  }
}

// --- Demo data (Supabase'siz çalıştırma için) ---

const List<Category> _demoCategories = demoCategories;
const List<Product> _demoProducts = demoProducts;
const List<ProductMedia> _demoMedia = demoMedia;
