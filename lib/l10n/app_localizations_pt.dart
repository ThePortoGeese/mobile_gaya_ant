// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get language => 'Português';

  @override
  String get appLanguage => 'Linguagem da Aplicação';

  @override
  String get appBarText => 'Controlo do Robô Formiga';

  @override
  String get connectionStatus => 'Estado de Conexão';

  @override
  String get disconnectedStatus => 'DESCONECTADO';

  @override
  String get connect => 'Conectar';

  @override
  String get disconnect => 'Desconectar';

  @override
  String get connectedToDevice => 'Conectado ao dispositivo ';

  @override
  String get bluetoothError => 'Erro Bluetooth';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get bondingError => 'Erro de Emparelhamento';

  @override
  String get bondingErrorMessage => 'Houve um erro a emparelhar o dispositivo';

  @override
  String get bluetoothOffMessage =>
      'Parece que o seu bluetooth está desligado. Pretende ligá-lo?';

  @override
  String get bluetoothNotAvailableMessage =>
      'O seu dispositivo não suporta tecnologia bluetooth. Iremos fechar a aplicação agora.';

  @override
  String get connectionError => 'Erro de Conexão';

  @override
  String get connectionErrorMessage =>
      'Houve um erro a conectar com o dispositivo';

  @override
  String get searchingDevices => 'A procurar dispositivos...';

  @override
  String get connectingToDevice => 'A conectar ao dispositivo ';

  @override
  String get grab => 'Agarrar';

  @override
  String get attack => 'Atacar';

  @override
  String get dance => 'Dançar';

  @override
  String get velocity => 'Velocidade';

  @override
  String get disconnectedFromDevice => 'Desconectado do dispositivo';

  @override
  String get permissionsError => 'Erro de Permissão';

  @override
  String get permissionsErrorMessage =>
      'Têm de aceitar permissões para a aplicação funcionar. Vamos fechar a aplicação agora.';

  @override
  String get release => 'Largar';

  @override
  String get stop => 'Parar';

  @override
  String get passwordNecessary => 'Palavra-chave Necessária';

  @override
  String get passwordNecessaryMessage =>
      'Introduza a palavra-chave do dispositivo:';
}
