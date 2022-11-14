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

  final TextEditingController carName = TextEditingController();
  final TextEditingController alignmentName = TextEditingController();
  final TextEditingController frontCamberMin = TextEditingController();
  final TextEditingController frontCamberMax = TextEditingController();
  final TextEditingController frontCasterMin = TextEditingController();
  final TextEditingController frontCasterMax = TextEditingController();
  final TextEditingController frontToeMin = TextEditingController();
  final TextEditingController frontToeMax = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Form Validation Demo';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              MyCustomForm(
                  controller: carName,
                  label: "Vehicle Name",
                  hint: "BMW 335xi",
                  icon: Icons.speed,),

              MyCustomForm(
                  controller: alignmentName,
                  label: "Alignment Description",
                  hint: "Track day",
                  icon: Icons.speed,),
              MyCustomForm(
                  controller: frontCasterMin,
                  label: "Front Caster Min",
                  hint: "-1",
                  icon: Icons.speed),
              MyCustomForm(
                  controller: frontCasterMax,
                  label: "Front Caster Max",
                  hint: "1",
                  icon: Icons.speed),
              MyCustomForm(
                  controller: frontCamberMin,
                  label: "Front Camber Min",
                  hint: "-1",
                  icon: Icons.speed),

              MyCustomForm(
                  controller: frontCamberMax,
                  label: "Front Camber Min",
                  hint: "1",
                  icon: Icons.speed),

              MyCustomForm(
                  controller: frontToeMin,
                  label: "Front Toe Min",
                  hint: "-1",
                  icon: Icons.speed),

              MyCustomForm(
                  controller: frontToeMax,
                  label: "Front Toe Max",
                  hint: "-1",
                  icon: Icons.speed),


              ElevatedButton(
                  onPressed: () async {

                    if (_formKey.currentState!.validate()) {
                      print("THIS IS THE TEXT I EXTRACTED");

                      if (carName.text.isEmpty) {carName.text = Vehicle().carName;}
                      if (alignmentName.text.isEmpty) {alignmentName.text = Vehicle().alignmentName;}

                      _vehicle.carName = carName.text;
                      _vehicle.alignmentName = alignmentName.text;
                      _vehicle.frontCamberMin = int.tryParse(frontCamberMin.text) ?? 0;
                      _vehicle.frontCamberMax = int.tryParse(frontCamberMax.text) ?? 0;
                      _vehicle.frontCasterMax = int.tryParse(frontCasterMax.text) ?? 0;
                      _vehicle.frontCasterMin = int.tryParse(frontCasterMin.text) ?? 0;
                      _vehicle.frontToeMax = int.tryParse(frontToeMax.text) ?? 0;
                      _vehicle.frontToeMin = int.tryParse(frontToeMin.text) ?? 0;
                    }

                    //Need to wait before callback
                    widget.onVehicleSubmitted(await saveLoad.saveVehicleData(_vehicle));
                    saveLoad.saveActiveAlignmentProfile(_vehicle);

                    setState(() {
                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    });

                  },
                  child: const Text("Save Alignment Profile"))
            ],
          ),
        ),
      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;

  MyCustomForm(
      {Key? key,
      this.label = "Vehicle Name",
      this.hint = "BMW 335xi",
      this.icon = Icons.person,
       required this.controller})
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
  //final _formKey = GlobalKey<FormState>();
  //final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: widget.key,
      child: TextFormField(
        decoration: InputDecoration(
          icon: Icon(widget.icon),
          hintText: widget.hint,
          labelText: widget.label,
        ),
        controller: widget.controller,
        // The validator receives the text that the user has entered.
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          } else {
            return null;
          }
        },
      ),
    );
  }
}
