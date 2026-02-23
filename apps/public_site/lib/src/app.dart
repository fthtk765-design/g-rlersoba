import 'package:flutter/material.dart';
import 'ui/theme/public_theme.dart';

// ─── Routes ──────────────────────────────────────────────────────────────────
const _routeHome       = '/';
const _routeAbout      = '/hakkimizda';
const _routeContact    = '/iletisim';
const _routeCategories = '/kategoriler';
const _routeSomine     = '/kategoriler/somine';
const _routeAksesuar   = '/kategoriler/aksesuar';
const _routePrivacy    = '/gizlilik';
const _routeCookie     = '/cerez';
const _routeKvkk       = '/kvkk';

// ─── App ─────────────────────────────────────────────────────────────────────
class PublicApp extends StatelessWidget {
  const PublicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gürler Soba',
      theme: buildPublicTheme(),
      initialRoute: _routeHome,
      onGenerateRoute: (settings) {
        final pages = <String, Widget>{
          _routeHome:       const HomePage(),
          _routeAbout:      const AboutPage(),
          _routeContact:    const ContactPage(),
          _routeCategories: const CategoriesPage(),
          _routeSomine:     const SominePage(),
          _routeAksesuar:   const AksesuarPage(),
          _routePrivacy:    const PrivacyPage(),
          _routeCookie:     const CookiePage(),
          _routeKvkk:       const KvkkPage(),
        };
        final page = pages[settings.name] ?? const HomePage();
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => page,
          transitionDuration: const Duration(milliseconds: 220),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }
}

// ─── Ortak sayfa iskeleti (banner + nav + içerik) ────────────────────────────
class _PageShell extends StatelessWidget {
  final String activeRoute;
  final Widget child;

