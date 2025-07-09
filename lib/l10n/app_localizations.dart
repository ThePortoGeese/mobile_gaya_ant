import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

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
    Locale('en'),
    Locale('pt'),
  ];

  /// Language Selection
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @appBarText.
  ///
  /// In en, this message translates to:
  /// **'Robot Ant Control'**
  String get appBarText;

  /// No description provided for @connectionStatus.
  ///
  /// In en, this message translates to:
  /// **'Connection Status'**
  String get connectionStatus;

  /// No description provided for @disconnectedStatus.
  ///
  /// In en, this message translates to:
  /// **'DISCONNECTED'**
  String get disconnectedStatus;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Desconnect'**
  String get disconnect;

  /// No description provided for @connectedToDevice.
  ///
  /// In en, this message translates to:
  /// **'Connected to Device '**
  String get connectedToDevice;

  /// No description provided for @bluetoothError.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth Error'**
  String get bluetoothError;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @bondingError.
  ///
  /// In en, this message translates to:
  /// **'Bonding Error'**
  String get bondingError;

  /// No description provided for @bondingErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while bonding to the device.'**
  String get bondingErrorMessage;

  /// No description provided for @bluetoothOffMessage.
  ///
  /// In en, this message translates to:
  /// **'Seems your bluetooth is turned off. Do you wish to turn it on?'**
  String get bluetoothOffMessage;

  /// No description provided for @bluetoothNotAvailableMessage.
  ///
  /// In en, this message translates to:
  /// **'Your device doesn\'t support bluetooth technology. We will close the application now.'**
  String get bluetoothNotAvailableMessage;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get connectionError;

  /// No description provided for @connectionErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while connecting to the device.'**
  String get connectionErrorMessage;

  /// No description provided for @searchingDevices.
  ///
  /// In en, this message translates to:
  /// **'Searching for devices...'**
  String get searchingDevices;

  /// No description provided for @connectingToDevice.
  ///
  /// In en, this message translates to:
  /// **'Connecting to device '**
  String get connectingToDevice;

  /// No description provided for @grab.
  ///
  /// In en, this message translates to:
  /// **'Grab'**
  String get grab;

  /// No description provided for @attack.
  ///
  /// In en, this message translates to:
  /// **'Attack'**
  String get attack;

  /// No description provided for @dance.
  ///
  /// In en, this message translates to:
  /// **'Dance'**
  String get dance;

  /// No description provided for @velocity.
  ///
  /// In en, this message translates to:
  /// **'Velocity'**
  String get velocity;

  /// No description provided for @disconnectedFromDevice.
  ///
  /// In en, this message translates to:
  /// **'Disconnected from device'**
  String get disconnectedFromDevice;

  /// No description provided for @permissionsError.
  ///
  /// In en, this message translates to:
  /// **'Permission Error'**
  String get permissionsError;

  /// No description provided for @permissionsErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'You must accept permissions for the app to run. We will close the app now'**
  String get permissionsErrorMessage;

  /// No description provided for @release.
  ///
  /// In en, this message translates to:
  /// **'Release'**
  String get release;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;
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
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
