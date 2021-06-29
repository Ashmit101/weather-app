import 'package:flutter/material.dart';
import 'package:weather/widgets/location_insert_alert.dart';

class Locations extends StatefulWidget {
  const Locations({Key? key}) : super(key: key);

  @override
  _LocationsState createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Locations'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => addLocation(),
          )
        ],
      ),
    );
  }

  addLocation() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddLocation();
        });
  }
}
