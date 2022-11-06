import 'package:flutter/material.dart';
import '../bluetooth/devicesearch.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_blue_plus/gen/flutterblueplus.pb.dart' as ProtoBluetoothDevice;



class DeviceConnectPage extends StatefulWidget {


  const DeviceConnectPage({super.key});

  @override
  State<DeviceConnectPage> createState() => _DeviceConnectPageState();
}

class _DeviceConnectPageState extends State<DeviceConnectPage> {
  List<BluetoothDevice>? connectedDevicesList;
  List<String> savedDeviceMacAddresses = [];



  void saveConnectedDevices(List<BluetoothDevice> deviceList){
    for (BluetoothDevice device in deviceList){
      print(device.id.id.toString());
      savedDeviceMacAddresses.add(device.id.id);
    }
    for (String deviceID in savedDeviceMacAddresses){
      print("Successfully saved $deviceID");
    }
  }



  void reconnectSavedDevices(List<String> savedDeviceIDs) async{

    for (var deviceID in savedDeviceIDs) {

      print("going to connect to device $deviceID");

      var protoBt = ProtoBluetoothDevice.BluetoothDevice(
          remoteId: deviceID
      );
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
                          setState(() {
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
                        onConnectedDeviceChange:
                            (listOfConnectedDevices) async {
                      print("The connected devices list changed, re-checking list of connected devices");
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
                onPressed: () async {
                  List<BluetoothDevice> connectedDevices =
                  await FlutterBluePlus.instance.connectedDevices;
                  connectedDevicesList = connectedDevices;
                  print("saving devices to storage!");
                  saveConnectedDevices(connectedDevicesList!);

                },
                child: const Text(
                  'Save connected devices',
                  style: TextStyle(fontSize: 20.0),
                )),
            ElevatedButton(
                onPressed: () async {
                  reconnectSavedDevices(savedDeviceMacAddresses);
                  connectedDevicesList =
                      await FlutterBluePlus.instance.connectedDevices;
                  print("READ DEVICES AND REFRESHING PAGE!");

                  setState(()   {

                  });
                },
                child: const Text(
                  'Connect to saved devices',
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





/*
final filename = "local_user";
final file = File('${(await getApplicationDocumentsDirectory()).path}/$filename.json');
file.writeAsString(json.encode(user.toJson()));
User.fromJson(file.readAsString());
 */
