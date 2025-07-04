import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/bluetoothmenu.dart';
import '../dialogs/circularloading.dart';
import '../dialogs/normalalert.dart';
import '../smallwidgets/bottomsheet.dart';
import '../widgets/antmovingcontrols.dart';
import '../../data/values.dart';

enum LanguageItem { pt, eng }

class MenuPage extends StatefulWidget {
  const MenuPage({super.key, required this.title});
  final String title;

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {


  //THIS JUST HOLDS THE SELECTED ITEM OF THE LANGUAGE POP UP MENU BUTTON
  LanguageItem? selectedItem = LanguageItem.pt;
  //THIS IS THE ICON OF THE LANGUAGE BUTTON
  Widget? currentIcon = Image.asset('assets/ptlang.png', width: 24,height: 24,fit: BoxFit.contain);
  //THIS MAP HOLDS THE MAC ADDRESS OF THE DEVICE AS ITS KEY AND THE NAME AS ITS VALUE
  Map<String, String> deviceInfo = {};



  //THESE ARE VARIABLES WITH THE VALUES FOR BUTTONS AND LABELS
  String bluetoothStatus = "DESCONECTADO";
  String bluetoothButtonText = "Conectar";

  @override
  void initState(){
    super.initState();
    //WHEN THE USER OPENS THE APP, I TRY TO INITIALIZE ITS BLUETOOTH FUNCTIONS
  }

   Future<void> initializeBluetooth() async{
    //TODO: SET BUTTON OFF
    setState(() {
      bluetoothButtonEnabled = false;
    });

    FlutterBluetoothSerial.instance.onStateChanged().listen((newState){
        handleBluetoothStateChange(newState);
      }
    );
    
    //I need to check if the user can even access bluetooth
    await checkBluetoothAvailability();

    if(!(await Permission.bluetoothConnect.isGranted)){
      final status = await Permission.bluetoothConnect.request();

      if(status == PermissionStatus.denied){
        // TODO: SHOW ERROR
 
      }
    }
    //I try to see what state is bluetooth on

    final initialBTState = await FlutterBluetoothSerial.instance.state;

    //Handles the bt state of the application
    handleBluetoothStateChange(initialBTState);
  }

  void handleBluetoothStateChange(BluetoothState newState) async{
    //Immediately disables the bluetooth button when changes happen
    //Its a precautionary measure so the discovery proccess of new devices doesnt get bugged
    setState(() {
      bluetoothButtonEnabled = false;
    });
    if(newState == BluetoothState.STATE_OFF){
      await showDialog<void>(context: context, barrierDismissible: false, builder: (context) => AlertDialog(
        title: Text("ERRO BLUETOOTH",  style: alertTitleStyle),
        content: Text("Parece que o seu bluetooth está desligado, pretende ligá-lo?"),
        actions: [
          TextButton(onPressed: (){
            requestEnableBluetooth();
            Navigator.of(context).pop();
          }, child: Text("Sim")),
          TextButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: Text("Não")),
        ],
      ),);
    } else if (newState == BluetoothState.STATE_ON){
      //If the bt is on, we caan finally enable the button
      setState(() {
        bluetoothButtonEnabled = true;
      });
    }
  }

  void requestEnableBluetooth() async{
    //Just requests the bt permission from the user
    await FlutterBluetoothSerial.instance.requestEnable();
  }

  Future<void> checkBluetoothAvailability() async {
    //This functions checks if the device even has bt, if it doesnt, it closes
    final bool? isAvailable = await FlutterBluetoothSerial.instance.isAvailable;

    if ( isAvailable == false){
      if(!mounted) return;
      await showDialog<void>(context: context, barrierDismissible:false, builder:(context) => Normalalert(
        bodyText: "O seu dispositivo não suporta a tecnologia bluetooth.\nIremos fechar a aplicação agora.", 
        titleText: "ERRO BLUETOOTH", 
        titleStyle: alertTitleStyle)
      );
      exit(0);
    }

    return;
  }
  
