import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

enum BTState {
  disconnected, connected, errorConnection, errorPermission1,errorPermission2, errorBonding,errorSearch, off, notAvailable, uknown
}


class BluetoothModule with ChangeNotifier{

  //State of the module, used for state management in menupage
  BTState btState = BTState.off;

  //This holds the current bluetooth connection (only 1 at a time)
  BluetoothConnection? bluetoothConnection;

  //Holds the info for devices detected by bluetooth
  Map<String, String> deviceInfo = {};

  //Mac of the current connection
  String? currentMacAdress = "";

  //String that identifies the last control to sendData
  String lastSender = "";

  //Last byte sent
  int lastAction = 0;

  //Async fuction that initializaes bluetooth
  Future<void> initializeBluetooth() async{
    //Sets up the event listener for state change
    FlutterBluetoothSerial.instance.onStateChanged().listen((newState){
        handleBluetoothStateChange(newState);
      }
    );
    
    //I need to check if the user can even access bluetooth
    if((await checkBluetoothAvailability() )== false){
      btState = BTState.notAvailable;
      notifyListeners();
    }

    //Request permission from user 
    if(!(await Permission.bluetoothConnect.isGranted)){
      final status = await Permission.bluetoothConnect.request();

      if(status == PermissionStatus.denied){
        btState = BTState.errorPermission1;
        notifyListeners();
        return;
      }
    }
    //I try to see what state is bluetooth on

    final initialBTState = await FlutterBluetoothSerial.instance.state;

    //Handles the bt state of the application
    handleBluetoothStateChange(initialBTState);
  }

  //Changes the state of the module so my main page can react to it
  void handleBluetoothStateChange(BluetoothState newState) async{
    if(newState == BluetoothState.STATE_OFF){
      btState = BTState.off;
    } else if (newState == BluetoothState.STATE_ON){
      btState = BTState.disconnected;
    }
    notifyListeners();
  }

  //Requests the user to enable bt
  void requestEnableBluetooth() async{
    btState = BTState.uknown;
    //Just requests the bt permission from the user
    final b = await FlutterBluetoothSerial.instance.requestEnable();
    if(b!){
      btState = BTState.disconnected;
    } 

  }

  //Checks if the device even has bluetooth
  Future<bool> checkBluetoothAvailability() async {
    //This functions checks if the device even has bt, if it doesnt, it closes
    try{
      final bool? isAvailable = await FlutterBluetoothSerial.instance.isAvailable;
      return isAvailable!;
    } catch (e){
      return false;
    }

  }
  
  Future<void> deviceSearch() async{
    //Request BT Permission
    try{
      if(!(await Permission.bluetoothScan.isGranted) || !(await Permission.bluetoothScan.isLimited)){
        final status = await Permission.bluetoothScan.request();

        if(status != PermissionStatus.granted){
          btState = BTState.errorPermission2;
          return;
        }
      }
      //clears previously detected devices
      deviceInfo.clear();
      notifyListeners();

      await for( final event in FlutterBluetoothSerial.instance.startDiscovery()) {
        deviceInfo[event.device.address] =  event.device.name ?? "-unnamed-";
        notifyListeners();
      }
    } catch (e){
      btState = BTState.errorSearch;
    }
  }

  Future<bool> checkDeviceBonded(String mac) async {
    //Checks if the mac is bonded to this device
    return (await FlutterBluetoothSerial.instance.getBondStateForAddress(mac) == BluetoothBondState.bonded);
  }

  Future<void> connectToDevice(String mac, String pin) async {
    //tries to bond with the device if he isnt already
      try{
        if(!(await FlutterBluetoothSerial.instance.getBondStateForAddress(mac) == BluetoothBondState.bonded)){
          bool? v = await FlutterBluetoothSerial.instance.bondDeviceAtAddress(mac, pin: pin);
          if(!(v??false)){
            btState = BTState.errorBonding;
            notifyListeners();
          }
        }
      } catch (e){
        btState = BTState.errorBonding;
        notifyListeners();
        FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
        return;
      }
    try {
      //tries to establish a connection
      bluetoothConnection = await BluetoothConnection.toAddress(mac).timeout(const Duration(seconds: 6));

      if(bluetoothConnection?.isConnected ?? false){
        btState = BTState.connected;
        currentMacAdress = mac;
      } else {
        //debugPrint("Error Connection");
        btState = BTState.errorConnection;
      }
    } catch (e){
        btState = BTState.errorConnection;
    }
    notifyListeners();
  }

  void disconnectFromDevice() async{
    //Disconnects and resets attributes of the module
    await bluetoothConnection?.finish();
    
    btState = BTState.disconnected;
    currentMacAdress = "";
    bluetoothConnection = null;
    notifyListeners();
  }

   void sendBytes(Uint8List i, String id) async{
    //Tries to sent bytes and sets the last values to their corresponding values
    try {
      lastSender = id;

      bluetoothConnection?.output.add(i);
      await bluetoothConnection?.output.allSent;
      lastAction = i[0].toInt();
      //debugPrint("Sent ${i.toString()}");
      notifyListeners();
      return;
    } catch (e){
      disconnectFromDevice();
    }
  } 
}
