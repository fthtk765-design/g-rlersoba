import 'package:flutter/material.dart';
import 'package:public_site/l10n/app_localizations.dart';

typedef L10n = AppLocalizations;

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    return Scaffold(
      body: Center(
        child: Text(l10n.notFound),
      ),
    );
  }
}
