enum ProductMediaKind { image, pdf }

class ProductMedia {
  final String id;
  final String productId;
  final ProductMediaKind kind;
  final String url;
  final String? altText;
  final int sortOrder;

  const ProductMedia({
    required this.id,
    required this.productId,
    required this.kind,
    required this.url,
    this.altText,
    required this.sortOrder,
  });

  factory ProductMedia.fromMap(Map<String, dynamic> map) {
    final kindStr = (map['kind'] ?? 'image') as String;
    return ProductMedia(
      id: map['id'] as String,
      productId: map['product_id'] as String,
      kind: kindStr == 'pdf' ? ProductMediaKind.pdf : ProductMediaKind.image,
      url: (map['url'] ?? '') as String,
      altText: map['alt_text'] as String?,
      sortOrder: (map['sort_order'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap({bool includeId = false}) {
    return {
      if (includeId) 'id': id,
      'product_id': productId,
      'kind': kind == ProductMediaKind.pdf ? 'pdf' : 'image',
      'url': url,
      'alt_text': altText,
      'sort_order': sortOrder,
    };
  }
}
