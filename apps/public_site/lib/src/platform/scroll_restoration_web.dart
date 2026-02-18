// ignore_for_file: deprecated_member_use

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void disableBrowserScrollRestoration() {
  try {
    html.window.history.scrollRestoration = 'manual';
  } catch (_) {
    // no-op
  }
}

void browserScrollToTop() {
  try {
    html.window.scrollTo(0, 0);
  } catch (_) {
    // no-op
  }
}
