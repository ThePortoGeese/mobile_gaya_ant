// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get language => 'Français';

  @override
  String get appLanguage => 'Langue de l\'application';

  @override
  String get appBarText => 'Contrôle du Robot Fourmi';

  @override
  String get connectionStatus => 'État de la Connexion';

  @override
  String get disconnectedStatus => 'DÉCONNECTÉ';

  @override
  String get connect => 'Connecter';

  @override
  String get disconnect => 'Déconnecter';

  @override
  String get connectedToDevice => 'Connecté à l\'appareil ';

  @override
  String get bluetoothError => 'Bluetooth Erreur';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get bondingError => 'Erreur d\'appairage';

  @override
  String get bondingErrorMessage =>
      'Une erreur s\'est produite lors de l\'appairage de l\'appareil';

  @override
  String get bluetoothOffMessage =>
      'Il semble que votre Bluetooth soit désactivé. Voulez-vous l\'activer?';

  @override
  String get bluetoothNotAvailableMessage =>
      'Votre appareil ne prend pas en charge la technologie Bluetooth. Nous allons fermer l\'application.';

  @override
  String get connectionError => 'Erreur d\'connexion';

  @override
  String get connectionErrorMessage =>
      'Une erreur s\'est produite lors de la connexion à l\'appareil';

  @override
  String get searchingDevices => 'Recherche d\'appareils...';

  @override
  String get connectingToDevice => 'Connexion à l\'appareil';

  @override
  String get grab => 'Saisir';

  @override
  String get attack => 'Attaque';

  @override
  String get dance => 'Danser';

  @override
  String get velocity => 'Velocité';

  @override
  String get disconnectedFromDevice => 'Déconnecté de l\'appareil';

  @override
  String get permissionsError => 'Erreur d\'autorisation';

  @override
  String get permissionsErrorMessage =>
      'Vous devez accepter les autorisations pour que l\'application fonctionne. ';

  @override
  String get release => 'Baisse';

  @override
  String get stop => 'Pour arrêter';

  @override
  String get passwordNecessary => 'Mot de Passe Requis';

  @override
  String get passwordNecessaryMessage =>
      'Entrez le mot de passe de l\'appareil:';

  @override
  String get errorSearching => 'Erreur Bluetooth';

  @override
  String get errorSearchingMessage =>
      ' Une erreur s\'est produite lors de la recherche des appareils. Essayez de redémarrer l\'application.';

  @override
  String get welcome => 'Bienvenue!';

  @override
  String get welcomeMessage1 =>
      'Cette application contrôle la fourmi robot d\'ISPGAYA. Connectez-la via Bluetooth en appuyant sur le bouton « Connecter ».';

  @override
  String get welcomeMessage2 =>
      'Sélectionnez le robot et saisissez le mot de passe fourni. Cette application ne peut se connecter qu\'au robot ; toute tentative de connexion à un autre appareil peut entraîner un comportement inattendu.';

  @override
  String get welcomeMessage3 =>
      'Une fois connecté, les commandes du robot apparaîtront, vous permettant de contrôler directement ses mouvements.';

  @override
  String get welcomeMessage4 =>
      'Cette application nécessite des autorisations Bluetooth pour fonctionner.';

  @override
  String get credits => 'Réalisé par David João à ISPGAYA';

  @override
  String get reload => 'Recharger';
}
