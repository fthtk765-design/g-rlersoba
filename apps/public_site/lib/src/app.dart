import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:public_site/l10n/app_localizations.dart';

import 'router.dart';
import 'ui/theme/public_theme.dart';

class PublicApp extends StatelessWidget {
  const PublicApp({super.key});

  static final _router = buildPublicRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      onGenerateTitle: (context) => AppLocalizations.of(context)?.appTitle ?? 'Gürler Soba',
      locale: const Locale('tr', 'TR'),
      supportedLocales: const [Locale('tr', 'TR')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: buildPublicTheme(),
    );
  }
}
