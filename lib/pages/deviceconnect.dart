import 'package:flutter/material.dart';
import '../bluetooth/devicesearch.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceConnectPage extends StatelessWidget {
  const DeviceConnectPage({super.key});

  Future<void> getSavedDevices() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();


    final List<String>? items = prefs.getStringList('items');
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

          ElevatedButton(
            child: const Text(
              'Add another device',
              style: TextStyle(fontSize: 20.0),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DeviceSearchPage()),
              );
            },
          ),
        ],
      )),
    );
  }
}
