import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_zh.dart';

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
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('zh'),
    Locale('zh', 'CN'),
    Locale('zh', 'HK'),
    Locale('zh', 'TW')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Rubik Solver'**
  String get appTitle;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// No description provided for @scrambled.
  ///
  /// In en, this message translates to:
  /// **'Scrambled'**
  String get scrambled;

  /// No description provided for @solving.
  ///
  /// In en, this message translates to:
  /// **'Solving...'**
  String get solving;

  /// Number of solution moves found
  ///
  /// In en, this message translates to:
  /// **'{count} moves found'**
  String movesFound(int count);

  /// No description provided for @alreadySolved.
  ///
  /// In en, this message translates to:
  /// **'Already solved or no solution found'**
  String get alreadySolved;

  /// Error message
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String error(String message);

  /// No description provided for @solutionComplete.
  ///
  /// In en, this message translates to:
  /// **'Solution complete'**
  String get solutionComplete;

  /// No description provided for @autoApplyStopped.
  ///
  /// In en, this message translates to:
  /// **'Auto apply stopped'**
  String get autoApplyStopped;

  /// Step progress indicator
  ///
  /// In en, this message translates to:
  /// **'Step {current} / {total}'**
  String stepProgress(int current, int total);

  /// Auto apply progress
  ///
  /// In en, this message translates to:
  /// **'Auto: {current} / {total}'**
  String autoProgress(int current, int total);

  /// No description provided for @customCubeLoaded.
  ///
  /// In en, this message translates to:
  /// **'Custom cube loaded'**
  String get customCubeLoaded;

  /// No description provided for @scramble.
  ///
  /// In en, this message translates to:
  /// **'Scramble'**
  String get scramble;

  /// No description provided for @solve.
  ///
  /// In en, this message translates to:
  /// **'Solve'**
  String get solve;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @saveAndValidate.
  ///
  /// In en, this message translates to:
  /// **'Save & Validate'**
  String get saveAndValidate;

  /// No description provided for @manualControls.
  ///
  /// In en, this message translates to:
  /// **'Manual Controls'**
  String get manualControls;

  /// No description provided for @solution.
  ///
  /// In en, this message translates to:
  /// **'Solution'**
  String get solution;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'◀ Undo'**
  String get undo;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply ▶'**
  String get apply;

  /// No description provided for @auto.
  ///
  /// In en, this message translates to:
  /// **'▶ Auto'**
  String get auto;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'⏸ Stop'**
  String get stop;

  /// No description provided for @manualCubeInput.
  ///
  /// In en, this message translates to:
  /// **'Manual Cube Input'**
  String get manualCubeInput;

  /// No description provided for @tapToFocus.
  ///
  /// In en, this message translates to:
  /// **'Tap stickers to focus, select color to change'**
  String get tapToFocus;

  /// No description provided for @selectColor.
  ///
  /// In en, this message translates to:
  /// **'Select Color'**
  String get selectColor;

  /// No description provided for @invalidCube.
  ///
  /// In en, this message translates to:
  /// **'Invalid cube configuration. Please check colors.'**
  String get invalidCube;

  /// No description provided for @display2D.
  ///
  /// In en, this message translates to:
  /// **'2D'**
  String get display2D;

  /// No description provided for @display3D.
  ///
  /// In en, this message translates to:
  /// **'3D'**
  String get display3D;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'ja',
        'ko',
        'pt',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'CN':
            return AppLocalizationsZhCn();
          case 'HK':
            return AppLocalizationsZhHk();
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