  const _PageShell({required this.activeRoute, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Sabit header (responsive) ──
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 768;
              return AspectRatio(
                aspectRatio: isDesktop ? 1080 / 100 : 1080 / 180,
                child: Image.asset(
                  isDesktop
                      ? 'assets/header-banner-desktop.png'
                      : 'assets/header-banner-mobile.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              );
            },
          ),
          _NavBar(activeRoute: activeRoute),

          // ── Kaydırılabilir içerik + footer ──
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  child,
                  const _Footer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Nav şeridi ──────────────────────────────────────────────────────────────
class _NavBar extends StatelessWidget {
  final String activeRoute;
  const _NavBar({required this.activeRoute});

  static const _items = [
    ('Anasayfa',   _routeHome),
    ('Hakkımızda', _routeAbout),
    ('İletişim',   _routeContact),
    ('Kategoriler',_routeCategories),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.outlineVariant, width: 1),
        ),
        color: colors.surface,
      ),
      height: 42,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Row(
            children: _items.map((item) {
              final (label, route) = item;
              final isActive = activeRoute == route ||
                  (route == _routeCategories && activeRoute == _routeSomine);

              return InkWell(
                onTap: () {
                  if (!isActive) {
                    Navigator.pushReplacementNamed(context, route);
                  }
                },
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                      color: isActive
                          ? colors.primary
                          : colors.onSurface.withValues(alpha: 0.75),
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// ─── Anasayfa ─────────────────────────────────────────────────────────────────
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _PageShell(
      activeRoute: _routeHome,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 48),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Hero metin ──
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Isıyı Sanata Dönüştürüyoruz.',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Döküm soba, şömine ve mangal ürünlerinde kalite ve estetik bir arada.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF6B7280),
                          height: 1.55,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Kategoriler (yatay kaydırmalı, mobil uyumlu) ──
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _CatTab(
                        icon: Icons.local_fire_department_rounded,
                        label: 'Soba',
                        color: const Color(0xFFFF6B35),
                        route: null,
                      ),
                      const SizedBox(width: 10),
                      _CatTab(
                        icon: Icons.fireplace_rounded,
                        label: 'Şömine',
                        color: const Color(0xFF1E7BFF),
                        route: _routeSomine,
                      ),
                      const SizedBox(width: 10),
                      _CatTab(
                        icon: Icons.outdoor_grill_rounded,
                        label: 'Mangal',
                        color: const Color(0xFF374151),
                        route: null,
                      ),
                      const SizedBox(width: 10),
                      _CatTab(
                        icon: Icons.build_rounded,
                        label: 'Aksesuar',
                        color: const Color(0xFF059669),
                        route: _routeAksesuar,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 44),

                // ── Öne Çıkan Ürünler başlığı ──
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 4,
                      height: 28,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD4AF37), Color(0xFF1E7BFF)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Öne Çıkan Ürünlerimiz',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const Text(
                            'Tüm şömine modellerimizi keşfedin',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => Navigator.pushNamed(context, _routeSomine),
                      icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                      label: const Text('Tümünü Gör'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF1E7BFF),
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ── Ürün grid ──
                LayoutBuilder(
                  builder: (context, constraints) {
                    final w = constraints.maxWidth;
                    final cols = w >= 900 ? 3 : (w >= 560 ? 2 : 1);
                    final gap = 16.0;
                    final cardW = (w - gap * (cols - 1)) / cols;
                    return Wrap(
                      spacing: gap,
                      runSpacing: gap,
                      children: _somineProducts
                          .map((p) => SizedBox(
                                width: cardW,
                                child: _ProductCard(product: p),
                              ))
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Kategori Grid ────────────────────────────────────────────────────────────
class _CategoryGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _CatTab(
          icon: Icons.local_fire_department_rounded,
          label: 'Soba',
          color: const Color(0xFFFF6B35),
          route: null,
        ),
        _CatTab(
          icon: Icons.fireplace_rounded,
          label: 'Şömine',
          color: const Color(0xFF1E7BFF),
          route: _routeSomine,
        ),
        _CatTab(
          icon: Icons.outdoor_grill_rounded,
          label: 'Mangal',
          color: const Color(0xFF374151),
          route: null,
        ),
        _CatTab(
          icon: Icons.build_rounded,
          label: 'Aksesuar',
          color: const Color(0xFF059669),
          route: _routeAksesuar,
        ),
      ],
    );
  }
}

class _CatTab extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final String? route;
  const _CatTab({required this.icon, required this.label, required this.color, required this.route});

  @override
  State<_CatTab> createState() => _CatTabState();
}

class _CatTabState extends State<_CatTab> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.route != null;

    return MouseRegion(
      cursor: isActive ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: isActive ? () => Navigator.pushNamed(context, widget.route!) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          decoration: BoxDecoration(
            color: _hovered && isActive
                ? widget.color
                : widget.color.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: widget.color.withValues(alpha: _hovered && isActive ? 0.0 : 0.35),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 16,
                color: _hovered && isActive ? Colors.white : widget.color,
              ),
              const SizedBox(width: 7),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: _hovered && isActive ? Colors.white : widget.color,
                  letterSpacing: 0.1,
                ),
              ),
              if (!isActive) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: widget.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Yakında',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: widget.color,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Hakkımızda ───────────────────────────────────────────────────────────────
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return _PageShell(
      activeRoute: _routeAbout,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 28, 16, 40),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.outlineVariant),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hakkımızda', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  Text(
                    'Yıllardır soba sektöründe üretim ve satış tecrübesiyle, eviniz ve işletmeniz için güvenilir çözümler sunuyoruz. '
                    'İhtiyaca göre doğru ürün seçimi, teknik destek ve satış sonrası iletişimde hızlı hizmet sağlıyoruz.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── İletişim ─────────────────────────────────────────────────────────────────
class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return _PageShell(
      activeRoute: _routeContact,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 28, 16, 40),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.outlineVariant),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('İletişim', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 16),
                  _ContactRow(icon: Icons.call_outlined,         label: 'Telefon',   value: '+90 506 136 60 56'),
                  const SizedBox(height: 10),
                  _ContactRow(icon: Icons.chat_bubble_outline,   label: 'WhatsApp',  value: '+90 506 136 60 56'),
                  const SizedBox(height: 10),
                  _ContactRow(icon: Icons.location_on_outlined,  label: 'Adres',     value: 'Örnek Mah. Kum Yolu Mevkii, Küme Evler No: 34, Manavgat'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Kategoriler ──────────────────────────────────────────────────────────────
class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _PageShell(
      activeRoute: _routeCategories,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 36, 16, 48),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tüm Kategoriler',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'İhtiyacınıza göre ürün kategorisini seçin.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 28),
                _CategoryGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Şömine Ürün Listesi (Paylaşımlı) ────────────────────────────────────────
