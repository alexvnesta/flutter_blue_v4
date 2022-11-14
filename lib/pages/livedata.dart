import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'vehicleProfile.dart';
import '../extra/saveLoad.dart';
import '../microcontroller/mcu_class.dart';
import '../microcontroller/selectWheel.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_blue_plus/gen/flutterblueplus.pb.dart'
    as ProtoBluetoothDevice;

class LiveDataPage extends StatefulWidget {
  Vehicle vehicle;

  LiveDataPage({super.key, required this.vehicle});

  @override
  State<LiveDataPage> createState() => _LiveDataPageState();
}

class _LiveDataPageState extends State<LiveDataPage> {
  SaveLoad? saveLoad;
  List<GyroMCU> gyroList = [];

  //Vehicle? currentlyActiveVehicle = Vehicle();

  void buildMCUdeviceList() async {
    List<BluetoothDevice> connectedDevices =
        await FlutterBluePlus.instance.connectedDevices;
  }

  void setTheActiveVehicle() async {
    widget.vehicle = await saveLoad?.loadActiveAlignmentProfile() ?? Vehicle();
    print("Successfully loaded: ${widget.vehicle?.alignmentName}");
    setState(() {});
  }

  initState() {
    //setTheActiveVehicle();
    buildMCUdeviceList();
    setState(() {});
  }

  Future<List<BluetoothCharacteristic>> _getCharacteristics(
    BluetoothDevice device,
  ) async {
    await device.connect();
    final services = await device.discoverServices();
    final res = List<BluetoothCharacteristic>.empty(growable: true);
    for (var i = 0; i < services.length; i++) {
      res.addAll(services[i].characteristics);
      print(services[i].characteristics);
    }
    device.disconnect();
    return res;
  }

  @override
  Widget build(BuildContext context) {
    //setTheActiveVehicle();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Live Gyro Readout"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Spacer(),
                  Text(
                    widget.vehicle?.carName ?? Vehicle().carName,
                    style: CustomTextStyles.liveDataStyle_1,
                  ),
                  const Spacer(),
                  const Text(
                    " : ",
                    style: CustomTextStyles.liveDataStyle_1,
                  ),
                  const Spacer(),
                  Text(
                    widget.vehicle?.alignmentName ?? Vehicle().alignmentName,
                    style: CustomTextStyles.liveDataStyle_1,
                  ),
                  const Spacer()
                ],
              ),
              Row(
                children: const <Widget>[
                  Spacer(),
                  Text(
                    "FrontLeft",
                    style: CustomTextStyles.liveDataStyle_2,
                  ),
                  Spacer(),
                  Text(
                    "FrontRight",
                    style: CustomTextStyles.liveDataStyle_2,
                  ),
                  Spacer()
                ],
              ),
              const Divider(
                height: 20,
                thickness: 2,
                endIndent: 0,
                color: Colors.black,
              ),
              IntrinsicHeight(
                child: Row(
                  children: const <Widget>[
                    Spacer(),
                    Text(
                      "Target Value",
                      style: CustomTextStyles.liveDataStyle_2,
                    ),
                    Spacer(),
                    Text(
                      "Read Value",
                      style: CustomTextStyles.liveDataStyle_2,
                    ),
                    VerticalDivider(
                      width: 20,
                      thickness: 2,
                      indent: 0,
                      endIndent: 0,
                      color: Colors.black,
                    ),
                    Text(
                      "Target Value",
                      style: CustomTextStyles.liveDataStyle_2,
                    ),
                    Spacer(),
                    Text(
                      "Read Value",
                      style: CustomTextStyles.liveDataStyle_2,
                    ),
                    Spacer(),
                  ],
                ),
              ),
              const Divider(),
              MeasurementPane(
                  vehicle: widget.vehicle,
                  measurementType: "Camber",
              measuredValue: 4,), // Finish toe Camber and pass here
              MeasurementPane(
                vehicle: widget.vehicle,
                measurementType: "Caster",
                measuredValue: 4,  // Finish toe Caster and pass here
              ),
              MeasurementPane(
                vehicle: widget.vehicle,
                measurementType: "Toe",
                measuredValue: 4, // Finish toe calculation and pass here
              ),
            ],
          ),
        ));
  }
}

class CustomTextStyles {
  static const TextStyle liveDataStyle_1 = TextStyle(
    fontSize: 24,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle liveDataStyle_2 = TextStyle(
    fontSize: 16,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle liveDataStyle_3 = TextStyle(
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle liveDataStyle_4 = TextStyle(
    fontSize: 14,
    color: Colors.red,
    fontWeight: FontWeight.bold,
  );
}

class MeasurementPane extends StatefulWidget {
  Vehicle vehicle;
  String measurementType;
  double measuredValue;

  //MeasurementPane({Key? key, required this.vehicle}) : super(Key);

  MeasurementPane(
      {super.key,
      required this.vehicle,
      required this.measurementType,
      required this.measuredValue});

  @override
  State<MeasurementPane> createState() => _MeasurementPaneState();
}

class _MeasurementPaneState extends State<MeasurementPane> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            const Spacer(),
            Text(
              widget.measurementType,
              style: CustomTextStyles.liveDataStyle_2,
            ),
            const Spacer(),
            const Spacer(),
            Text(
              widget.measurementType,
              style: CustomTextStyles.liveDataStyle_2,
            ),
            const Spacer()
          ],
        ),
        Row(children: <Widget>[
          const Spacer(),
          Text(
            widget.vehicle?.frontCamberMin.toString() ??
                Vehicle().frontCamberMin.toString(),
            style: CustomTextStyles.liveDataStyle_3,
          ),
          Text(
            " : ",
            style: CustomTextStyles.liveDataStyle_3,
          ),
          Text(
            widget.vehicle?.frontCamberMax.toString() ??
                Vehicle().frontCamberMin.toString(),
            style: CustomTextStyles.liveDataStyle_3,
          ),
          const Spacer(),
          Text(
            widget.measuredValue.toString(),
            style: CustomTextStyles.liveDataStyle_4,
          ),
          // THE LIVE READING VALUE GOES HERE
          const Spacer(),
          const Spacer(),
          Text(
            widget.vehicle?.frontCamberMin.toString() ??
                Vehicle().frontCamberMin.toString(),
            style: CustomTextStyles.liveDataStyle_3,
          ),
          const Text(
            " : ",
            style: CustomTextStyles.liveDataStyle_3,
          ),
          Text(
            widget.vehicle?.frontCamberMax.toString() ??
                Vehicle().frontCamberMin.toString(),
            style: CustomTextStyles.liveDataStyle_3,
          ),
          const Spacer(),
          Text(
            widget.measuredValue.toString(),
            style: CustomTextStyles.liveDataStyle_4,
          ),
          // THE LIVE READING VALUE GOES HERE
          const Spacer(),
        ]),
      ],
    );
  }
}
