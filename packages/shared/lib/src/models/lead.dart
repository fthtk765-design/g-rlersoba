class Lead {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? city;
  final String? message;
  final String? productId;
  final String? pageUrl;
  final String status;
  final String? adminNote;

  const Lead({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.city,
    this.message,
    this.productId,
    this.pageUrl,
    required this.status,
    this.adminNote,
  });

  factory Lead.fromMap(Map<String, dynamic> map) {
    return Lead(
      id: map['id'] as String,
      name: (map['name'] ?? '') as String,
      phone: (map['phone'] ?? '') as String,
      email: map['email'] as String?,
      city: map['city'] as String?,
      message: map['message'] as String?,
      productId: map['product_id'] as String?,
      pageUrl: map['page_url'] as String?,
      status: (map['status'] ?? 'new') as String,
      adminNote: map['admin_note'] as String?,
    );
  }

  Map<String, dynamic> toInsertMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'city': city,
      'message': message,
      'product_id': productId,
      'page_url': pageUrl,
    };
  }
}