const _somineProducts = [
    _ProductData(
      title: 'TDS036H Şömine',
      imagePath: 'assets/somine/somine-01.png',
      highlights: [
        'Seramik Ön Cam',
        'Döküm Demir Gövde',
        'Çift Hava Akış Sistemi',
      ],
      specs: [
        _SpecItem(icon: Icons.straighten,        label: 'En',           value: '42 cm'),
        _SpecItem(icon: Icons.height,            label: 'Yükseklik',    value: '72 cm'),
        _SpecItem(icon: Icons.circle_outlined,   label: 'Baca Çapı',    value: '13 cm'),
        _SpecItem(icon: Icons.local_fire_department, label: 'Ocak Hac.', value: '45 cm³'),
        _SpecItem(icon: Icons.bolt,              label: 'Nominal Güç',  value: '13 kW'),
        _SpecItem(icon: Icons.monitor_weight,    label: 'Ağırlık',      value: '117 kg'),
      ],
    ),
    _ProductData(
      title: 'TDS028B Vesta Fırınlı Şömine',
      imagePath: 'assets/somine/somine-02.png',
      highlights: [
        'Seramik Camlı Fırın',
        'Fırın Bölmeli',
        'Döküm Demir Gövde',
      ],
      specs: [
        _SpecItem(icon: Icons.straighten,            label: 'En',          value: '51 cm'),
        _SpecItem(icon: Icons.swap_horiz,            label: 'Genişlik',    value: '77 cm'),
        _SpecItem(icon: Icons.height,                label: 'Yükseklik',   value: '132 cm'),
        _SpecItem(icon: Icons.monitor_weight,        label: 'Ağırlık',     value: '245 kg'),
        _SpecItem(icon: Icons.kitchen,               label: 'Fırın',       value: 'Seramik Camlı'),
        _SpecItem(icon: Icons.category,              label: 'Malzeme',     value: 'Döküm Demir'),
      ],
    ),
    _ProductData(
      title: 'TDS028 Vesta Şömine',
      imagePath: 'assets/somine/somine-03.png',
      highlights: [
        'Geniş Yanma Haznesi',
        'Döküm Demir Gövde',
        'Ön Seramik Cam',
      ],
      specs: [
        _SpecItem(icon: Icons.straighten,            label: 'En',           value: '52 cm'),
        _SpecItem(icon: Icons.swap_horiz,            label: 'Genişlik',     value: '74 cm'),
        _SpecItem(icon: Icons.height,                label: 'Yükseklik',    value: '77 cm'),
        _SpecItem(icon: Icons.circle_outlined,       label: 'Baca Çapı',    value: '13 cm'),
        _SpecItem(icon: Icons.local_fire_department, label: 'Yanma Hac.',   value: '65 cm³'),
        _SpecItem(icon: Icons.bolt,                  label: 'Nominal Güç',  value: '13 kW'),
      ],
    ),
    _ProductData(
      title: 'TDS003 Mercan Kuzine',
      imagePath: 'assets/somine/somine-04.png',
      highlights: [
        'Ocak Üstü Pişirme',
        'Döküm Demir',
        'Geniş Üst Yüzey',
      ],
      specs: [
        _SpecItem(icon: Icons.straighten,            label: 'En',          value: '57 cm'),
        _SpecItem(icon: Icons.swap_horiz,            label: 'Boy',         value: '84 cm'),
        _SpecItem(icon: Icons.height,                label: 'Yükseklik',   value: '73 cm'),
        _SpecItem(icon: Icons.circle_outlined,       label: 'Baca Çapı',   value: '13 cm'),
        _SpecItem(icon: Icons.bolt,                  label: 'Nominal Güç', value: '13 kW'),
        _SpecItem(icon: Icons.monitor_weight,        label: 'Ağırlık',     value: '110 kg'),
      ],
    ),
    _ProductData(
      title: 'TDS056 Damla Kapalı Şömine',
      imagePath: 'assets/somine/somine-05.png',
      highlights: [
        'Kapalı Ön Kapak',
        'Kompakt Tasarım',
        'Döküm Demir Gövde',
      ],
      specs: [
        _SpecItem(icon: Icons.straighten,            label: 'En',          value: '43 cm'),
        _SpecItem(icon: Icons.swap_horiz,            label: 'Genişlik',    value: '52 cm'),
        _SpecItem(icon: Icons.height,                label: 'Yükseklik',   value: '67 cm'),
        _SpecItem(icon: Icons.circle_outlined,       label: 'Baca Çapı',   value: '13 cm'),
        _SpecItem(icon: Icons.bolt,                  label: 'Nominal Güç', value: '12 kW'),
        _SpecItem(icon: Icons.monitor_weight,        label: 'Ağırlık',     value: '75 kg'),
      ],
    ),
    _ProductData(
      title: 'TDS009 Yakut Fırınlı Şömine',
      imagePath: 'assets/somine/somine-06.png',
      highlights: [
        'Seramik Camlı Fırın',
        'Büyük Hacimli Yapı',
        'Döküm Demir',
      ],
      specs: [
        _SpecItem(icon: Icons.straighten,            label: 'En',          value: '70 cm'),
        _SpecItem(icon: Icons.swap_horiz,            label: 'Genişlik',    value: '60 cm'),
        _SpecItem(icon: Icons.height,                label: 'Yükseklik',   value: '89 cm'),
        _SpecItem(icon: Icons.circle_outlined,       label: 'Baca Çapı',   value: '13 cm'),
        _SpecItem(icon: Icons.bolt,                  label: 'Nominal Güç', value: '13 kW'),
        _SpecItem(icon: Icons.monitor_weight,        label: 'Ağırlık',     value: '167 kg'),
      ],
    ),
    _ProductData(
      title: 'TDS059C Damla Fırınlı Şömine',
      imagePath: 'assets/somine/somine-07.png',
      highlights: [
        'Fırın Bölmeli Damla',
        'Seramik Cam',
        'Döküm Demir',
      ],
      specs: [
        _SpecItem(icon: Icons.straighten,            label: 'En',          value: '43 cm'),
        _SpecItem(icon: Icons.swap_horiz,            label: 'Genişlik',    value: '52 cm'),
        _SpecItem(icon: Icons.height,                label: 'Yükseklik',   value: '110 cm'),
        _SpecItem(icon: Icons.circle_outlined,       label: 'Baca Çapı',   value: '13 cm'),
        _SpecItem(icon: Icons.bolt,                  label: 'Nominal Güç', value: '4,3 kW'),
        _SpecItem(icon: Icons.monitor_weight,        label: 'Ağırlık',     value: '115 kg'),
      ],
    ),
    _ProductData(
      title: 'TDS004 Safir Yan Camlı Şömine',
      imagePath: 'assets/somine/somine-08.png',
      highlights: [
        'Üç Taraflı Seramik Camlı',
        'Çift Hava Akış Sistemi',
        'İçten Küllüklü Model',
        'Çek-Dök Izgara',
      ],
      specs: [
        _SpecItem(icon: Icons.straighten,            label: 'En',          value: '51 cm'),
        _SpecItem(icon: Icons.swap_horiz,            label: 'Genişlik',    value: '50 cm'),
        _SpecItem(icon: Icons.height,                label: 'Yükseklik',   value: '84 cm'),
        _SpecItem(icon: Icons.circle_outlined,       label: 'Baca Çapı',   value: '13 cm'),
        _SpecItem(icon: Icons.bolt,                  label: 'Nominal Güç', value: '13 kW'),
        _SpecItem(icon: Icons.monitor_weight,        label: 'Ağırlık',     value: '115 kg'),
      ],
    ),
    _ProductData(
      title: 'TDS060H Dik Fırınlı Yan Camlı Şömine',
      imagePath: 'assets/somine/somine-09.png',
      highlights: [
        'Üç Hava Akış Sistemi',
        'Yanlar Seramik Camlı',
        'Altan Küllük',
      ],
      specs: [
        _SpecItem(icon: Icons.straighten,            label: 'En',          value: '42 cm'),
        _SpecItem(icon: Icons.swap_horiz,            label: 'Genişlik',    value: '72 cm'),
        _SpecItem(icon: Icons.height,                label: 'Yükseklik',   value: '104 cm'),
        _SpecItem(icon: Icons.circle_outlined,       label: 'Baca Çapı',   value: '13 cm'),
        _SpecItem(icon: Icons.bolt,                  label: 'Nominal Güç', value: '13 kW'),
        _SpecItem(icon: Icons.monitor_weight,        label: 'Ağırlık',     value: '158 kg'),
      ],
    ),
    _ProductData(
      title: 'TDS060G Dik Fırınlı Yan Kapaklı Şömine',
      imagePath: 'assets/somine/somine-11.png',
      highlights: [
        'Üç Hava Akış Sistemi',
        'Yanlar Seramik Camlı',
        'Kapalı Alttan Küllük',
      ],
      specs: [
        _SpecItem(icon: Icons.straighten,            label: 'En',           value: '42 cm'),
        _SpecItem(icon: Icons.swap_horiz,            label: 'Genişlik',     value: '72 cm'),
        _SpecItem(icon: Icons.height,                label: 'Yükseklik',    value: '104 cm'),
        _SpecItem(icon: Icons.circle_outlined,       label: 'Baca Çapı',    value: '13 cm'),
        _SpecItem(icon: Icons.bolt,                  label: 'Nominal Güç',  value: '13 kW'),
        _SpecItem(icon: Icons.monitor_weight,        label: 'Ağırlık',      value: '146 kg'),
      ],
    ),
    _ProductData(
      title: 'TDS029B Alttan Çekmeceli Yatay Kuzine',
      imagePath: 'assets/somine/somine-10.png',
      highlights: [
        'Seramik Camlı Fırın',
        'Camlı Ön Pencere & Fırın',
      ],
      specs: [
        _SpecItem(icon: Icons.straighten,            label: 'En',           value: '52 cm'),
        _SpecItem(icon: Icons.swap_horiz,            label: 'Genişlik',     value: '89 cm'),
        _SpecItem(icon: Icons.height,                label: 'Yükseklik',    value: '75 cm'),
        _SpecItem(icon: Icons.circle_outlined,       label: 'Baca Çapı',    value: '13 cm'),
        _SpecItem(icon: Icons.bolt,                  label: 'Nominal Güç',  value: '12 kW'),
        _SpecItem(icon: Icons.monitor_weight,        label: 'Ağırlık',      value: '152 kg'),
      ],
    ),
    _ProductData(
      title: 'TDS057 İnci Kapalı Şömine',
      imagePath: 'assets/somine/somine-12.png',
      highlights: [
        'Üç Hava Akış Sistemi',
        'Yanlar Seramik Camlı',
        'Kompakt Kapalı Tasarım',
      ],
      specs: [
        _SpecItem(icon: Icons.straighten,            label: 'En',           value: '43 cm'),
        _SpecItem(icon: Icons.swap_horiz,            label: 'Genişlik',     value: '52 cm'),
        _SpecItem(icon: Icons.height,                label: 'Yükseklik',    value: '67 cm'),
        _SpecItem(icon: Icons.circle_outlined,       label: 'Baca Çapı',    value: '13 cm'),
        _SpecItem(icon: Icons.bolt,                  label: 'Nominal Güç',  value: '10 kW'),
        _SpecItem(icon: Icons.monitor_weight,        label: 'Ağırlık',      value: '75 kg'),
      ],
    ),
];

