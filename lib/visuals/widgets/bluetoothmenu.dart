import 'package:flutter/material.dart';
import 'package:mobile_gaya_ant/l10n/app_localizations.dart';
import 'package:mobile_gaya_ant/visuals/widgets/bluetoothmodule.dart';
import 'package:mobile_gaya_ant/visuals/smallwidgets/devicelist.dart';
import 'package:provider/provider.dart';

class BluetoothMenu extends StatelessWidget {
  const BluetoothMenu({
    super.key,
    required this.isListVisible,
    required this.onConnectPressed,
    required this.onDeviceTap,
    required this.onDisconnectPressed,
    required this.bluetoothButtonEnabled,
  });

  final bool bluetoothButtonEnabled;
  final bool isListVisible;
  final VoidCallback onConnectPressed;
  final VoidCallback onDisconnectPressed;
  final ValueChanged<String> onDeviceTap;   // MAC ADDRESS
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffB6DFFF),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: BoxBorder.all(color: Colors.black, width: 1)
        //boxShadow: [BoxShadow(color: Colors.blueGrey, blurRadius: 5.0, spreadRadius: 1.0)]
      ),
      margin: const EdgeInsets.all(10),
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Text(AppLocalizations.of(context)!.connectionStatus, style: TextStyle(fontSize: 24)),
          SizedBox(height: 10),
          Text((context.read<BluetoothModule>().bluetoothConnection?.isConnected ?? false) ? "${AppLocalizations.of(context)!.connectedToDevice} ${context.read<BluetoothModule>().deviceInfo[context.read<BluetoothModule>().currentMacAdress]}"   :  AppLocalizations.of(context)!.disconnectedStatus, 
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:((context.read<BluetoothModule>().bluetoothConnection?.isConnected ?? false) ?  Color(0xff194B97) :  Color(0xffDB3B3E)),
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
            child: Text((isListVisible ? "↓" : ((context.read<BluetoothModule>().bluetoothConnection?.isConnected ?? false) ? AppLocalizations.of(context)!.disconnect : AppLocalizations.of(context)!.connect)))
          ),
          DeviceList(isListSupposedToBeVisible: isListVisible, onDeviceTap: onDeviceTap),
        ],
      ),
    );
  }
}

