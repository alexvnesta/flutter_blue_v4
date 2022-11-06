import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CLRacing Alignment Tool"),
      ),
      body: Center(
        child: Column(
          children: const [
            Text('Welcome to the alignment app!'),
            Icon(Icons.car_repair, color: Colors.red, size: 200),
            VehicleTile(),
            VehicleTile(),
            VehicleTile(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print("ADD A NEW VEHICLE");
        },
        label: const Text('New Alignment Profile'),
        icon: const Icon(Icons.car_repair),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}

class VehicleTile extends StatelessWidget{

  const VehicleTile(
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("My Vehicle"),
      subtitle: const Text("Track day alignment"),
      trailing: const Text("Check alignment", style: TextStyle(fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 18)),
      onTap: () => print("MOVE TO LIVE DATA SCREEN WITH THE PROPER SETTINGS"),
    );
  }
}