// ─── Aksesuar Ürün Listesi ────────────────────────────────────────────────────
const _aksesuarProducts = [
  _ProductData(
    title: 'TDS046A Alt Tabla – İstanbul Boğazı (Büyük)',
    imagePath: 'assets/aksesuar/aksesuar-01.png',
    specs: [
      _SpecItem(icon: Icons.straighten,         label: 'En',       value: '63 cm'),
      _SpecItem(icon: Icons.swap_horiz,         label: 'Boy',      value: '90 cm'),
      _SpecItem(icon: Icons.height,             label: 'Yükseklik',value: '13 cm'),
      _SpecItem(icon: Icons.category,           label: 'Model',    value: 'İstanbul Boğazı'),
      _SpecItem(icon: Icons.straighten,         label: 'Boyut',    value: 'Büyük'),
      _SpecItem(icon: Icons.inventory_2,        label: 'Malzeme',  value: 'Döküm Demir'),
    ],
  ),
];

// ─── Aksesuar Sayfası ─────────────────────────────────────────────────────────
class AksesuarPage extends StatelessWidget {
  const AksesuarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _PageShell(
      activeRoute: _routeAksesuar,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 36, 16, 48),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, _routeCategories),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chevron_left_rounded, size: 18, color: theme.colorScheme.primary),
                      Text('Kategoriler', style: TextStyle(color: theme.colorScheme.primary, fontSize: 13.5, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text('Aksesuar & Parçalar', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.3)),
                const SizedBox(height: 6),
                Text('Şömine ve soba aksesuarları, döküm parçalar.', style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFF6B7280))),
                const SizedBox(height: 28),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final w = constraints.maxWidth;
                    final cols = w >= 900 ? 3 : (w >= 560 ? 2 : 1);
                    final gap = 16.0;
                    final cardW = (w - gap * (cols - 1)) / cols;
                    return Wrap(
                      spacing: gap,
                      runSpacing: gap,
                      children: _aksesuarProducts
                          .map((p) => SizedBox(width: cardW, child: _ProductCard(product: p)))
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Şömine Sayfası ───────────────────────────────────────────────────────────
class SominePage extends StatelessWidget {
  const SominePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _PageShell(
      activeRoute: _routeSomine,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 36, 16, 48),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Breadcrumb
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, _routeCategories),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chevron_left_rounded,
                          size: 18, color: theme.colorScheme.primary),
                      Text(
                        'Kategoriler',
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Başlık
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1E7BFF), Color(0xFF0A4A9F)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.fireplace_rounded,
                          color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Şömineler',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          '${_somineProducts.length} ürün',
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        Text(
                          'Fiyat için iletişime geçin',
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF1E7BFF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Ürün grid
                LayoutBuilder(
                  builder: (context, constraints) {
                    final w = constraints.maxWidth;
                    final cols = w >= 900 ? 3 : (w >= 560 ? 2 : 1);
                    final gap = 16.0;
                    final cardW = (w - gap * (cols - 1)) / cols;
                    return Wrap(
                      spacing: gap,
                      runSpacing: gap,
                      children: _somineProducts
                          .map((p) => SizedBox(
                                width: cardW,
                                child: _ProductCard(product: p),
                              ))
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SpecItem {
  final IconData icon;
  final String label;
  final String value;
  const _SpecItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class _ProductData {
  final String title;
  final String? imagePath;
  final List<_SpecItem> specs;
  final List<String> highlights;
  const _ProductData({
    required this.title,
    this.imagePath,
    this.specs = const [],
    this.highlights = const [],
  });
}

class _ProductCard extends StatefulWidget {
  final _ProductData product;
  const _ProductCard({required this.product});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    // Gradient border trick: dış Container gradient, iç Container kart rengi
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        transform: Matrix4.translationValues(0, _hovered ? -6 : 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: _hovered
                ? [const Color(0xFFD4AF37), const Color(0xFF1E7BFF), const Color(0xFFD4AF37)]
                : [const Color(0xFF8B7355), const Color(0xFF3D4A6B), const Color(0xFF8B7355)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD4AF37).withValues(alpha: _hovered ? 0.30 : 0.10),
              blurRadius: _hovered ? 28 : 12,
              offset: const Offset(0, 6),
              spreadRadius: _hovered ? 1 : 0,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: _hovered ? 0.28 : 0.14),
              blurRadius: _hovered ? 40 : 16,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(1.8), // bu gradient'in görünen border kalınlığı
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Görsel alanı (1000x800 = 5:4 oran) ──
              AspectRatio(
                aspectRatio: 1000 / 800,
                child: p.imagePath != null
                    ? Image.asset(
                        p.imagePath!,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF0F1623), Color(0xFF1E2A42), Color(0xFF0F1623)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.fireplace_rounded,
                            size: 52,
                            color: const Color(0xFFD4AF37).withValues(alpha: 0.35),
                          ),
                        ),
                      ),
              ),

              // ── Başlık + spec şeridi (koyu arka plan) ──
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF111827), Color(0xFF1C2537)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Başlık
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 11, 14, 2),
                      child: Text(
                        p.title,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Öne çıkan özellik rozetleri
                    if (p.highlights.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 5, 12, 0),
                        child: Wrap(
                          spacing: 5,
                          runSpacing: 4,
                          children: p.highlights
                              .map(
                                (h) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFB45309), Color(0xFFD97706)],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    h,
                                    style: const TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),

                    // Altın ince çizgi ayraç
                    Container(
                      margin: const EdgeInsets.fromLTRB(14, 8, 14, 0),
                      height: 1,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Color(0xFFD4AF37),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    // Spec grid (2 satır x 3 sütun)
                    if (p.specs.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final cols = 3;
                            final rows = (p.specs.length / cols).ceil();
                            return Column(
                              children: [
                                for (int row = 0; row < rows; row++) ...[
                                  if (row > 0)
                                    Container(
                                      height: 1,
                                      margin: const EdgeInsets.symmetric(vertical: 6),
                                      color: const Color(0xFF2D3A5A),
                                    ),
                                  Row(
                                    children: [
                                      for (int col = 0; col < cols; col++)
                                        Builder(builder: (context) {
                                          final idx = row * cols + col;
                                          if (idx >= p.specs.length) {
                                            return const Expanded(child: SizedBox());
                                          }
                                          final s = p.specs[idx];
                                          return Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(s.icon, size: 12, color: const Color(0xFFD4AF37)),
                                                const SizedBox(height: 2),
                                                Text(
                                                  s.value,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.white,
                                                    letterSpacing: 0.1,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(
                                                  s.label,
                                                  style: const TextStyle(
                                                    fontSize: 9,
                                                    color: Color(0xFF94A3B8),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                    ],
                                  ),
                                ],
                              ],
                            );
                          },
                        ),
                      )
                    else
                      const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Footer ───────────────────────────────────────────────────────────────────
class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: const Color(0xFF1A1D23),
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst satır — geniş ekranda 3 sütun, darda dikey
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 520;

                  final firmaBlock = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/logo.png', width: 48, height: 48),
                      const SizedBox(height: 10),
                      Text(
                        'Gürler Soba',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Döküm soba, şömine ve mangal\nürünlerinde kalite ve güven.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.55),
                          fontSize: 12.5,
                          height: 1.65,
                        ),
                      ),
                    ],
                  );

                  final iletisimBlock = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'İletişim',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _FooterLink(icon: Icons.call_outlined,        text: '+90 506 136 60 56'),
                      const SizedBox(height: 8),
                      _FooterLink(icon: Icons.location_on_outlined, text: 'Örnek Mah. Kum Yolu Mevkii\nKüme Evler No: 34, Manavgat'),
                    ],
                  );

                  final linkBlock = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hızlı Bağlantılar',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _FooterNavLink(label: 'Anasayfa',    route: _routeHome),
                      const SizedBox(height: 8),
                      _FooterNavLink(label: 'Kategoriler', route: _routeCategories),
                      const SizedBox(height: 8),
                      _FooterNavLink(label: 'Hakkımızda',  route: _routeAbout),
                      const SizedBox(height: 8),
                      _FooterNavLink(label: 'İletişim',    route: _routeContact),
                    ],
                  );

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: firmaBlock),
                        const SizedBox(width: 28),
                        Expanded(flex: 5, child: iletisimBlock),
                        const SizedBox(width: 28),
                        Expanded(flex: 4, child: linkBlock),
                      ],
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      firmaBlock,
                      const SizedBox(height: 28),
                      iletisimBlock,
                      const SizedBox(height: 28),
                      linkBlock,
                    ],
                  );
                },
              ),

              const SizedBox(height: 32),
              Divider(color: Colors.white.withValues(alpha: 0.12), height: 1),
              const SizedBox(height: 16),

              // Alt çizgi
              Wrap(
                spacing: 16,
                runSpacing: 8,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  Text(
                    '© 2025 Gürler Soba. Tüm hakları saklıdır.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 12,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _FooterSmallLink(label: 'Gizlilik Politikası', route: _routePrivacy),
                      Text(' · ',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.25),
                              fontSize: 12)),
                      _FooterSmallLink(label: 'Çerez Politikası', route: _routeCookie),
                      Text(' · ',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.25),
                              fontSize: 12)),
                      _FooterSmallLink(label: 'KVKK', route: _routeKvkk),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final IconData icon;
  final String text;
  const _FooterLink({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.5)),
        const SizedBox(width: 7),
        Text(text,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.55),
              fontSize: 13,
            )),
      ],
    );
  }
}

