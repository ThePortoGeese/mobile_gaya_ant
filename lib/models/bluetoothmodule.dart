import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

enum BTState {
  disconnected, connected, errorConnection, errorPermission1,errorPermission2, errorBonding,errorSearch, off, notAvailable, uknown, connecting, searching
}

/// NOTE: All of the actions done by this module (or most) change its state to another
/// To detect these changes make a provider of the module and use a consumer or a context.watch()

enum FunctionState{
  success, failure
}

class BluetoothModule with ChangeNotifier{
  bool initialized = false;
  //State of the module, used for state management 
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
  Future<FunctionState> initializeBluetooth() async{
    //Sets up the event listener for state change
    FlutterBluetoothSerial.instance.onStateChanged().listen((newState){
        handleBluetoothStateChange(newState);
      }
    );
    
    //I need to check if the user can even access bluetooth
    if((await checkBluetoothAvailability() )== FunctionState.failure){
      btState = BTState.notAvailable;
      notifyListeners();
      return FunctionState.failure;
    }

    //Request permission from user 
    if(!(await Permission.bluetoothConnect.isGranted)){
      final status = await Permission.bluetoothConnect.request();

      if(status == PermissionStatus.denied || status == PermissionStatus.permanentlyDenied){
        btState = BTState.errorPermission1;
        notifyListeners();
        debugPrint("------ I deniedm the permission? ----");
        return FunctionState.failure;
      }
    }
    //I try to see what state is bluetooth on

    final initialBTState = await FlutterBluetoothSerial.instance.state;

    //Handles the bt state of the application
    handleBluetoothStateChange(initialBTState);
    initialized = true;

    return FunctionState.success;
  }

  //Changes the state of the module so the state "machine" can react to it
  void handleBluetoothStateChange(BluetoothState newState) async{

    if(newState == BluetoothState.STATE_OFF){
      btState = BTState.off;
    } else if (newState == BluetoothState.STATE_ON){
      btState = BTState.disconnected;
    }
    notifyListeners();
  }

  //Requests the user to enable bt
  Future<FunctionState> requestEnableBluetooth() async{

    btState = BTState.uknown;
    //Just requests the bt permission from the user
    final b = await FlutterBluetoothSerial.instance.requestEnable();
    if(b!){
      btState = BTState.disconnected;
      debugPrint("Success");
      return FunctionState.success;
    } else {
      return FunctionState.failure;
    }

  }

  //Checks if the device even has bluetooth
  Future<FunctionState> checkBluetoothAvailability() async {
    //This functions checks if the device even has bt, if it doesnt, it closes
    try{
      await FlutterBluetoothSerial.instance.isAvailable;
      return FunctionState.success;
    } catch (e){
      return FunctionState.failure;
    }

  }
  
  Future<bool?> checkIfStreamIsBusy() async{
    return await FlutterBluetoothSerial.instance.isDiscovering; 
  }

  Future<FunctionState> deviceSearch() async{
    //Request BT Permission
    try{
      if(!(await Permission.bluetoothScan.isGranted) || !(await Permission.bluetoothScan.isLimited)){
        final status = await Permission.bluetoothScan.request();

        if(status != PermissionStatus.granted){
          btState = BTState.errorPermission2;
          return FunctionState.failure;
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
      return FunctionState.failure;
    }
    return FunctionState.success;
  }

  Future<bool> checkDeviceBonded(String mac) async {
    //Checks if the mac is bonded to this device
    return (await FlutterBluetoothSerial.instance.getBondStateForAddress(mac) == BluetoothBondState.bonded);
  }

  Future<FunctionState> connectToDevice(String mac, String pin) async {
    //tries to bond with the device if he isnt already
      btState = BTState.connecting;
      notifyListeners();
      try{
        if(!(await FlutterBluetoothSerial.instance.getBondStateForAddress(mac) == BluetoothBondState.bonded)){
          bool? v = await FlutterBluetoothSerial.instance.bondDeviceAtAddress(mac, pin: pin);
          if(!(v??false)){
            btState = BTState.errorBonding;
            notifyListeners();
            return FunctionState.failure;
          }
        }
      } catch (e){
        btState = BTState.errorBonding;
        notifyListeners();
        FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
        return FunctionState.failure;
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
        return FunctionState.failure;
      }
    } catch (e){
        btState = BTState.errorConnection;
        return FunctionState.failure;
    }
    notifyListeners();
    return FunctionState.success;
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
