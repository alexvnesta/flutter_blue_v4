import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

FlutterBluePlus flutterBlue = FlutterBluePlus.instance;


// NEED TO CHECK TOGGLE IF DEVICE IS ALREADY CONNECTED TO PREVENT A REBUILD STATE ERROR??????

class DeviceSearchPage extends StatefulWidget {

  final ValueChanged<List<BluetoothDevice>> onConnectedDeviceChange;

  const DeviceSearchPage({Key? key, required this.onConnectedDeviceChange}) : super(key : key);

  @override
  State<DeviceSearchPage> createState() => _DeviceSearchPageState();
}

class _DeviceSearchPageState extends State<DeviceSearchPage> {
  List<ScanResult>? allFoundDevices;
  List<BluetoothDevice>? allConnecedDevices;
  List<String>? allConnectedDeviceNames;
  List<bool>? deviceConnectedList = [];

  void findDevices() {
    allFoundDevices = null;
    flutterBlue.startScan(timeout: const Duration(seconds: 4));
    flutterBlue.scanResults.listen((bluetoothDevices) {
      // THIS NEEDS TO BE CHECKED
      if (mounted) {
        setState(() {
          allFoundDevices = bluetoothDevices;
        });
      }
    });
    flutterBlue.stopScan();
  }

  void toggleConnectedDevice(bool connectStatus, BluetoothDevice device) async {
    print("Connection Status is: ");
    print(connectStatus.toString());

    List<BluetoothDevice> connectedDevices = await FlutterBluePlus.instance.connectedDevices;

    if (connectedDevices.contains(device)){
      await device.disconnect();
    }
    else {
      await device.connect();
      print("Successfully connected to ${device.name}");
      print("${device.name} id is ${device.id}");
      print("${device.name} type is ${device.type}");
    }


    // TODO:I NEED TO ACTUALLY POPULATE THIS LIST WITH A DEVICE OR ELSE THE PROGRAM WILL CRASH
    widget.onConnectedDeviceChange(connectedDevices);

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Device Connect"),
      ),
      body: ListView.builder(
          itemCount: allFoundDevices?.length ?? 0,
          itemBuilder: (context, index) {
            return DeviceListTile(
                deviceName: allFoundDevices![index].device.name,
                deviceID: allFoundDevices![index].device.id.id,
                onDeviceConnectedToggle: (toggleStatus) {
                  toggleConnectedDevice(toggleStatus, allFoundDevices![index].device);
                });
          }),
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
  _DeviceListTileState createState() => _DeviceListTileState();
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
