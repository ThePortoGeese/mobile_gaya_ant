import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

enum BTState {
  disconnected, connected, errorConnection, errorPermission1,errorPermission2, errorBonding,errorSearch, off,loadingDevices, notAvailable, waiting, uknown
}


class BluetoothModule with ChangeNotifier{
  BTState btState = BTState.off;
  BluetoothConnection? bluetoothConnection;
  Map<String, String> deviceInfo = {};
  String? currentMacAdress = "";
  String lastSender = "";
  int lastAction = 0;

  Future<void> initializeBluetooth() async{
    FlutterBluetoothSerial.instance.onStateChanged().listen((newState){
        handleBluetoothStateChange(newState);
      }
    );
    
    //I need to check if the user can even access bluetooth
    if((await checkBluetoothAvailability() )== false){
      btState = BTState.notAvailable;
      notifyListeners();
    }

    if(!(await Permission.bluetoothConnect.isGranted)){
      final status = await Permission.bluetoothConnect.request();

      if(status == PermissionStatus.denied){
        btState = BTState.errorPermission1;
        notifyListeners();
      }
    }
    //I try to see what state is bluetooth on

    final initialBTState = await FlutterBluetoothSerial.instance.state;

    //Handles the bt state of the application
    handleBluetoothStateChange(initialBTState);
  }

  void handleBluetoothStateChange(BluetoothState newState) async{
    if(newState == BluetoothState.STATE_OFF){
      btState = BTState.off;
    } else if (newState == BluetoothState.STATE_ON){
      btState = BTState.disconnected;
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
      if(!(await Permission.bluetoothScan.isGranted) || !(await Permission.bluetoothScan.isLimited)){
        final status = await Permission.bluetoothScan.request();

        if(status != PermissionStatus.granted){
          btState = BTState.errorPermission2;
          return;
        }
      }
    } catch (e){
      btState = BTState.errorSearch;
    }


    deviceInfo.clear();

    btState = BTState.loadingDevices;
    notifyListeners();

    await for( final event in FlutterBluetoothSerial.instance.startDiscovery()) {
      deviceInfo[event.device.address] =  event.device.name ?? "-unnamed-";
      notifyListeners();
    }

    btState = BTState.waiting;
    notifyListeners();
  }

  Future<void> connectToDevice(String mac) async {
    try {
      if(!(await FlutterBluetoothSerial.instance.getBondStateForAddress(mac) == BluetoothBondState.bonded)){
        bool? v = await FlutterBluetoothSerial.instance.bondDeviceAtAddress(mac, pin: '1234');
        if(!(v??false)){
          btState = BTState.errorBonding;
          notifyListeners();
        }
      }
      bluetoothConnection = await BluetoothConnection.toAddress(mac).timeout(const Duration(seconds: 6));

      if(bluetoothConnection?.isConnected ?? false){
        btState = BTState.connected;
        currentMacAdress = mac;
      } else {
        debugPrint("Error Connection");
        btState = BTState.errorConnection;
      }
    } catch (e){
        btState = BTState.errorConnection;
    }
    notifyListeners();
  }

  void disconnectFromDevice() async{
    await bluetoothConnection?.finish();
    
    btState = BTState.disconnected;
    currentMacAdress = "";
    bluetoothConnection = null;
    notifyListeners();
  }

   void sendBytes(Uint8List i, String id) async{
    try {
      lastSender = id;

      bluetoothConnection?.output.add(i);
      await bluetoothConnection?.output.allSent;
      lastAction = i[0].toInt();
      debugPrint("Sent ${i.toString()}");
      notifyListeners();
      return;
    } catch (e){
      disconnectFromDevice();
    }
  } 
}
