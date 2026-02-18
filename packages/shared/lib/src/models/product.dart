import 'dart:convert';

class ProductDimensions {
  final num? w;
  final num? h;
  final num? d;

  const ProductDimensions({this.w, this.h, this.d});

  factory ProductDimensions.fromJson(dynamic json) {
    if (json == null) return const ProductDimensions();
    if (json is Map<String, dynamic>) {
      return ProductDimensions(
        w: json['w'] as num?,
        h: json['h'] as num?,
        d: json['d'] as num?,
      );
    }
    if (json is String && json.isNotEmpty) {
      final parsed = jsonDecode(json);
      return ProductDimensions.fromJson(parsed);
    }
    return const ProductDimensions();
  }

  Map<String, dynamic> toJson() => {'w': w, 'h': h, 'd': d};
}

class Product {
  final String id;
  final String categoryId;
  final String name;
  final String slug;

  final String? shortDesc;
  final String? longDesc;

  final String? fuelType;
  final num? powerKw;

  final int? areaM2Min;
  final int? areaM2Max;

  final ProductDimensions dimensions;
  final num? weightKg;
  final int? flueDiameterMm;

  final String? material;
  final String? glassType;

  final num? efficiencyPct;
  final int? warrantyYears;

  final bool isFeatured;
  final bool isPublished;

  const Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.slug,
    this.shortDesc,
    this.longDesc,
    this.fuelType,
    this.powerKw,
    this.areaM2Min,
    this.areaM2Max,
    this.dimensions = const ProductDimensions(),
    this.weightKg,
    this.flueDiameterMm,
    this.material,
    this.glassType,
    this.efficiencyPct,
    this.warrantyYears,
    required this.isFeatured,
    required this.isPublished,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      categoryId: map['category_id'] as String,
      name: (map['name'] ?? '') as String,
      slug: (map['slug'] ?? '') as String,
      shortDesc: map['short_desc'] as String?,
      longDesc: map['long_desc'] as String?,
      fuelType: map['fuel_type'] as String?,
      powerKw: map['power_kw'] as num?,
      areaM2Min: (map['area_m2_min'] as num?)?.toInt(),
      areaM2Max: (map['area_m2_max'] as num?)?.toInt(),
      dimensions: ProductDimensions.fromJson(map['dimensions_json']),
      weightKg: map['weight_kg'] as num?,
      flueDiameterMm: (map['flue_diameter_mm'] as num?)?.toInt(),
      material: map['material'] as String?,
      glassType: map['glass_type'] as String?,
      efficiencyPct: map['efficiency_pct'] as num?,
      warrantyYears: (map['warranty_years'] as num?)?.toInt(),
      isFeatured: (map['is_featured'] as bool?) ?? false,
      isPublished: (map['is_published'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toMap({bool includeId = false}) {
    return {
      if (includeId) 'id': id,
      'category_id': categoryId,
      'name': name,
      'slug': slug,
      'short_desc': shortDesc,
      'long_desc': longDesc,
      'fuel_type': fuelType,
      'power_kw': powerKw,
      'area_m2_min': areaM2Min,
      'area_m2_max': areaM2Max,
      'dimensions_json': dimensions.toJson(),
      'weight_kg': weightKg,
      'flue_diameter_mm': flueDiameterMm,
      'material': material,
      'glass_type': glassType,
      'efficiency_pct': efficiencyPct,
      'warranty_years': warrantyYears,
      'is_featured': isFeatured,
      'is_published': isPublished,
    };
  }
}
