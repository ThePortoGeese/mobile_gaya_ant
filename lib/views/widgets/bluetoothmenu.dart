import 'package:flutter/material.dart';
import 'package:mobile_gaya_ant/bluetoothmodule.dart';
import 'package:mobile_gaya_ant/views/smallwidgets/devicelistitem.dart';
import 'package:provider/provider.dart';

class BluetoothMenu extends StatelessWidget {
  const BluetoothMenu({
    super.key,
    required this.status,
    required this.buttonText,
    required this.isListVisible,
    required this.onConnectPressed,
    required this.onDeviceTap,
    required this.onDisconnectPressed,
    required this.bluetoothButtonEnabled,
  });

  final bool bluetoothButtonEnabled;
  final String status;
  final String buttonText;
  final bool isListVisible;
  final VoidCallback onConnectPressed;
  final VoidCallback onDisconnectPressed;
  final ValueChanged<String> onDeviceTap;   // MAC ADDRESS
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffB6DFFF),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      margin: const EdgeInsets.all(30),
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Text("Estado de Conexão", style: TextStyle(fontSize: 24)),
          SizedBox(height: 10),
          Text(status, textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:(status == 'DESCONECTADO' ?  const Color(0xffDB3B3E) : const Color(0xff194B97)),
                  fontSize: 24)),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ((context.read<BluetoothModule>().bluetoothConnection?.isConnected ?? false) ? Color(0xffDB3B3E) : Color(0xff194B97)),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 36),
              shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(5)),
            ),
            onPressed:(bluetoothButtonEnabled ? ((context.read<BluetoothModule>().bluetoothConnection?.isConnected??false)? onDisconnectPressed : onConnectPressed) : null),
            child: Text(buttonText),
          ),
          Visibility(
            visible: isListVisible,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                color: const Color(0xff6DA3F4).withValues(alpha: 0.7),
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: context.read<BluetoothModule>().deviceInfo.length,
                itemBuilder: (context, index) {
                  final mac   = context.read<BluetoothModule>().deviceInfo.keys.elementAt(index);
                  return DeviceListItem(value: context.read<BluetoothModule>().deviceInfo[mac]!, onDeviceTap: () => onDeviceTap(mac));
                } 
                ),
              ),
            ),
        ],
      ),
    );
  }
}
