import 'package:shared_preferences/shared_preferences.dart';
import '../pages/vehicleProfile.dart';

class SaveLoad {


  void saveData(List<String> ids, String favId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setStringList(favId, ids);
  }

  Future<List<String>?> getData(favId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getStringList("Bluetooth Devices");
  }

  Future<List<Vehicle>> loadVehicleData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Vehicle> vehicles = [];
    // THIS IS A BIT OF A HACK. SINCE THERE IS NO SAVE HISTORY, WE NEED TO MAKE A DEFAULT VEHICLE LIST.
    final String vehiclesString = prefs.getString('VehicleList') ?? "";
    if(vehiclesString.isNotEmpty) {
      print("This is the string we got:");
      print(vehiclesString);
      vehicles = Vehicle.decode(vehiclesString) ?? [];
    } else if (vehiclesString.isEmpty){
      print("No vehicles to load.");
      vehicles = [];
    }
    else {
      print("Unknown issue when loading data:");
      vehicles = [];
    }
    return vehicles;
  }

  void saveAllCurrentVehicles(List<Vehicle> vehicles) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("About to save these vehicles");
    print(vehicles.toString());
    final String encodedData = Vehicle.encode(vehicles);
    print("THIS IS THE GENERATED STRING OBJECT");
    print(encodedData);
    await prefs.setString('VehicleList', encodedData);
  }


  Future<bool> saveVehicleData(Vehicle vehicleLocal) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("About to save this vehicle");
    print(vehicleLocal.carName);
    List<Vehicle> vehicleList = [];
    vehicleList = await loadVehicleData() ?? [];
    print("Loaded vehicle data");
    vehicleList.add(vehicleLocal);
    final String encodedData = Vehicle.encode(vehicleList);
    print("THIS IS THE GENERATED STRING OBJECT");
    print(encodedData);
    await prefs.setString('VehicleList', encodedData);
    return true;
  }

  void deleteSavedVehicles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Deleting saved vehicles");
    await prefs.setString('VehicleList', "");
  }

  void saveActiveAlignmentProfile(Vehicle vehicle) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Vehicle> singleVehicleList = [vehicle];
    final String encodedVehicle = Vehicle.encode(singleVehicleList);
    await prefs.setString('ActiveVehicle', encodedVehicle);
  }

  Future<Vehicle> loadActiveAlignmentProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Vehicle> vehicles = [];
    final String vehiclesString = prefs.getString('ActiveVehicle') ?? "";
    print("THIS IS THE ACTIVE VEHICLE STRING WE JUST LOADED ${vehiclesString}");
    if(vehiclesString.isNotEmpty) {
      print("This is the string we got:");
      print(vehiclesString);
      vehicles = Vehicle.decode(vehiclesString) ?? [];
    } else if (vehiclesString.isEmpty){
      print("No vehicles to load.");
      vehicles = [];
    }
    else {
      print("Unknown issue when loading data:");
      vehicles = [];
    }

    Vehicle justOneVehicle = vehicles[1];

    return justOneVehicle;

  }




}