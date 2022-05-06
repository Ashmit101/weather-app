import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/tools/sembast_db.dart';
import 'package:weather/widgets/choose_coord.dart';
import '../tools/weather_downloader.dart';
import '../data/data.dart';

TextEditingController locationController = TextEditingController();
SembastDb sembastDb = SembastDb();

class InsertLocation extends StatefulWidget {
  const InsertLocation({Key? key}) : super(key: key);

  @override
  _InsertLocationState createState() => _InsertLocationState();
}

class _InsertLocationState extends State<InsertLocation> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add location'),
      content: Container(
        child: TextField(
          controller: locationController,
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text('Cancel')),
        TextButton(
            onPressed: () {
              getLocationFromUser(context);
              Navigator.pop(context);
            },
            child: Text('Add')),
      ],
      elevation: 24.0,
    );
  }
}

getLocationFromUser(BuildContext context) async {
  String location = locationController.text;
  print('[location_insert_alert.dart] Location : $location');
  //Download list of GeoLocations from the openweathermap
  var locationList = await DownloadWeather.downloadLocationCoords(location);
  //Make the user choose the location
  var chosenLocation = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ChooseCoord.fromGeoList(locationList);
      });
  //Now save the chosen location
  if (chosenLocation != null) {
    saveLocation(chosenLocation);
  }
}

void saveLocation(chosenLocation) async {
  int id = await sembastDb.addSideLocation(chosenLocation);
  print('[location_insert_alert.dart] Saved side location at : $id');
}

//Add the location to the shared preferences
void addToSharedPrefs(String location) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  //Get the list of locations or create if null
  List<String>? locations =
      sp.getStringList(Constants.multipleLocationKey) ?? <String>[];
  //Add the location to the list
  locations.add(location);
  //Store the location to the shared prefs
  await sp.setStringList(Constants.multipleLocationKey, locations);
  print('[location_insert_alert.dart] $location added to the shared prefs');
}
