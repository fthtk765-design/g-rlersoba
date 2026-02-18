import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:public_site/l10n/app_localizations.dart';

import '../../data/providers.dart';

typedef L10n = AppLocalizations;

class LeadForm extends ConsumerStatefulWidget {
  final String? productId;
  final String? pageUrl;

  const LeadForm({super.key, this.productId, this.pageUrl});

  @override
  ConsumerState<LeadForm> createState() => _LeadFormState();
}

class _LeadFormState extends ConsumerState<LeadForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _city = TextEditingController();
  final _message = TextEditingController();

  bool _submitting = false;

  final _phoneMask = MaskTextInputFormatter(
    mask: '(###) ### ## ##',
    filter: {'#': RegExp(r'[0-9]')},
  );

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _city.dispose();
    _message.dispose();
    super.dispose();
  }

  String _digitsOnly(String input) => input.replaceAll(RegExp(r'[^0-9]'), '');

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitting = true);
    try {
      await ref.read(leadsRepositoryProvider).createLead(
            name: _name.text.trim(),
            phone: _digitsOnly(_phone.text),
            email: _email.text.trim().isEmpty ? null : _email.text.trim(),
            city: _city.text.trim().isEmpty ? null : _city.text.trim(),
            message: _message.text.trim().isEmpty ? null : _message.text.trim(),
            productId: widget.productId,
            pageUrl: widget.pageUrl,
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Talebiniz alındı. En kısa sürede dönüş yapacağız.')),
      );

      _formKey.currentState?.reset();
      _name.clear();
      _phone.clear();
      _email.clear();
      _city.clear();
      _message.clear();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gönderim sırasında hata oluştu. Lütfen tekrar deneyin.')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _name,
            decoration: InputDecoration(labelText: l10n.formName),
            validator: (v) => (v ?? '').trim().isEmpty ? l10n.validationRequired : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phone,
            decoration: InputDecoration(labelText: l10n.formPhone),
            keyboardType: TextInputType.phone,
            inputFormatters: [_phoneMask],
            validator: (v) {
              final digits = _digitsOnly(v ?? '');
              if (digits.length < 10) return l10n.validationPhone;
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _email,
            decoration: InputDecoration(labelText: l10n.formEmail),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _city,
            decoration: InputDecoration(labelText: l10n.formCity),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _message,
            decoration: InputDecoration(labelText: l10n.formMessage),
            minLines: 3,
            maxLines: 6,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.formSubmit),
            ),
          ),
        ],
      ),
    );
  }
}
