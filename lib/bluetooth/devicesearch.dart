import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

FlutterBluePlus flutterBlue = FlutterBluePlus.instance;


class DeviceSearchPage extends StatefulWidget {
  const DeviceSearchPage({super.key});

  @override
  State<DeviceSearchPage> createState() => _DeviceSearchPageState();
}

class _DeviceSearchPageState extends State<DeviceSearchPage> {
  List<ScanResult>? allFoundDevices;
  List<String>? allConnectedDeviceNames;
  List<bool>? deviceConnectedList = [];

  void findDevices() {
    allFoundDevices = null;
    flutterBlue.startScan(timeout: const Duration(seconds: 4));
    flutterBlue.scanResults.listen((bluetoothDevices) {
      setState(() {
        allFoundDevices = bluetoothDevices;
      });
    });
    flutterBlue.stopScan();
  }

  void toggleConnectedDevice(bool connectStatus) {
    print("Connection Status is: ");
    print(connectStatus.toString());
  }

  /*Future<void> saveConnectedDevice(String deviceName) async {
    final prefs = await SharedPreferences.getInstance();

    allConnectedDeviceNames!.add(deviceName); // only add device name to list if deviceName is not null

    await prefs.setStringList('SavedDevices', allConnectedDeviceNames);
  }*/

  // Need to connect to a device

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
        title: const Text("Device Connect"),
      ),
      body: Container(
          child: ListView.builder(
              itemCount: allFoundDevices?.length ?? 0,
              itemBuilder: (context, index) {
                return DeviceListTile(
                    deviceName: allFoundDevices![index].device.name,
                    deviceID: allFoundDevices![index].device.id.id,
                    onDeviceConnectedToggle: (toggleStatus) {
                      toggleConnectedDevice(toggleStatus);
                    });
              })),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          findDevices();
        },
        label: const Text('Search'),
        icon: const Icon(Icons.radar),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}


class DeviceListTile extends StatefulWidget {
  final String deviceName;
  final String deviceID;
  final ValueChanged<bool> onDeviceConnectedToggle;

  const DeviceListTile(
      {Key? key, required this.deviceName, required this.deviceID, required this.onDeviceConnectedToggle})
      : super(key: key);

  @override
  _DeviceListTileState createState() => new _DeviceListTileState();
}

class _DeviceListTileState extends State<DeviceListTile> {
  bool _v = false;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(widget.deviceName),
      subtitle: Text(widget.deviceID),
      value: _v,
      onChanged: (value) =>
          setState(() {
            _v = value;
            widget.onDeviceConnectedToggle(value);
          }),
    );
  }
}
