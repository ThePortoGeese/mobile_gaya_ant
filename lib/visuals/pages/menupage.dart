import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_gaya_ant/bluetoothmodule.dart';
import 'package:provider/provider.dart';
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

  //THESE ARE VARIABLES WITH THE VALUES FOR BUTTONS AND LABELS
  String status = "DESCONECTADO";
  String bluetoothButtonText = "Conectar";

  @override
  void initState(){
    super.initState();
    //WHEN THE USER OPENS THE APP, I TRY TO INITIALIZE ITS BLUETOOTH FUNCTIONS
    context.read<BluetoothModule>().addListener(handleBtStateChange);
    context.read<BluetoothModule>().initializeBluetooth();
  }

  void handleBtStateChange() async{
    BTState bts = context.read<BluetoothModule>().btState;
  
    switch (bts){
      case BTState.connected:
        setState(() {
          availableDevicesListIsVisible = false;
          bluetoothButtonText = "Desconectar";
          status = "CONECTADO A ${context.read<BluetoothModule>().deviceInfo[context.read<BluetoothModule>().currentMacAdress]}";
        }); 
      case BTState.disconnected:
        context.read<BluetoothModule>().bluetoothConnection = null;
        setState(() {
          bluetoothButtonEnabled = true;
          bluetoothButtonText = "Conectar";
          status = "DESCONECTADO";
        });
      case BTState.off:
        setState(() {
          bluetoothButtonEnabled = false;
        });
        await showDialog<void>(context: context, barrierDismissible: false, builder: (context) => AlertDialog(
          title: Text("ERRO BLUETOOTH",  style: alertTitleStyle),
          content: Text("Parece que o seu bluetooth está desligado, pretende ligá-lo?"),
          actions: [
            TextButton(onPressed: (){
              context.read<BluetoothModule>().requestEnableBluetooth();
              Navigator.of(context).pop();
            }, child: Text("Sim")),
            TextButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text("Não")),
          ],
        ),);
      case BTState.errorBonding:
        await showDialog<void>(context: context, barrierDismissible: false, builder: (context) => 
          Normalalert(titleText: "ERRO DE EMPARELHAMENTO", bodyText: "Houve um erro a emparelhar o dispositivo",titleStyle: alertTitleStyle));
      case BTState.errorConnection:
          await showDialog<void>(context: context, barrierDismissible: false, builder: (context) => 
           Normalalert(titleText: "ERRO DE CONEXÃO", bodyText: "Houve um erro a conectar com o dispositivo",titleStyle: alertTitleStyle));
      case BTState.errorPermission1: case BTState.errorPermission2:
        await showDialog<void>(context: context, barrierDismissible: false, builder: (context) => 
        Normalalert(titleText: "ERRO DE PERMISSÃO", bodyText: "Não aceitou as permissões. Vamos fechar agora",titleStyle: alertTitleStyle));
        exit(0);
      case BTState.notAvailable:
        await showDialog<void>(context: context, barrierDismissible: false, builder: (context) => 
        Normalalert(titleText: "NÃO SUPORTA BLUETOOTH", bodyText: "O seu dispositivo não têm tecnologia bluetooth. Vamos fechar agora",titleStyle: alertTitleStyle));
        exit(0);
      case BTState.loadingDevices:
        break;
      case BTState.waiting:
        Navigator.of(context).pop();
      default:
        debugPrint("Didnt implement ${context.read<BluetoothModule>().btState.toString()}");
    }
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
      body: ListenableBuilder(
        listenable: context.read<BluetoothModule>(),
        builder: (context, child) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: <Widget>[
                        BluetoothMenu(
                          bluetoothButtonEnabled: bluetoothButtonEnabled,
                          status: status,
                          buttonText: bluetoothButtonText,
                          isListVisible: availableDevicesListIsVisible,
                          onConnectPressed: handleConnectButtonPressed,
                          onDeviceTap: handleDeviceTap,
                          onDisconnectPressed: handleDisconnectButtonPressed,
                        ),
                        AntMovingControls()
                      ],
                    ),
                  ),
              ),
            ],
          );
        }
      ),
      bottomNavigationBar: BottomSheetGAYA()
    );

  }
  bool deviceConnected = false;
  bool bluetoothButtonEnabled = false;

  //ZE BLUETOOTH DEVICE HAS BEEN CONNECTED

  void handleConnectButtonPressed() async {
    setState(() {
      availableDevicesListIsVisible = !availableDevicesListIsVisible;
      if (availableDevicesListIsVisible) {
        bluetoothButtonText = "↓";
      } else {
        bluetoothButtonText = "Conectar";
      }
    });
    if(availableDevicesListIsVisible){
      showDialog(context: context, barrierDismissible: false, builder: (context) {
        return CircularLoading(loadingText: "A procurar dispositivos");
      },);  
      context.read<BluetoothModule>().deviceSearch();
    }
  }


  void handleDisconnectButtonPressed() async{
    setState(() {
      deviceConnected = false;
    });

    context.read<BluetoothModule>().disconnectFromDevice();

    if(!mounted) return;
    showDialog(context: context, builder: (context) {
      return  Normalalert(titleText: "DISCONECTADO",bodyText: "Disconectado do dispositivo",);
    },);
  }

  void handleDeviceTap(String mac) async {
    showDialog<void>(context: context,barrierDismissible: false, builder: (context) {
      return CircularLoading(loadingText: "A conectar ao dispositivo ${context.read<BluetoothModule>().deviceInfo[mac]}");
    },);
    
    await context.read<BluetoothModule>().connectToDevice(mac);

    if(!mounted) return;
    Navigator.of(context).pop();
    }
  }

