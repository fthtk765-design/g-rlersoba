import '../models/lead.dart';

class LeadsRepository {
  static final List<Lead> _leads = <Lead>[];

  Future<void> createLead({
    required String name,
    required String phone,
    String? email,
    String? city,
    String? message,
    String? productId,
    String? pageUrl,
  }) async {
    final lead = Lead(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      phone: phone,
      email: email,
      city: city,
      message: message,
      productId: productId,
      pageUrl: pageUrl,
      status: 'new',
      adminNote: null,
    );

    _leads.insert(0, lead);
  }

  Future<int> countLeads() async {
    return _leads.length;
  }

  Future<List<Lead>> listLeads({int limit = 100}) async {
    return _leads.take(limit).toList(growable: false);
  }

  Future<void> updateLeadStatus({required String id, required String status}) async {
    final idx = _leads.indexWhere((l) => l.id == id);
    if (idx < 0) return;
    final current = _leads[idx];
    _leads[idx] = Lead(
      id: current.id,
      name: current.name,
      phone: current.phone,
      email: current.email,
      city: current.city,
      message: current.message,
      productId: current.productId,
      pageUrl: current.pageUrl,
      status: status,
      adminNote: current.adminNote,
    );
  }

  Future<void> updateLeadAdminNote({required String id, required String? adminNote}) async {
    final idx = _leads.indexWhere((l) => l.id == id);
    if (idx < 0) return;
    final current = _leads[idx];
    _leads[idx] = Lead(
      id: current.id,
      name: current.name,
      phone: current.phone,
      email: current.email,
      city: current.city,
      message: current.message,
      productId: current.productId,
      pageUrl: current.pageUrl,
      status: current.status,
      adminNote: adminNote,
    );
  }
}