class _FooterNavLink extends StatefulWidget {
  final String label;
  final String route;
  const _FooterNavLink({required this.label, required this.route});

  @override
  State<_FooterNavLink> createState() => _FooterNavLinkState();
}

class _FooterNavLinkState extends State<_FooterNavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => Navigator.pushReplacementNamed(context, widget.route),
        child: Text(
          widget.label,
          style: TextStyle(
            color: _hovered
                ? Colors.white.withValues(alpha: 0.9)
                : Colors.white.withValues(alpha: 0.5),
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _FooterSmallLink extends StatefulWidget {
  final String label;
  final String route;
  const _FooterSmallLink({required this.label, required this.route});

  @override
  State<_FooterSmallLink> createState() => _FooterSmallLinkState();
}

class _FooterSmallLinkState extends State<_FooterSmallLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, widget.route),
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 12,
            color: _hovered
                ? Colors.white.withValues(alpha: 0.7)
                : Colors.white.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}

// ─── Yardımcı widget'lar ──────────────────────────────────────────────────────
class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ContactRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: '$label: ',
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Ortak policy sayfası iskeleti ───────────────────────────────────────────
class _PolicyPage extends StatelessWidget {
  final String title;
  final List<_PolicySection> sections;

  const _PolicyPage({required this.title, required this.sections});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _PageShell(
      activeRoute: '',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 28, 16, 48),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Geri butonu
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chevron_left_rounded,
                            size: 18, color: theme.colorScheme.primary),
                        Text(
                          'Geri',
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Son güncelleme: Şubat 2026 • Gürler Soba',
                  style: const TextStyle(fontSize: 12.5, color: Color(0xFF9CA3AF)),
                ),
                const SizedBox(height: 28),

                ...sections.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.heading,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        s.body,
                        style: const TextStyle(
                          fontSize: 13.5,
                          color: Color(0xFF4B5563),
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PolicySection {
  final String heading;
  final String body;
  const _PolicySection(this.heading, this.body);
}

// ─── Gizlilik Politikası ──────────────────────────────────────────────────────
class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) => _PolicyPage(
    title: 'Gizlilik Politikası',
    sections: const [
      _PolicySection(
        '1. Amaç ve Kapsam',
        'Bu Gizlilik Politikası; Gürler Soba ("Şirket") tarafından işletilen web sitesi aracılığıyla toplanan kişisel verilerin nasıl işlendiğini, korunduğunu ve kullanıldığını açıklamaktadır. Sitemizi ziyaret ederek bu politikayı kabul etmiş sayılırsınız.',
      ),
      _PolicySection(
        '2. Toplanan Veriler',
        'Sitemizi ziyaret ettiğinizde IP adresiniz, tarayıcı türü, ziyaret saati ve gezdiğiniz sayfalar gibi teknik veriler otomatik olarak toplanabilir. İletişim formu veya WhatsApp/telefon kanalları üzerinden bizimle iletişime geçmeniz durumunda ad-soyad, e-posta ve telefon numarası gibi bilgileriniz tarafımızca alınabilir.',
      ),
      _PolicySection(
        '3. Verilerin Kullanım Amacı',
        'Toplanan kişisel veriler; müşteri taleplerini yanıtlamak, ürün ve hizmetler hakkında bilgi vermek, site güvenliğini sağlamak ve yasal yükümlülükleri yerine getirmek amacıyla kullanılmaktadır. Verileriniz rızanız olmaksızın üçüncü taraflarla paylaşılmaz.',
      ),
      _PolicySection(
        '4. Verilerin Saklanması',
        'Kişisel verileriniz, işleme amacının gerektirdiği süre boyunca ve yasal saklama yükümlülükleri çerçevesinde güvenli ortamlarda saklanır. Amacın ortadan kalkması veya yasal sürenin dolması halinde veriler silinir, yok edilir ya da anonim hale getirilir.',
      ),
      _PolicySection(
        '5. Haklarınız',
        'KVKK\'nın 11. maddesi kapsamında kişisel verilerinize ilişkin şu haklara sahipsiniz: işleme amacını öğrenme, verilerin aktarıldığı kişileri öğrenme, eksik veya yanlış verilerin düzeltilmesini isteme, silinmesini veya yok edilmesini talep etme ve işlemeye itiraz etme. Bu haklarınızı kullanmak için info@gurlersoba.com.tr adresine yazabilirsiniz.',
      ),
      _PolicySection(
        '6. İletişim',
        'Gizlilik uygulamalarımıza ilişkin sorularınız için:\nGürler Soba\nÖrnek Mah. Kum Yolu Mevkii, Küme Evler No: 34, Manavgat\nTelefon: +90 506 136 60 56',
      ),
    ],
  );
}

