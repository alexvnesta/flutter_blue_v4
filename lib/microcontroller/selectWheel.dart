import 'package:flutter/material.dart';
import 'mcu_class.dart';


class WheelSelection extends StatefulWidget{

  WheelSelection({Key? key}) : super(key: key);

  //GyroMCU? gyroMCU;

  @override
  _WheelSelectionState createState() => _WheelSelectionState();


}

class _WheelSelectionState extends State<WheelSelection> {

  final isSelected = <bool>[false, false, false, false];

  void setWheel (){

  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      color: Colors.black.withOpacity(0.60),
      selectedColor: Color(0xFF6200EE),
      selectedBorderColor: Color(0xFF6200EE),
      fillColor: Color(0xFF6200EE).withOpacity(0.08),
      splashColor: Color(0xFF6200EE).withOpacity(0.12),
      hoverColor: Color(0xFF6200EE).withOpacity(0.04),
      borderRadius: BorderRadius.circular(4.0),
      constraints: BoxConstraints(minHeight: 36.0),
      isSelected: isSelected,
      onPressed: (index) {
        // Respond to button selection
        if (isSelected.contains(true)) {
          if (isSelected.where((item) => item == true).first ==
              isSelected[index]) {
            setState(() {
              //setWheel(widget.device.id.toString(), index);
              isSelected[index] = !isSelected[index];
            });
          } else {
            print("there is already a selected wheel, do nothing.");
          }
        } else {
          setState(() {
            print("selected tf:" + isSelected[index].toString());
            print("selected index:" + index.toString());
            //setWheel(widget.device.id.toString(), index);
            isSelected[index] = !isSelected[index];
          });
        }
      },
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Front Left'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Front Right'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Rear Left'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Rear Right'),
        ),
      ],
    );
  }
}






