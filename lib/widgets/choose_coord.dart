//Choose the location from different options downloaded from openweathermap
import 'package:flutter/material.dart';
import 'package:weather/data/geolocation.dart';

class ChooseCoord extends StatelessWidget {
  final List<GeoLocation> locations;

  ChooseCoord.fromGeoList(this.locations);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: Text('Choose location'),
        children: getSimpleDialogs(locations, context));
  }

  List<SimpleDialogOption> getSimpleDialogs(
      List<GeoLocation> locations, BuildContext context) {
    var dialogs = <SimpleDialogOption>[];
    locations.forEach((location) {
      dialogs.add(SimpleDialogOption(
        child: Text(location.toString()),
        onPressed: () => Navigator.pop(context, location),
      ));
    });
    return dialogs;
  }
}