// ─── Çerez Politikası ─────────────────────────────────────────────────────────
class CookiePage extends StatelessWidget {
  const CookiePage({super.key});

  @override
  Widget build(BuildContext context) => _PolicyPage(
    title: 'Çerez Politikası',
    sections: const [
      _PolicySection(
        '1. Çerez Nedir?',
        'Çerezler (cookie), web sitelerinin tarayıcınıza yerleştirdiği küçük metin dosyalarıdır. Bu dosyalar, siteyi daha iyi kullanmanızı sağlamak, tercihlerinizi hatırlamak ve site performansını ölçmek amacıyla kullanılır.',
      ),
      _PolicySection(
        '2. Kullandığımız Çerez Türleri',
        'Zorunlu Çerezler: Sitenin temel işlevselliği için gereklidir; bu çerezler olmadan site düzgün çalışmaz.\n\nAnalitik Çerezler: Ziyaretçi sayısı ve gezinme alışkanlıkları gibi istatistiksel verileri toplar. Bu veriler anonim olup bireysel kullanıcıları tanımlamaz.\n\nFonksiyonel Çerezler: Dil ve bölge gibi tercihlerinizi hatırlar.',
      ),
      _PolicySection(
        '3. Çerez Yönetimi',
        'Tarayıcınızın ayarlar menüsünden çerezleri dilediğiniz zaman silebilir veya engelleyebilirsiniz. Çerezleri devre dışı bırakmanız durumunda sitenin bazı özellikleri düzgün çalışmayabilir.\n\nChrome: Ayarlar > Gizlilik ve Güvenlik > Çerezler\nSafari: Ayarlar > Safari > Çerezler\nFirefox: Ayarlar > Gizlilik ve Güvenlik',
      ),
      _PolicySection(
        '4. Üçüncü Taraf Çerezleri',
        'Sitemizde Google Analytics gibi üçüncü taraf analiz araçları kullanılabilir. Bu araçlar kendi çerez politikalarına tabidir. Üçüncü taraf çerezleri hakkında daha fazla bilgi için ilgili hizmet sağlayıcının gizlilik politikasını inceleyebilirsiniz.',
      ),
      _PolicySection(
        '5. İletişim',
        'Çerez uygulamalarımız hakkında sorularınız için +90 506 136 60 56 numaralı telefondan veya Örnek Mah. Kum Yolu Mevkii, Küme Evler No: 34, Manavgat adresinden bize ulaşabilirsiniz.',
      ),
    ],
  );
}

