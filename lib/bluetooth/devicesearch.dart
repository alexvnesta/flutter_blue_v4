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

  void findDevices() {
    flutterBlue.startScan(timeout: const Duration(seconds: 4));
    flutterBlue.scanResults.listen((results) {
      setState(() {
        allFoundDevices = results;
      });
    });
    flutterBlue.stopScan();
  }

  Future<void> saveConnectedDevice(String deviceName) async {
    final prefs = await SharedPreferences.getInstance();

    allConnectedDeviceNames!.add(deviceName); // only add device name to list if deviceName is not null

    await prefs.setStringList('SavedDevices', allConnectedDeviceNames);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Device Connect"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Text("Available Devices"),
            Expanded(
              child: SizedBox(
                height: 200.0,
                child: ListView.builder(
                  //itemCount: 1,
                  itemCount: allFoundDevices?.length ?? 0,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(allFoundDevices![index].device.name),
                      subtitle: Text(allFoundDevices![index].device.id.id),
                      leading: Icon(Icons.bluetooth),
                      trailing: const Text(
                        "CONNECT",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize:
                                16), // In the future, I can make this conditional - If in list of connected devices - disconnect text appears.
                      ),
                      //onTap: () => printWithDevice(scanResult![index].device),
                      //WHEN THE BUTTON IS TAPPED, WE WANT TO SAVE THE DEVICE TO THE LIST OF MARRIED DEVICES
                    );
                  },
                ),
              ),
            ),
            ElevatedButton(onPressed: () => findDevices(), child: Text("Scan"))
          ],
        ),
      ),
    );
  }
}
