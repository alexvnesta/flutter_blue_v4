import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';


class LiveDataPage extends StatefulWidget {
  const LiveDataPage({super.key});

  @override
  State<LiveDataPage> createState() => _LiveDataPageState();
}

class _LiveDataPageState extends State<LiveDataPage> {

  Future<List<BluetoothCharacteristic>> _getCharacteristics(
      BluetoothDevice device,) async {
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Live Gyro Readout"),
      ),
      body: Center(
        child: Text('Live Data Goes here'),
      ),
    );
  }
}


