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
  List<Vehicle> listOfVehicles = [];
  SaveLoad saveLoad = SaveLoad();

  void loadVehicleData() async {
    listOfVehicles = await saveLoad.loadVehicleData() ?? [];
  }

  initState() {
    loadVehicleData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //initialVehicleLoad();
    return Scaffold(
      appBar: AppBar(
        title: const Text("CLRacing Alignment Tool"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const Text('Welcome to the alignment app!'),
            const Icon(Icons.car_repair, color: Colors.red, size: 200),
            ElevatedButton(
                onPressed: () {
                  saveLoad.deleteSavedVehicles();
                  listOfVehicles = [];
                  setState(() {});
                },
                child: Text("DELETE SAVED PROFILES")),
            ElevatedButton(
                onPressed: () async {
                  listOfVehicles = await saveLoad.loadVehicleData() ?? [];
                  setState(() {});
                },
                child: Text("LOAD SAVED PROFILES")),
            Expanded(
              child: ListView.builder(
                itemCount: listOfVehicles.length ?? 0,
                itemBuilder: (context, index) {
                  return Dismissible(
                      key: ValueKey<Vehicle>(listOfVehicles[index]),
                      background: Container(
                        color: Colors.red,
                        child: const Icon(Icons.cancel),
                      ),
                      child: VehicleTile(
                          title: listOfVehicles[index].carName,
                          subtitle: listOfVehicles[index].alignmentName,
                          vehicle: listOfVehicles[index]),
                      onDismissed: (dismissDirection) {
                        setState(() {
                          listOfVehicles.removeAt(index);
                          saveLoad.saveAllCurrentVehicles(listOfVehicles);
                        });
                      });
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VehicleEntryForm(
                onVehicleSubmitted: (vehicleSubmittedTrue) async {
                  listOfVehicles = await saveLoad.loadVehicleData() ?? [];
                  print(listOfVehicles.toString());
                  setState(() {});
                },
              ),
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
  Vehicle vehicle;

  VehicleTile(
      {Key? key,
      this.title = "VehicleTitle",
      this.subtitle = "alignmentTitle",
      required this.vehicle})
      : super(key: key);

  @override
  State<VehicleTile> createState() => _VehicleTileState();
}

class _VehicleTileState extends State<VehicleTile> {

  SaveLoad? saveLoad;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      subtitle: Text(widget.subtitle),
      trailing: const Text("Check alignment",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
      onTap: () {

        //saveLoad?.saveActiveAlignmentProfile(widget.vehicle);
        //print("Loading live data with: ${widget.vehicle.carName}");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                LiveDataPage(
                  vehicle: widget.vehicle,
                ),
          ),
        );
      }
    );
  }
}
