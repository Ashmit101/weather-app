import 'package:flutter/material.dart';
import 'package:weather/data/weather.dart';
import 'package:weather/widgets/location_insert_alert.dart';
import 'package:weather/widgets/location_tile.dart';

List<String>? locations;
List<Weather> _weather = <Weather>[];

class Locations extends StatefulWidget {
  const Locations({Key? key}) : super(key: key);

  @override
  _LocationsState createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  @override
  void initState() {
    _getSavedLocations();
    super.initState();
  }

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
        body: ListView.builder(
          itemCount: _weather.length,
          itemBuilder: (context, index) {
            return LocationTile(_weather[index]);
          },
        ));
  }

  addLocation() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return InsertLocation();
        });
  }

  void _getSavedLocations() async {
    var list = await sembastDb.getSideLocations();
    if (list == null) {
      print('The side locations is null');
    } else {
      print('Side location type: ${list.runtimeType}');
    }
  }
}
