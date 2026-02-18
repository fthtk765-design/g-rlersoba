import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

import 'src/app.dart';
import 'src/data/providers.dart';
import 'src/platform/scroll_restoration.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfig.fromDartDefines();

  disableBrowserScrollRestoration();

  runApp(
    ProviderScope(
      overrides: [appConfigProvider.overrideWithValue(config)],
      child: const PublicApp(),
    ),
  );

  WidgetsBinding.instance.addPostFrameCallback((_) {
    browserScrollToTop();
  });
}