  //THIS VARIABLE JUST CONTROLS IF THE DEVICE LIST IS VISIBLE OR NOT
  bool availableDevicesListIsVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFB923C),

        title: Text(widget.title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
        actions: <Widget>[
          PopupMenuButton<LanguageItem>(
            icon: currentIcon,
            initialValue: selectedItem,
            tooltip: "Linguagem Da Aplicação",
            onSelected: (LanguageItem value) {
              setState(() {
                selectedItem = value;
                if(value == LanguageItem.eng){
                  currentIcon = Image.asset('assets/englang.png', width: 24,height: 24,fit: BoxFit.contain);
                } else {
                  currentIcon = Image.asset('assets/ptlang.png', width: 24,height: 24,fit: BoxFit.contain);
                }
              });
            },  
            itemBuilder: (BuildContext context) => <PopupMenuEntry<LanguageItem>>[
              PopupMenuItem<LanguageItem>(
                value: LanguageItem.pt,
                child: Row(
                  children: <Widget>[
                    Image.asset('assets/ptlang.png', width: 24,height: 24,fit: BoxFit.contain),
                    const SizedBox(width: 8),
                    Text("PT")
                    
                  ]
                ),),
              PopupMenuItem<LanguageItem>(value: LanguageItem.eng, 
                child: Row(
                  children: <Widget>[
                    Image.asset('assets/englang.png', width: 24,height: 24,fit: BoxFit.contain),
                    const SizedBox(width: 8),
                    Text("ENG") 
                  ]
                )
              )
            ],      
            )
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: bluetoothConnection,
        builder: (context, value, child) {
          if(!(value?.isConnected??false)){
              deviceConnected = false;
              bluetoothButtonText = "Conectar";
              currentMacAdress = "";
              bluetoothConnection.value = null;
              bluetoothStatus = "DESCONECTADO";
          } 

          return Expanded(
            child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 20),
                child: Column(
                  children: <Widget>[
                    BluetoothMenu(
                      bluetoothButtonEnabled: bluetoothButtonEnabled,
                      status: bluetoothStatus,
                      buttonText: bluetoothButtonText,
                      devices: deviceInfo,
                      isListVisible: availableDevicesListIsVisible,
                      onConnectPressed: handleConnectButtonPressed,
                      onDeviceTap: handleDeviceTap,
                      deviceConnected: deviceConnected,
                      onDisconnectPressed: handleDisconnectButtonPressed,
                    ),
                    AntMovingControls()
                  ],
                ),
              ),
          );
        }
      ),
      bottomNavigationBar: BottomSheetGAYA()
    );

  }
  bool deviceConnected = false;
  bool bluetoothButtonEnabled = true;

  //ZE BLUETOOTH DEVICE HAS BEEN CONNECTED

  void deviceSearch() async{
    try{
      if(!(await Permission.bluetoothScan.isGranted)){
        final status = await Permission.bluetoothScan.request();

        if(status != PermissionStatus.granted){
          setState(() {
            bluetoothButtonText = "Conectar";
          });
          return;
        }
      }
    } catch (e){
      if(!mounted) return;
      await showDialog<void>(context: context, barrierDismissible:false, builder:(context) => Normalalert(
        bodyText: "Erro desconhecido ao procurar dispositivos. Código de erro: $e", 
        titleText: "ERRO AO DISCONECTAR", 
        titleStyle: alertTitleStyle)
      );
    }

    setState(() {
      bluetoothButtonEnabled = false;
    });
    if(!mounted) return;
    showDialog(context: context, barrierDismissible: false, builder: (context) {
      return CircularLoading(loadingText: "A procurar dispositivos");
    },);

    await for( final event in FlutterBluetoothSerial.instance.startDiscovery()) {
      if(!mounted) return;

      setState(() {
        deviceInfo[event.device.address] =  event.device.name ?? "-unnamed-";
      });
    }
    if(!mounted) return;
    Navigator.of(context).pop();
    setState(() {
      bluetoothButtonText = '↓';
      bluetoothButtonEnabled = true;
    });
  }

  void handleConnectButtonPressed() {
    setState(() {
      availableDevicesListIsVisible = !availableDevicesListIsVisible;
      if (availableDevicesListIsVisible) {
        bluetoothButtonText = "↓";
        deviceInfo.clear();
        deviceSearch();
      } else {
        bluetoothButtonText = "Conectar";
      }
    });
  }

  String currentMacAdress = "";

  void handleDisconnectButtonPressed() async{
    setState(() {
      deviceConnected = false;
    });
    await bluetoothConnection.value?.finish();
    if(!mounted) return;
    showDialog(context: context, builder: (context) {
      return  Normalalert(titleText: "DISCONECTADO",bodyText: "Disconectado do dispositivo ${deviceInfo[currentMacAdress]}",);
    },);
  }

  void handleDeviceTap(String mac) async {
    showDialog<void>(context: context,barrierDismissible: false, builder: (context) {
      return CircularLoading(loadingText: "A conectar ao dispositivo ${deviceInfo[mac]}");
    },);
    try {
      if(!(await FlutterBluetoothSerial.instance.getBondStateForAddress(mac) == BluetoothBondState.bonded)){
        bool? v = await FlutterBluetoothSerial.instance.bondDeviceAtAddress(mac, pin: '1234');
        if(!(v??false)){
          if(!mounted) return;
          await showDialog<void>(context: context, barrierDismissible: false, builder: (context) => Normalalert(
          bodyText: "Erro ao emparelhar o dispositivo", 
          titleText: "ERRO DE EMPARELHAMENTO", 
          titleStyle: alertTitleStyle)
        );
        }
      }
      bluetoothConnection.value = await BluetoothConnection.toAddress(mac);
      if(!mounted) return;
      if(bluetoothConnection.value?.isConnected ?? false){
        await showDialog<void>(context: context, barrierDismissible: false, builder: (context) => Normalalert(
          bodyText: "Conectado ao dispositivo ${deviceInfo[mac]}", 
          titleText: "Sucesso!")
        );
        if(!mounted) return;
        setState(() {
          bluetoothStatus = "CONECTADO A ${deviceInfo[mac]}";
          deviceConnected = true;
          bluetoothButtonText = "Desconectar";
          currentMacAdress = mac;
          availableDevicesListIsVisible = false;
        });


        /*bluetoothConnection.value?.input!.listen((Uint8List data) {
          debugPrint("Got data:");
          for (var b in data) {
            debugPrint('Rx: $b');      
          }
        }).onDone(() { /*…*/ });*/
      } else {
        if(!mounted) return;
        await showDialog<void>(context: context, barrierDismissible: false, builder: (context) => Normalalert(
          bodyText: "Não foi possível conectar ao dispositivo ${deviceInfo[mac]}", 
          titleText: "ERRO DE CONEXÃO",
          titleStyle: alertTitleStyle));
        }
    } catch (e){
      if(!mounted) return;
        await showDialog<void>(context: context, barrierDismissible: false, builder: (context) => Normalalert(
          bodyText: "Erro: $e", 
          titleText: "ERRO DESCONHECIDO",
          titleStyle: alertTitleStyle));
    }
      if(!mounted) return;
      Navigator.of(context).pop();
    }
  }

