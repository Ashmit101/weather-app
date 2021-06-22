import 'package:flutter/material.dart';
import 'screens/location_chooser.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LocationChooser(),
    );
  }
}
