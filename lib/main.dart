import 'package:flutter/material.dart';
import 'pages/deviceconnect.dart';
import 'pages/homepage.dart';
import 'pages/livedata.dart';
import 'pages/settings.dart';
import 'pages/vehicleProfile.dart';
import 'extra/saveLoad.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alignment Tool',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SaveLoad? saveLoad;

  int _selectedIndex = 0;

  Vehicle currentlySelectedVehicle = Vehicle();

  void setActiveProfile() async {
    currentlySelectedVehicle = await saveLoad?.loadActiveAlignmentProfile() ?? Vehicle();
  }

  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    //setActiveProfile();
    // WHENEVER THE HOMEPAGE IS REBUILT, get the currently selected vehicle.
  }

  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    LiveDataPage(vehicle: Vehicle()),
    const DeviceConnectPage(),
    //FunForm(),
    const SettingsPage(),
  ];

  void _onMenuSelection(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Live Data'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bluetooth), label: 'Device Connect'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onMenuSelection,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
