import 'package:flutter/material.dart';

class LiveDataPage extends StatelessWidget {
  const LiveDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Live Gyro Readout"),
      ),
      body: Center(
        child: Text('Live Data Goes here'),
      ),
    );
  }
}
