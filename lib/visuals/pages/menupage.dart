import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_gaya_ant/l10n/app_localizations.dart';
import 'package:mobile_gaya_ant/models/localenotifer.dart';
import 'package:mobile_gaya_ant/visuals/widgets/bluetoothmodule.dart';
import 'package:provider/provider.dart';
import '../widgets/bluetoothmenu.dart';
import '../dialogs/circularloading.dart';
import '../dialogs/normalalert.dart';
import '../smallwidgets/bottomsheet.dart';
import '../widgets/antmovingcontrols.dart';
import '../../models/generalvalues.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  //THIS IS THE ICON OF THE LANGUAGE BUTTON
  Widget? currentIcon = Image.asset('assets/ptlang.png', width: 24,height: 24,fit: BoxFit.contain);

  @override
  void initState(){
    super.initState();
    //WHEN THE USER OPENS THE APP, I TRY TO INITIALIZE ITS BLUETOOTH FUNCTIONS
    context.read<BluetoothModule>().addListener(handleBtStateChange);
    context.read<BluetoothModule>().initializeBluetooth();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void handleBtStateChange() async{
    BTState bts = context.read<BluetoothModule>().btState;
  
    switch (bts){
      case BTState.connected:
        setState(() {
          availableDevicesListIsVisible = false;
        }); 
      case BTState.disconnected:
        setState(() {
          bluetoothButtonEnabled = true;
        });
      case BTState.off:
        setState(() {
          bluetoothButtonEnabled = false;
        });
        await showDialog<void>(context: context, barrierDismissible: false, builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.bluetoothError,  style: alertTitleStyle),
          content: Text(AppLocalizations.of(context)!.bluetoothOffMessage),
          actions: [
            TextButton(onPressed: (){
              context.read<BluetoothModule>().requestEnableBluetooth();
              Navigator.of(context).pop();
            }, child: Text(AppLocalizations.of(context)!.yes)),
            TextButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text(AppLocalizations.of(context)!.no)),
          ],
        ),);
      case BTState.errorBonding:
        await showDialog<void>(context: context, barrierDismissible: false, builder: (context) => 
          Normalalert(titleText: AppLocalizations.of(context)!.bondingError, bodyText: AppLocalizations.of(context)!.bondingErrorMessage,titleStyle: alertTitleStyle));
      case BTState.errorConnection:
          if(!mounted) return;
          Navigator.of(context).pop();
          debugPrint("Came");
          await showDialog<void>(context: context, barrierDismissible: false, builder: (context) => 
           Normalalert(titleText: AppLocalizations.of(context)!.connectionError, bodyText: AppLocalizations.of(context)!.connectionErrorMessage,titleStyle: alertTitleStyle));
      case BTState.errorPermission1: case BTState.errorPermission2:
        await showDialog<void>(context: context, barrierDismissible: false, builder: (context) => 
        Normalalert(titleText: AppLocalizations.of(context)!.permissionsError, bodyText: AppLocalizations.of(context)!.permissionsErrorMessage,titleStyle: alertTitleStyle));
        exit(0);
      case BTState.notAvailable:
        await showDialog<void>(context: context, barrierDismissible: false, builder: (context) => 
        Normalalert(titleText: AppLocalizations.of(context)!.bluetoothError, bodyText: AppLocalizations.of(context)!.bluetoothNotAvailableMessage,titleStyle: alertTitleStyle));
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
    String? selectedItem = context.watch<LocaleNotifer>().locale.toString();
    if(selectedItem.contains("en")){
      currentIcon = Image.asset('assets/englang.png', width: 24,height: 24,fit: BoxFit.contain);
      selectedItem = "en";
    }

    return Scaffold(
      appBar: AppBar(
        shadowColor: Color(0xff000000),
        backgroundColor: Color(0xffFB923C),
        title: Text(AppLocalizations.of(context)!.appBarText, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: currentIcon,
            initialValue: selectedItem,
            tooltip: AppLocalizations.of(context)!.appLanguage,
            onSelected: (String value) {
              setState(() {
                selectedItem = value;
                if(value == "en"){
                  currentIcon = Image.asset('assets/englang.png', width: 24,height: 24,fit: BoxFit.contain);
                } else {
                  currentIcon = Image.asset('assets/ptlang.png', width: 24,height: 24,fit: BoxFit.contain);
                }
                context.read<LocaleNotifer>().setLocale(Locale(selectedItem!));
              });
            },  
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'pt',
                child: Row(
                  children: <Widget>[
                    Image.asset('assets/ptlang.png', width: 24,height: 24,fit: BoxFit.contain),
                    const SizedBox(width: 8),
                    Text("PT")
                    
                  ]
                ),),
              PopupMenuItem<String>(value: 'en', 
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
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: BluetoothMenu(
                            bluetoothButtonEnabled: bluetoothButtonEnabled,
                            isListVisible: availableDevicesListIsVisible,
                            onConnectPressed: handleConnectButtonPressed,
                            onDeviceTap: handleDeviceTap,
                            onDisconnectPressed: handleDisconnectButtonPressed,
                          ),
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
    });
    if(availableDevicesListIsVisible){
      showDialog(context: context, barrierDismissible: false, builder: (context) {
        return CircularLoading(loadingText: AppLocalizations.of(context)!.searchingDevices);
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
      return  Normalalert(titleText: AppLocalizations.of(context)!.disconnectedStatus,bodyText: AppLocalizations.of(context)!.disconnectedFromDevice,);
    },);
  }

  void handleDeviceTap(String mac) async {
    showDialog<void>(context: context,barrierDismissible: false, builder: (context) {
      return CircularLoading(loadingText: "${AppLocalizations.of(context)!.connectingToDevice} ${context.read<BluetoothModule>().deviceInfo[mac]}");
    },);
    
    await context.read<BluetoothModule>().connectToDevice(mac);

    if(!mounted) return;
    if( context.read<BluetoothModule>().btState != BTState.errorConnection){
      Navigator.of(context).pop();
      }
    }
  }

