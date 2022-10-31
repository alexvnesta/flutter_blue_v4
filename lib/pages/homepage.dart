import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CLRacing Alignment Tool"),
      ),
      body: Center(
        child: Column(
          children: const [
            Text('Welcome to the alignment app!'),
            Icon(Icons.car_repair, color: Colors.red, size: 200),
          ],
        ),
      ),
    );
  }
}
