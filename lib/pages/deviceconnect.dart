import 'package:flutter/material.dart';
import '../bluetooth/devicesearch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceConnectPage extends StatefulWidget {
  const DeviceConnectPage({super.key});

  @override
  State<DeviceConnectPage> createState() => _DeviceConnectPageState();
}

class _DeviceConnectPageState extends State<DeviceConnectPage> {
  Future<void> getSavedDevices() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    final List<String>? items = prefs.getStringList('items');
  }

  List<BluetoothDevice>? connectedDevicesList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Device Connect"),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          const Text('Current Connected Devices:'),
          // Here we want to list all connected devices.
          Expanded(
            child: SizedBox(
                height: 200.0,
                child: ListView.builder(
                  itemCount: connectedDevicesList?.length ?? 0,
                  itemBuilder: (context, index) {
                    return ConnectedDeviceListTile(
                      device: connectedDevicesList![index],
                        onDeviceDisconnect: (valueChanged) async {
                          print("THESE ARE THE CONNECTEDDEVICES!!!");
                          List<BluetoothDevice> connectedDevices = await FlutterBluePlus.instance.connectedDevices;
                          connectedDevicesList = connectedDevices;
                          setState(() {
                            print("UPDATING CONNECTED DEVICE LIST TILES!");
                          });
                        },
                    );
                  },
                )),
          ),
          ElevatedButton(
            child: const Text(
              'Add another device',
              style: TextStyle(fontSize: 20.0),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeviceSearchPage(
                      onConnectedDeviceChange: (listOfConnectedDevices) async {
                        print("THESE ARE THE CONNECTEDDEVICES!!!");
                        List<BluetoothDevice> connectedDevices = await FlutterBluePlus.instance.connectedDevices;
                        connectedDevicesList = connectedDevices;
                        setState(() {
                          print("UPDATING CONNECTED DEVICE LIST TILES!");
                        });
                  }),
                ),
              );
            },
          ),
        ],
      )),
    );
  }
}

class ConnectedDeviceListTile extends StatelessWidget{
  final BluetoothDevice device;
  final ValueChanged<bool> onDeviceDisconnect;


  void disconnectDevice(BluetoothDevice device) async {
    await device.disconnect();
    onDeviceDisconnect(true);
  }

  const ConnectedDeviceListTile(
      {Key? key, required this.device,
        required this.onDeviceDisconnect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(device.name),
      subtitle: Text(device.id.id),
      trailing: const Text("FORGET DEVICE", style: TextStyle(fontWeight: FontWeight.bold,
    color: Colors.red,
          fontSize: 18)),
      onTap: () => disconnectDevice(device),
    );
  }
}

