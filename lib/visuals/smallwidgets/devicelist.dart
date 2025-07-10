import 'package:flutter/material.dart';
import 'package:mobile_gaya_ant/visuals/smallwidgets/devicelistitem.dart';
import 'package:mobile_gaya_ant/models/bluetoothmodule.dart';
import 'package:provider/provider.dart';

class DeviceList extends StatefulWidget {
  const DeviceList({
    super.key,
    required this.isListSupposedToBeVisible,
    required this.onDeviceTap,
  });

  final bool isListSupposedToBeVisible;
  final ValueChanged<String> onDeviceTap;

  @override
  State<DeviceList> createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> with SingleTickerProviderStateMixin {
  bool listVisible = false;
  late final AnimationController _animationController = AnimationController(vsync: this , duration: Duration(milliseconds: 1000));
  late final Animation _animation = CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn);

  @override
  void initState() {
    super.initState();
  }


  @override
  void didChangeDependencies() {
    debugPrint("Triggered");
    super.didChangeDependencies();

  }

  @override
  Widget build(BuildContext context) {
    if(widget.isListSupposedToBeVisible){
      listVisible = true;
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    return AnimatedBuilder (
      animation: _animation,
      builder: (context, child) => 
      AnimatedSize(
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 500),
        onEnd: () {
          if(!widget.isListSupposedToBeVisible){listVisible = false;}
        },
        child: SizedBox(
          width: double.infinity,
          height: (widget.isListSupposedToBeVisible) ? 300 : 0,
          child: Transform(
            transform: Matrix4.translationValues(0, (_animation.value - 1) * 30, (_animation.value - 1) * 30),
            child: Visibility(
              visible: listVisible,
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
                    return DeviceListItem(value: context.read<BluetoothModule>().deviceInfo[mac]!, onDeviceTap: () => widget.onDeviceTap(mac));
                  } 
                ),
              ),
            ),
        ),)
      )
    );
  }
}
