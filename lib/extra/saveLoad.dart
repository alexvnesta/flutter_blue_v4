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

    List<Vehicle> vehicles = [Vehicle()];

    // THIS IS A BIT OF A HACK. SINCE THERE IS NO SAVE HISTORY, WE NEED TO MAKE A DEFAULT VEHICLE LIST.
    final String vehiclesString = prefs.getString('VehicleList') ?? Vehicle.encode(vehicles);



    print("printing vehicles string");
    print(vehiclesString);


    vehicles = Vehicle.decode(vehiclesString!);

    return vehicles;

  }

  void saveVehicleData(Vehicle vehicleLocal) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    print("About to save this vehicle");
    print(vehicleLocal.carName);

    List<Vehicle> vehicleList = [];
    vehicleList = await loadVehicleData();

    print("Loaded vehicle data");

    vehicleList.add(vehicleLocal);

    final String encodedData = Vehicle.encode(vehicleList);

    await prefs.setString('VehicleList', encodedData);

  }

}