import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter/foundation.dart';

class GyroMCU {
  /*
  //Class Description
  The Gyro measures three values, X, Y, and Z.
  It is assigned an identifier that matches the bluetooth device.
  There should be one MCU per bluetooth device that is connected.
  There will be functions to obtain the X, Y and Z from the bluetooth characteristics of the BluetoothDevice.

  // Variables
  Calibration X, Y, Z.
  Measurement X, Y, Z.
  DeviceType
  DeviceWheel
  DeviceVersion
  DeviceBattery

  // Functions -
  //Update device values from bluetooth device.
  getDeviceXYZ
  getDeviceMetadata
  */

  String deviceType;
  String deviceWheel;
  int deviceVersion;
  double deviceBattery;
  double calibrationX;
  double calibrationY;
  double calibrationZ;
  double currentX;
  double currentY;
  double currentZ;
  List<BluetoothService> deviceServices;
  List<BluetoothCharacteristic> deviceCharacteristics;
  //BluetoothDevice bluetoothDevice;

  GyroMCU({
    this.deviceType = "",
    this.deviceWheel = "",
    this.deviceVersion = 0,
    this.deviceBattery = 0,
    this.calibrationX = 0,
    this.calibrationY = 0,
    this.calibrationZ = 0,
    this.currentX = 0,
    this.currentY = 0,
    this.currentZ = 0,
    this.deviceServices = const [],
    this.deviceCharacteristics = const []
  });

  void getDeviceXYZ() async {

  }

  void getDeviceMetadata() {}

  void setDeviceCalibration() {}

  void setActiveMeasurements() {}

  /*
  void getServiceCharacteristics(BluetoothService mcuService) async {
    // Reads all characteristics

    if (deviceCharacteristics.isNotEmpty) {
      var characteristics = mcuService.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        List<int> value = await c.read();

        final fourDigitUUID = characteristicUUID.substring(4, 8).toUpperCase();
        switch (fourDigitUUID) {
          case ("AA52"):
            {
              _setXval(_matchDevice(characteristicDevID), value);
              break;
            }
          case ("AA51"):
            {
              _setYval(_matchDevice(characteristicDevID), value);
              break;
            }
          case ("AA50"):
            {
              _setZval(_matchDevice(characteristicDevID), value);
              break;
            }
          case ("180F"):
            {
              _setBattval(_matchDevice(characteristicDevID), value);
              break;
            }
          default:
            {
              print("UNKNOWN CHAR ID!, cannot update MCU LIST!");
              break;
            }
        }


        print(value);
      }
    }
  }

   */

  void getDeviceServices(BluetoothDevice mcuDevice) async {
    if (deviceServices.isNotEmpty) {
      for (var service in deviceServices) {
        // do something with service
        if (deviceCharacteristics.isNotEmpty) {
          for (var characteristic in deviceCharacteristics) {
            //do something with characteristics
          }
        }
      }
    } else if (deviceServices.isEmpty) {
      debugPrint("Device list empty.");
      discoverServices(mcuDevice);
    } else {
      debugPrint("Issue with deviceServices");
    }
  }

  void discoverServices(BluetoothDevice mcuDevice) async {
    debugPrint("Discovering services.");
    deviceServices = await mcuDevice.discoverServices();
  }

  void discoverCharacteristics(List<BluetoothService> mcuService) async {
    final res = List<BluetoothCharacteristic>.empty(growable: true);
    for (var i = 0; i < mcuService.length; i++) {
      res.addAll(mcuService[i].characteristics);
      debugPrint(mcuService[i].characteristics.toString());
    }
  }
}

class AlignmentCalculations {

  GyroMCU? gyroMCU;

  /*
  // Class Description
  This class will contain the functions to perform any gyro math calculations/conversions.
  This class will take in a list of GyroMCU objects and perform calculations.

  //Variables
  List of bools - (4 t/f)
    1. Front Left
    2. Front Right
    3. Rear Left
    4. Rear Right

  //Functions
  calculateFrontCamber
  calculateFrontCaster
  calculateFrontToe


  calculateRearCamber
  calculateRearCaster
  calculateRearToe
   */

  double calculateFrontCamber(GyroMCU gyroMCU){

    gyroMCU.getDeviceXYZ();

    return 0;
  }

  double calculateFrontCaster(GyroMCU gyroMCU){

    gyroMCU.getDeviceXYZ();


    return 0;
  }

  double calculateFrontToe(GyroMCU gyroMCU){

    gyroMCU.getDeviceXYZ();


    return 0;
  }


}
