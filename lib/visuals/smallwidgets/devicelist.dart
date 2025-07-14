import 'package:flutter/material.dart';
import 'package:ispgaya_ant/visuals/smallwidgets/devicelistitem.dart';
import 'package:ispgaya_ant/models/bluetoothmodule.dart';
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

//This list, which is just a container with a visibility and a listview
//is filled with all the devices the bluetooth module detects
//as the length of device info starts increasing, so does the list view
//It features a small animation which just hides it and unhides it behind the visible
//The 2 booleans are necessary so the animation isnt clipped
//when the list is not supposed to be visible, the reverse animation starts and only then does the visibility actually change
 

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
    //debugPrint("Triggered");
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
                child: RawScrollbar(
                  thumbColor: Color(0xff194B97),
                  child: ListView.builder(
                    itemCount: context.read<BluetoothModule>().deviceInfo.length,
                    itemBuilder: (context, index) {
                      final mac   = context.read<BluetoothModule>().deviceInfo.keys.elementAt(index);
                      return DeviceListItem(value: context.read<BluetoothModule>().deviceInfo[mac]!, onDeviceTap: () => widget.onDeviceTap(mac));
                    } 
                  ),
                ),
              ),
            ),
        ),)
      )
    );
  }
}
