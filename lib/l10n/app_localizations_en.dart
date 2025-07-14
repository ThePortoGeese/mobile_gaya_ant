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
  String get velocity => 'Speed';

  @override
  String get disconnectedFromDevice => 'Disconnected from device';

  @override
  String get permissionsError => 'Permission Error';

  @override
  String get permissionsErrorMessage =>
      'You must accept permissions for the app to run.';

  @override
  String get release => 'Release';

  @override
  String get stop => 'Stop';

  @override
  String get passwordNecessary => 'Password Necessary';

  @override
  String get passwordNecessaryMessage => 'Insert the device\'s password:';

  @override
  String get errorSearching => 'An Error Occured while Searching Devices';

  @override
  String get errorSearchingMessage => 'Try restarting the application.';

  @override
  String get welcome => 'Welcome!';

  @override
  String get welcomeMessage1 =>
      'This application serves as controls for the robot ant project here at ISPGAYA. You can connect the robot via bluetooth by pressing the \"Connect\" button';

  @override
  String get welcomeMessage2 =>
      'Select the robot and introduce the given password. Keep in mind that this app will only connect to the ant and trying to do anything else might cause unexpected behaviour.';

  @override
  String get welcomeMessage3 =>
      'When connected, the controls for the ant will appear, allowing you direct control over its movements.';

  @override
  String get welcomeMessage4 =>
      'This app requires you to grant it bluetooth permissions.';

  @override
  String get credits => 'Made by David João at ISPGAYA';
}
