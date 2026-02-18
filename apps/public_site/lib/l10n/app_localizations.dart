import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('tr', 'TR'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In tr, this message translates to:
  /// **'Gürler Soba'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get navHome;

  /// No description provided for @navContact.
  ///
  /// In tr, this message translates to:
  /// **'İletişim'**
  String get navContact;

  /// No description provided for @navCategories.
  ///
  /// In tr, this message translates to:
  /// **'Kategoriler'**
  String get navCategories;

  /// No description provided for @privacyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik Politikası'**
  String get privacyTitle;

  /// No description provided for @cookieTitle.
  ///
  /// In tr, this message translates to:
  /// **'Çerez Politikası'**
  String get cookieTitle;

  /// No description provided for @heroTitle.
  ///
  /// In tr, this message translates to:
  /// **'Döküm Soba & Şömine'**
  String get heroTitle;

  /// No description provided for @heroSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Minimal tasarım, güçlü ısıtma. Ürünleri inceleyin ve WhatsApp’tan teklif isteyin.'**
  String get heroSubtitle;

  /// No description provided for @sectionCategories.
  ///
  /// In tr, this message translates to:
  /// **'Kategoriler'**
  String get sectionCategories;

  /// No description provided for @sectionFeatured.
  ///
  /// In tr, this message translates to:
  /// **'Öne Çıkan Ürünler'**
  String get sectionFeatured;

  /// No description provided for @sectionFreeSurvey.
  ///
  /// In tr, this message translates to:
  /// **'Ücretsiz keşif / teklif'**
  String get sectionFreeSurvey;

  /// No description provided for @ctaDetails.
  ///
  /// In tr, this message translates to:
  /// **'Detay'**
  String get ctaDetails;

  /// No description provided for @ctaWhatsApp.
  ///
  /// In tr, this message translates to:
  /// **'WhatsApp’tan Sipariş/ Teklif İste'**
  String get ctaWhatsApp;

  /// No description provided for @ctaCall.
  ///
  /// In tr, this message translates to:
  /// **'Ara'**
  String get ctaCall;

  /// No description provided for @ctaGetQuote.
  ///
  /// In tr, this message translates to:
  /// **'Teklif Al'**
  String get ctaGetQuote;

  /// No description provided for @formName.
  ///
  /// In tr, this message translates to:
  /// **'Ad Soyad'**
  String get formName;

  /// No description provided for @formPhone.
  ///
  /// In tr, this message translates to:
  /// **'Telefon'**
  String get formPhone;

  /// No description provided for @formEmail.
  ///
  /// In tr, this message translates to:
  /// **'E-posta (opsiyonel)'**
  String get formEmail;

  /// No description provided for @formCity.
  ///
  /// In tr, this message translates to:
  /// **'Şehir/İlçe (opsiyonel)'**
  String get formCity;

  /// No description provided for @formMessage.
  ///
  /// In tr, this message translates to:
  /// **'Mesaj (opsiyonel)'**
  String get formMessage;

  /// No description provided for @formSubmit.
  ///
  /// In tr, this message translates to:
  /// **'Gönder'**
  String get formSubmit;

  /// No description provided for @validationRequired.
  ///
  /// In tr, this message translates to:
  /// **'Bu alan zorunludur.'**
  String get validationRequired;

  /// No description provided for @validationPhone.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen geçerli bir telefon numarası girin.'**
  String get validationPhone;

  /// No description provided for @emptyProducts.
  ///
  /// In tr, this message translates to:
  /// **'Bu kategoride henüz yayınlanmış ürün yok.'**
  String get emptyProducts;

  /// No description provided for @notFound.
  ///
  /// In tr, this message translates to:
  /// **'İçerik bulunamadı.'**
  String get notFound;

  /// No description provided for @loading.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor…'**
  String get loading;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'tr':
      {
        switch (locale.countryCode) {
          case 'TR':
            return AppLocalizationsTrTr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
