import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

enum BluetoothStatus {
  disconnected, connected, errorConnection, errorPermission1,errorPermission2, errorBonding,errorSearch, off, loading, notAvailable, waiting, uknown
}


class BluetoothModule with ChangeNotifier{
  BluetoothStatus btState = BluetoothStatus.off;
  BluetoothConnection? bluetoothConnection;
  Map<String, String> deviceInfo = {};

  Future<void> initializeBluetooth() async{
    //TODO: SET BUTTON OFF

    btState = BluetoothStatus.loading;
    notifyListeners();

    FlutterBluetoothSerial.instance.onStateChanged().listen((newState){
        handleBluetoothStateChange(newState);
      }
    );
    
    //I need to check if the user can even access bluetooth
    if((await checkBluetoothAvailability() )== false){
      btState = BluetoothStatus.notAvailable;
      notifyListeners();
    }

    if(!(await Permission.bluetoothConnect.isGranted)){
      final status = await Permission.bluetoothConnect.request();

      if(status == PermissionStatus.denied){
        // TODO: SHOW ERROR
        btState = BluetoothStatus.errorPermission1;
        notifyListeners();
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

    if(newState == BluetoothState.STATE_OFF){
      btState = BluetoothStatus.off;
      /*await showDialog<void>(context: context, barrierDismissible: false, builder: (context) => AlertDialog(
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
      ),);*/
    } else if (newState == BluetoothState.STATE_ON){
      btState = BluetoothStatus.disconnected;
      //If the bt is on, we caan finally enable the button
      // TODO: ENABLE BT
    }
    notifyListeners();
  }

  void requestEnableBluetooth() async{
    //Just requests the bt permission from the user
    await FlutterBluetoothSerial.instance.requestEnable();
  }

  Future<bool> checkBluetoothAvailability() async {
    //This functions checks if the device even has bt, if it doesnt, it closes
    final bool? isAvailable = await FlutterBluetoothSerial.instance.isAvailable;

    return isAvailable!;
  }
  
  void deviceSearch() async{
    //Request BT Permission
    try{
      if(!(await Permission.bluetoothScan.isGranted)){
        final status = await Permission.bluetoothScan.request();

        if(status != PermissionStatus.granted){
          btState = BluetoothStatus.errorPermission2;
          return;
        }
      }
    } catch (e){
      btState = BluetoothStatus.errorSearch;
    }

    /*showDialog(context: context, barrierDismissible: false, builder: (context) {
      return CircularLoading(loadingText: "A procurar dispositivos");
    },);*/

    deviceInfo.clear();

    btState = BluetoothStatus.loading;
    notifyListeners();

    //TODO: CIrcular Loading

    await for( final event in FlutterBluetoothSerial.instance.startDiscovery()) {
      deviceInfo[event.device.address] =  event.device.name ?? "-unnamed-";
      notifyListeners();
    }

    btState = BluetoothStatus.waiting;
    notifyListeners();
    //TODO: BTN
  }

  Future<void> connectToDevice(String mac) async {
    try {
      if(!(await FlutterBluetoothSerial.instance.getBondStateForAddress(mac) == BluetoothBondState.bonded)){
        bool? v = await FlutterBluetoothSerial.instance.bondDeviceAtAddress(mac, pin: '1234');
        if(!(v??false)){
          btState = BluetoothStatus.errorBonding;
          notifyListeners();
        }
      }
      bluetoothConnection = await BluetoothConnection.toAddress(mac);
      if(bluetoothConnection?.isConnected ?? false){
        btState = BluetoothStatus.connected;
      } else {
        btState = BluetoothStatus.errorConnection;
        }
    } catch (e){
        btState = BluetoothStatus.uknown;
    }
    notifyListeners();
  }

  void disconnectFromDevice() async{
    await bluetoothConnection?.finish();
    
    btState = BluetoothStatus.disconnected;
    notifyListeners();
  }
}
