import 'package:flutter/material.dart';
import '../bluetooth/devicesearch.dart';
import '../extra/saveLoad.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_blue_plus/gen/flutterblueplus.pb.dart'
    as ProtoBluetoothDevice;

class DeviceConnectPage extends StatefulWidget {
  const DeviceConnectPage({super.key});

  @override
  State<DeviceConnectPage> createState() => _DeviceConnectPageState();
}

class _DeviceConnectPageState extends State<DeviceConnectPage> {
  List<BluetoothDevice>? connectedDevicesList;
  List<String> savedDeviceMacAddresses = [];
  SaveLoad saveLoad = SaveLoad();


  Future<void> saveConnectedDevices(List<BluetoothDevice> deviceList) async {
    for (BluetoothDevice device in deviceList) {
      print(device.id.id.toString());
      savedDeviceMacAddresses.add(device.id.id.toString());
    }
    saveLoad.saveData(savedDeviceMacAddresses, "Bluetooth Devices");
    savedDeviceMacAddresses = (await saveLoad.getData("Bluetooth Devices"))!;
    for (String deviceID in savedDeviceMacAddresses) {
      print("Successfully saved $deviceID");
    }
  }

  void reconnectSavedDevices() async {
    List<String>? savedBTDevicesIDs = await saveLoad.getData("Bluetooth Devices");
    for (var deviceID in savedBTDevicesIDs!) {
      print("going to connect to device $deviceID");
      var protoBt = ProtoBluetoothDevice.BluetoothDevice(remoteId: deviceID);
      late var d = BluetoothDevice.fromProto(protoBt);
      await d.connect();
    }
  }

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
                          List<BluetoothDevice> connectedDevices =
                              await FlutterBluePlus.instance.connectedDevices;
                          connectedDevicesList = connectedDevices;
                          setState(() {});
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
                        onConnectedDeviceChange:
                            (listOfConnectedDevices) async {
                      print(
                          "The connected devices list changed, re-checking list of connected devices");
                      List<BluetoothDevice> connectedDevices =
                          await FlutterBluePlus.instance.connectedDevices;
                      connectedDevicesList = connectedDevices;
                      setState(() {
                        print("Updating UI with connected devices");
                      });
                    }),
                  ),
                );
              },
            ),
            ElevatedButton(
                onPressed: () {
                  print("saving devices to storage!");
                  saveConnectedDevices(connectedDevicesList!);
                  //saveData(savedDeviceMacAddresses, "Bluetooth Devices");
                },
                child: const Text(
                  'Save connected devices',
                  style: TextStyle(fontSize: 20.0),
                )),
            ElevatedButton(
                onPressed: () async {
                  reconnectSavedDevices();
                  connectedDevicesList =
                  await FlutterBluePlus.instance.connectedDevices;
                  print("READ DEVICES AND REFRESHING PAGE!");

                  setState(() {});
                },
                child: const Text(
                  'Connect to saved devices',
                  style: TextStyle(fontSize: 20.0),
                )),
            ElevatedButton(
                onPressed: () async {
                  //reconnectSavedDevices();
                  saveLoad.saveData([], "Bluetooth Devices");
                  //saveConnectedDevices([]);
                  setState(() {});
                },
                child: const Text(
                  'Clear all saved devices',
                  style: TextStyle(fontSize: 20.0),
                )),
          ],
        ),
      ),
    );
  }
}

class ConnectedDeviceListTile extends StatelessWidget {
  final BluetoothDevice device;
  final ValueChanged<bool> onDeviceDisconnect;

  void disconnectDevice(BluetoothDevice device) async {
    await device.disconnect();
    onDeviceDisconnect(true);
  }

  const ConnectedDeviceListTile(
      {Key? key, required this.device, required this.onDeviceDisconnect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(device.name),
      subtitle: Text(device.id.id),
      trailing: const Text("FORGET DEVICE",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18)),
      onTap: () => disconnectDevice(device),
    );
  }
}