// ─── KVKK Aydınlatma Metni ────────────────────────────────────────────────────
class KvkkPage extends StatelessWidget {
  const KvkkPage({super.key});

  @override
  Widget build(BuildContext context) => _PolicyPage(
    title: 'KVKK Aydınlatma Metni',
    sections: const [
      _PolicySection(
        'Veri Sorumlusu',
        '6698 sayılı Kişisel Verilerin Korunması Kanunu ("KVKK") uyarınca kişisel verileriniz; veri sorumlusu sıfatıyla Gürler Soba (Örnek Mah. Kum Yolu Mevkii, Küme Evler No: 34, Manavgat) tarafından aşağıda açıklanan kapsamda işlenmektedir.',
      ),
      _PolicySection(
        'İşlenen Kişisel Veriler',
        'Kimlik Verileri: Ad, soyad\nİletişim Verileri: Telefon numarası, e-posta adresi\nİşlem Güvenliği Verileri: IP adresi, çerez verileri, log kayıtları\nTalep/Şikâyet Yönetimi Verileri: Tarafımıza iletilen mesaj ve talepler',
      ),
      _PolicySection(
        'Kişisel Verilerin İşlenme Amaçları',
        '• Müşteri talep ve şikâyetlerinin yönetilmesi\n• Ürün ve hizmetler hakkında bilgilendirme yapılması\n• Yasal yükümlülüklerin yerine getirilmesi\n• İş sürekliliğinin sağlanması\n• Yetkili kurum ve kuruluşlara bilgi verilmesi',
      ),
      _PolicySection(
        'Kişisel Verilerin Aktarılması',
        'Kişisel verileriniz; hukuki zorunluluklar kapsamında yetkili kamu kurum ve kuruluşlarıyla paylaşılabilir. Bunun dışında açık rızanız olmaksızın üçüncü taraflarla paylaşılmaz.',
      ),
      _PolicySection(
        'Kişisel Veri Toplamanın Yöntemi ve Hukuki Sebebi',
        'Kişisel verileriniz; web sitesi, telefon ve WhatsApp kanalları aracılığıyla sözlü, yazılı veya elektronik ortamda toplanmaktadır. İşlemenin hukuki sebepleri; sözleşmenin ifası, meşru menfaat ve yasal yükümlülüklerdir.',
      ),
      _PolicySection(
        'KVKK Madde 11 Kapsamındaki Haklarınız',
        'KVKK\'nın 11. maddesi uyarınca;\n• Kişisel verilerinizin işlenip işlenmediğini öğrenme\n• İşlenmişse buna ilişkin bilgi talep etme\n• İşlenme amacını ve amacına uygun kullanılıp kullanılmadığını öğrenme\n• Yurt içinde/dışında aktarıldığı üçüncü kişileri öğrenme\n• Eksik veya yanlış işlenmiş verilerin düzeltilmesini isteme\n• KVKK\'nın 7. maddesinde öngörülen şartlar çerçevesinde silinmesini/yok edilmesini isteme\n• Düzeltme ve silme işlemlerinin aktarılan üçüncü kişilere bildirilmesini isteme\n• İşlenen verilerin münhasıran otomatik sistemler vasıtasıyla analiz edilmesi durumunda aleyhinize çıkan sonuca itiraz etme\n• Kanuna aykırı işleme nedeniyle zarara uğramanız hâlinde zararın giderilmesini talep etme haklarına sahipsiniz.\n\nBaşvurularınızı yazılı olarak Örnek Mah. Kum Yolu Mevkii, Küme Evler No: 34, Manavgat adresine veya +90 506 136 60 56 numaralı telefona iletebilirsiniz.',
      ),
    ],
  );
}
