import 'package:flutter_blue_v4/pages/vehicleProfile.dart';
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

  Future<List> loadVehicleData(vehicle) async {
    //final Vehicle vehicle;

    //final vehicle;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? vehiclesString = prefs.getString('Vehicle List');

    //this random vehicle variable might not have this method because some values may be null? IDK. THIS IS KINDA WEIRD.
    final List vehicles = vehicle.decode(vehiclesString!);

    return vehicles;

  }

  void saveVehicleData(vehicle) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    List vehicleList = await loadVehicleData(vehicle);

    vehicleList.add(vehicle);

    final String encodedData = vehicle.encode(vehicleList);

    await prefs.setString('Vehicle List', encodedData);

  }

}