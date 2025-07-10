// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'English';

  @override
  String get appLanguage => 'App Language';

  @override
  String get appBarText => 'Robot Ant Control';

  @override
  String get connectionStatus => 'Connection Status';

  @override
  String get disconnectedStatus => 'DISCONNECTED';

  @override
  String get connect => 'Connect';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get connectedToDevice => 'Connected to Device ';

  @override
  String get bluetoothError => 'Bluetooth Error';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get bondingError => 'Bonding Error';

  @override
  String get bondingErrorMessage =>
      'An error occurred while bonding to the device.';

  @override
  String get bluetoothOffMessage =>
      'Seems your bluetooth is turned off. Do you wish to turn it on?';

  @override
  String get bluetoothNotAvailableMessage =>
      'Your device doesn\'t support bluetooth technology. We will close the application now.';

  @override
  String get connectionError => 'Connection Error';

  @override
  String get connectionErrorMessage =>
      'An error occurred while connecting to the device.';

  @override
  String get searchingDevices => 'Searching for devices...';

  @override
  String get connectingToDevice => 'Connecting to device ';

  @override
  String get grab => 'Grab';

  @override
  String get attack => 'Attack';

  @override
  String get dance => 'Dance';

  @override
  String get velocity => 'Velocity';

  @override
  String get disconnectedFromDevice => 'Disconnected from device';

  @override
  String get permissionsError => 'Permission Error';

  @override
  String get permissionsErrorMessage =>
      'You must accept permissions for the app to run. We will close the app now';

  @override
  String get release => 'Release';

  @override
  String get stop => 'Stop';

  @override
  String get passwordNecessary => 'Password Necessary';

  @override
  String get passwordNecessaryMessage => 'Insert the device\'s password:';
}
