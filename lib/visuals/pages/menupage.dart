  import 'dart:io';
import 'package:ispgaya_ant/visuals/dialogs/welcomepopup.dart';
import 'package:shared_preferences/shared_preferences.dart';
  import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
  import 'package:ispgaya_ant/l10n/app_localizations.dart';
  import 'package:ispgaya_ant/models/localenotifer.dart';
  import 'package:ispgaya_ant/visuals/dialogs/passwordpopup.dart';
  import 'package:ispgaya_ant/models/bluetoothmodule.dart';
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

    //this function checks if it's the users first time using shared preferences and initializes the bluetooth in the bluetooth module
    void startApp() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? firstTime = prefs.getBool("firstTime");

      if(firstTime??true){
        if(mounted){
          await showDialog(context: context, builder: (context) => WelcomePopUp());
          prefs.setBool('firstTime', false);
        }
      }
      if(!mounted) return;

      //WHEN THE USER OPENS THE APP, I TRY TO INITIALIZE ITS BLUETOOTH FUNCTIONS
      context.read<BluetoothModule>().addListener(handleBtStateChange);
      context.read<BluetoothModule>().initializeBluetooth();
    }

    @override
    void initState(){
      super.initState();

      startApp();

      selectedItem = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
      currentIcon = Image.asset(
        'assets/${selectedItem}lang.png',
        width: 24,
        height: 24,
        fit: BoxFit.contain,
      );
    }

    @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      
    });
  }
    //disposes of the widget
    @override
    void dispose() {
      context.read<BluetoothModule>().removeListener(handleBtStateChange);
      super.dispose();
    }


    //when the btstate of the module changes, ts gets triggered
    //mostly used for state management
    void handleBtStateChange() async{
      BTState bts = context.read<BluetoothModule>().btState;
    
      switch (bts){
        case BTState.errorBonding:
          Navigator.of(context).pop();
          await showDialog<void>(context: context, barrierDismissible: false, builder: (context) => 
            Normalalert(titleText: AppLocalizations.of(context)!.bondingError, bodyText: AppLocalizations.of(context)!.bondingErrorMessage,titleStyle: alertTitleStyle));
        case BTState.errorConnection:
          Navigator.of(context).pop();
         await showDialog<void>(context: context, barrierDismissible: false, builder: (context) => 
          Normalalert(titleText: AppLocalizations.of(context)!.connectionError, bodyText: AppLocalizations.of(context)!.connectionErrorMessage,titleStyle: alertTitleStyle));
        case BTState.errorPermission2:
          await showDialog<void>(context: context, barrierDismissible: false, builder: (context) => 
            Normalalert(titleText: AppLocalizations.of(context)!.permissionsError, bodyText: AppLocalizations.of(context)!.permissionsErrorMessage,titleStyle: alertTitleStyle));
          setState(() {
            availableDevicesListIsVisible = false;
          }); 
        case BTState.errorSearch:
          showDialog(context: context, builder: (context) {
            return  Normalalert(titleText: AppLocalizations.of(context)!.disconnectedStatus,bodyText: AppLocalizations.of(context)!.disconnectedFromDevice,titleStyle: alertTitleStyle,);
          },
          );
          setState(() {
            availableDevicesListIsVisible = false;
          }); 
        case BTState.connecting:
          showDialog<void>(context: context,barrierDismissible: false, builder: (context) {
            return CircularLoading(loadingText: AppLocalizations.of(context)!.connectingToDevice);
          },);
        case BTState.startSearch:
          showDialog(context: context, barrierDismissible: false, builder: (context) {
            return CircularLoading(loadingText: AppLocalizations.of(context)!.searchingDevices);
          },);  
        case BTState.connected:
          //when connected, the device list should be invis
          setState(() {
            availableDevicesListIsVisible = false;
          }); 
        case BTState.disconnected:
        //when disconnected, the button should be enabled (so he can connect)
          setState(() {
            bluetoothButtonEnabled = true;
          });
        case BTState.off:
          //when the bt is off, the button shouldnt work and a prompt should appear so the user can enable it
          setState(() {
            bluetoothButtonEnabled = false;
            availableDevicesListIsVisible = false;
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
        //errors that dont happen inside a function and therefore, its best I do it here
        case BTState.errorPermission1:          
        await showDialog<void>(context: context, barrierDismissible: false, builder: (context) => 
          Normalalert(titleText: AppLocalizations.of(context)!.permissionsError, bodyText: AppLocalizations.of(context)!.permissionsErrorMessage,titleStyle: alertTitleStyle));
          if(!mounted) return;
          context.read<BluetoothModule>().initializeBluetooth();
        case BTState.notAvailable:
          await showDialog<void>(context: context, barrierDismissible: false, builder: (context) => 
          Normalalert(titleText: AppLocalizations.of(context)!.bluetoothError, bodyText: AppLocalizations.of(context)!.bluetoothNotAvailableMessage,titleStyle: alertTitleStyle));
          exit(0);
        default:
          //debugPrint("Didnt implement ${context.read<BluetoothModule>().btState.toString()}");
      }
    }

    //THIS VARIABLE JUST CONTROLS IF THE DEVICE LIST IS VISIBLE OR NOT
    bool availableDevicesListIsVisible = false;

    String? selectedItem = "en";
    @override
    Widget build(BuildContext context) {

      //I just coverted the country dialects  to the mother language and change the popupmennubtn based on that
      //i also set default locale as pt
      String? changeLanguage = context.watch<LocaleNotifer>().locale?.languageCode ?? 'en';
      selectedItem = changeLanguage;

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
                  //Sets the locale and the icon for the popupmenubtn
                  selectedItem = value;
                  currentIcon = Image.asset(
                    'assets/${selectedItem}lang.png',
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  );
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
                      Image.asset('assets/enlang.png', width: 24,height: 24,fit: BoxFit.contain),
                      const SizedBox(width: 8),
                      Text("ENG") 
                    ]
                  )
                ),
                PopupMenuItem<String>(value: 'fr', 
                  child: Row(
                    children: <Widget>[
                      Image.asset('assets/frlang.png', width: 24,height: 24,fit: BoxFit.contain),
                      const SizedBox(width: 8),
                      Text("FRA") 
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
    bool bluetoothButtonEnabled = false;

    //ZE BLUETOOTH DEVICE HAS BEEN CONNECTED
    //Changes visibility of the list, shows the circular loading, and prompts the btm to search for available devices. if the btm.btstate 
    //has an error related to this action, it will show a pop up and make the list invisible again
    void handleConnectButtonPressed() async {
      setState(() {
        availableDevicesListIsVisible = !availableDevicesListIsVisible;
      });
      if(availableDevicesListIsVisible){
        if(!(await context.read<BluetoothModule>().checkIfStreamIsBusy() ?? false)){
          if(!mounted) return;
          await context.read<BluetoothModule>().deviceSearch();
          if(!mounted ||  context.read<BluetoothModule>().btState == BTState.errorPermission2) return;
          Navigator.of(context).pop();
        }
      }
    }

    //Sends the neutral state code for the ant (so it doesnt keep moving after the user disconnects when, for exampple, pressing the dance button)
    //Then tries to disconnect 
    void handleDisconnectButtonPressed() async{
      context.read<BluetoothModule>().sendBytes(Uint8List.fromList([5]), "disconnectButton");
      context.read<BluetoothModule>().disconnectFromDevice();
      //Freshly disconnected, didnt feel like altering this, I know I should have put ts in my state managemet function
      if(!mounted) return;
      if(BTState.disconnected ==  context.read<BluetoothModule>().btState){
        showDialog(context: context, builder: (context) {
          return  Normalalert(titleText: AppLocalizations.of(context)!.disconnectedStatus,bodyText: AppLocalizations.of(context)!.disconnectedFromDevice,);
        },);
      }
    }
    //asks the user for the device's password, default is 1234
    void handleDeviceTap(String mac) async {
      String pin = "1234";
      if(!(await context.read<BluetoothModule>().checkDeviceBonded(mac))){
        if(!mounted) return;
        pin = await showDialog<String>(context: context , barrierDismissible: false, builder: (context) {return PasswordPopUp();})??"1234";
      }
      if(!mounted) return;

      //shows the loading dialog again
      
      //and tries to connect to the device

      if(!mounted) return;
      if(await context.read<BluetoothModule>().connectToDevice(mac, pin) == FunctionState.failure) return;
      //checks if an error occured due to this action and shows the corresponding error

      if(!mounted) return;
      Navigator.of(context).pop();
    }
  }