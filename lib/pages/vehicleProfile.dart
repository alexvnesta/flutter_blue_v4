import 'dart:convert';

//A nice alignment spec sheet is here
//https://www.e90post.com/forums/showthread.php?t=430360

class Vehicle {
  String carName, alignmentName;

  int frontCasterMin, frontCasterMax, frontCamberMin, frontCamberMax, frontToeMin, frontToeMax;

  Vehicle({
    this.carName = 'BMW',
    this.alignmentName = 'sample alignment',
    this.frontCasterMin = 9,
    this.frontCasterMax = 9,
    this.frontCamberMin = 9,
    this.frontCamberMax = 9,
    this.frontToeMin = 9,
    this.frontToeMax = 9
});

  factory Vehicle.fromJson(Map<String, dynamic> jsonData){
    return Vehicle(
        carName: jsonData['carName'],
        alignmentName: jsonData['alignmentName'],
        frontCasterMin: jsonData['frontCasterMin'],
        frontCasterMax: jsonData['frontCasterMax'],
        frontCamberMin: jsonData['frontCamberMin'],
        frontCamberMax: jsonData['frontCamberMax'],
        frontToeMin: jsonData['frontToeMin'],
        frontToeMax: jsonData['frontToeMax'],
    );
  }

  static Map<String, dynamic> toMap(Vehicle vehicle) => {
    'carName': vehicle.carName,
    'alignmentName': vehicle.alignmentName,
    'frontCasterMin': vehicle.frontCasterMin,
    'frontCasterMax': vehicle.frontCasterMax,
    'frontCamberMin': vehicle.frontCamberMin,
    'frontCamberMax': vehicle.frontCamberMax,
    'frontToeMin': vehicle.frontToeMin,
    'frontToeMax': vehicle.frontToeMax,
  };

  static String encode(List<Vehicle> vehicles) => json.encode(
    vehicles
        .map<Map<String, dynamic>>((vehicle) => Vehicle.toMap(vehicle))
        .toList(),

  );
  static List<Vehicle> decode(String vehicles) =>
      (json.decode(vehicles) as List<dynamic>)
          .map<Vehicle>((item) => Vehicle.fromJson(item))
          .toList();

}