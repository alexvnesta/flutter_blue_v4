import 'package:flutter/material.dart';
import 'package:flutter_blue_v4/extra/saveLoad.dart';
import 'package:flutter_blue_v4/pages/livedata.dart';
import 'vehicleRegisterForm.dart';
import 'vehicleProfile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List? listOfVehicles;
  final vehicle = Vehicle();
  SaveLoad saveLoad = SaveLoad();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CLRacing Alignment Tool"),
      ),
      body: Center(
        child: Column(
          children: <Widget> [
            const Text('Welcome to the alignment app!'),
            const Icon(Icons.car_repair, color: Colors.red, size: 200),
            Expanded(
              child: SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                    itemCount: listOfVehicles?.length ?? 0,
                    itemBuilder: (context, index) {
                      return VehicleTile(title: listOfVehicles![index].carName, subtitle: listOfVehicles![index].alignmentName);
                    },
                  )),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print("ADD A NEW VEHICLE");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VehicleEntryForm(onVehicleSubmitted: (vehicleSubmittedTrue) {
                setState(() async {
                  print("REFRESHING ADDED VEHICLE");
                  listOfVehicles = await saveLoad.loadVehicleData(vehicle);
                });
              },),
            ),
          );
        },
        label: const Text('New Alignment Profile'),
        icon: const Icon(Icons.car_repair),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}

class VehicleTile extends StatefulWidget {

  String title;
  String subtitle;

  VehicleTile({Key? key, this.title = "VehicleTitle", this.subtitle = "alignmentTitle"}) : super(key: key);

  @override
  State<VehicleTile> createState() => _VehicleTileState();
}

class _VehicleTileState extends State<VehicleTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      subtitle: Text(widget.subtitle),
      trailing: const Text("Check alignment",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
      onTap: () => print("MOVE TO LIVE DATA SCREEN WITH THE PROPER SETTINGS"),
    );
  }
}
