import 'package:flutter/material.dart';
import 'package:flutter_blue_v4/pages/homepage.dart';
import 'vehicleProfile.dart';
import '../extra/saveLoad.dart';

class VehicleEntryForm extends StatefulWidget {
  final ValueChanged<bool> onVehicleSubmitted;

  const VehicleEntryForm({super.key, required this.onVehicleSubmitted});

  @override
  State<VehicleEntryForm> createState() => _VehicleEntryFormState();
}

class _VehicleEntryFormState extends State<VehicleEntryForm> {
  final _vehicle = Vehicle();
  SaveLoad saveLoad = SaveLoad();

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Form Validation Demo';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: Column(
          children: <Widget>[
            MyCustomForm(
                label: "Vehicle Name",
                hint: "BMW 335xi",
                icon: Icons.speed,
                onValueEntered: (String value) =>
                    setState(() => _vehicle.carName = value)),
            MyCustomForm(
                label: "Alignment Description",
                hint: "Track day",
                icon: Icons.speed,
                onValueEntered: (String value) =>
                    setState(() => _vehicle.alignmentName = value)),
            MyCustomForm(
                label: "Front Caster Min",
                hint: "-1",
                icon: Icons.speed,
                onValueEntered: (String value) {
                  int num = int.tryParse(value) ?? 0;
                  setState(() => _vehicle.frontCasterMin = num);
                }),
            MyCustomForm(
                label: "Front Caster Max",
                hint: "1",
                icon: Icons.speed,
                onValueEntered: (String value) {
                  int num = int.tryParse(value) ?? 0;
                  setState(() => _vehicle.frontCasterMax = num);
                }),
            MyCustomForm(
                label: "Front Camber Min",
                hint: "-1",
                icon: Icons.speed,
                onValueEntered: (String value) {
                  int num = int.tryParse(value) ?? 0;
                  setState(() => _vehicle.frontCamberMin = num);
                }),
            MyCustomForm(
                label: "Front Camber Min",
                hint: "1",
                icon: Icons.speed,
                onValueEntered: (String value) {
                  int num = int.tryParse(value) ?? 0;
                  setState(() => _vehicle.frontCamberMax = num);
                }),
            MyCustomForm(
                label: "Front Toe Min",
                hint: "-1",
                icon: Icons.speed,
                onValueEntered: (String value) {
                  int num = int.tryParse(value) ?? 0;
                  setState(() => _vehicle.frontCasterMin = num);
                }),
            MyCustomForm(
                label: "Front Toe Max",
                hint: "-1",
                icon: Icons.speed,
                onValueEntered: (String value) {
                  int num = int.tryParse(value) ?? 0;
                  setState(() => _vehicle.frontCasterMax = num);
                }),
            ElevatedButton(
                onPressed: () {
                  //saveLoad.saveVehicleData(_vehicle);
                  //widget.onVehicleSubmitted(true);
                  Navigator.pop(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
                child: const Text("Save Alignment Profile"))
          ],
        ),
      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final ValueChanged<String> onValueEntered;

  MyCustomForm(
      {Key? key,
      this.label = "Vehicle Name",
      this.hint = "BMW 335xi",
      this.icon = Icons.person,
      required this.onValueEntered})
      : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: TextFormField(
        decoration: InputDecoration(
          icon: Icon(widget.icon),
          hintText: widget.hint,
          labelText: widget.label,
        ),
        // The validator receives the text that the user has entered.
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
      ),
    );
  }
}
