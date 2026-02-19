import 'package:go_router/go_router.dart';

import 'ui/pages/categories_page.dart';
import 'ui/pages/category_page.dart';
import 'ui/pages/contact_page.dart';
import 'ui/pages/cookie_policy_page.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/not_found_page.dart';
import 'ui/pages/privacy_policy_page.dart';
import 'ui/pages/product_detail_page.dart';
import 'ui/shell/public_shell.dart';

GoRouter buildPublicRouter() {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final productSlug = state.uri.queryParameters['u'];
      if (state.uri.path == '/' && productSlug != null && productSlug.isNotEmpty) {
        return '/u/$productSlug';
      }
      return null;
    },
    errorBuilder: (context, state) => const NotFoundPage(),
    routes: [
      ShellRoute(
        builder: (context, state, child) => PublicShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/kategoriler',
            builder: (context, state) => const CategoriesPage(),
          ),
          GoRoute(
            path: '/k/:categorySlug',
            builder: (context, state) {
              final slug = state.pathParameters['categorySlug']!;
              return CategoryPage(categorySlug: slug);
            },
          ),
          GoRoute(
            path: '/u/:productSlug',
            builder: (context, state) {
              final slug = state.pathParameters['productSlug']!;
              return ProductDetailPage(productSlug: slug);
            },
          ),
          GoRoute(
            path: '/iletisim',
            builder: (context, state) => const ContactPage(),
          ),
          GoRoute(
            path: '/gizlilik',
            builder: (context, state) => const PrivacyPolicyPage(),
          ),
          GoRoute(
            path: '/cerez-politikasi',
            builder: (context, state) => const CookiePolicyPage(),
          ),
        ],
      ),
    ],
  );
}
