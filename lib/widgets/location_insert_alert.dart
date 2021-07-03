import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../tools/weather_downloader.dart';
import '../data/data.dart';

TextEditingController locationController = TextEditingController();

class AddLocation extends StatefulWidget {
  const AddLocation({Key? key}) : super(key: key);

  @override
  _AddLocationState createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
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
              getLocation();
              Navigator.pop(context);
            },
            child: Text('Add')),
      ],
      elevation: 24.0,
    );
  }
}

getLocation() async {
  String location = locationController.text;
  print('Location : $location');
  var response = await DownloadWeather.downloadWeatherJsonWithName(location);
  if (response.statusCode == 200) {
    addToSharedPrefs(location);
  }
}

//Add the location to the shared preferences
void addToSharedPrefs(String location) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  //Get the list of locations or create if null
  List<String>? locations =
      sp.getStringList(Strings.multipleLocationKey) ?? <String>[];
  //Add the location to the list
  locations.add(location);
  //Store the location to the shared prefs
  await sp.setStringList(Strings.multipleLocationKey, locations);
  print('$location added to the shared prefs');
}
