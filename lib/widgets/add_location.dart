import 'package:flutter/material.dart';
import 'package:weather/tools/sembast_db.dart';
import '../tools/weather_downloader.dart';
import '../data/geolocation.dart';
import 'choose_coord.dart';

SembastDb sembastDb = SembastDb();

class AddLocation extends StatelessWidget {
  final String _title;
  final bool _changeLocation;

  const AddLocation(bool changeLocation,
      {String title = 'Add location', Key? key})
      : _changeLocation = changeLocation,
        _title = title,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();
    InputDecoration inputDecoration = InputDecoration();
    if (_title == 'Change Location') {
      inputDecoration = InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Location',
          hintText: 'Enter a name of a city');
    } else if (_title == 'Change API') {
      inputDecoration = InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'API',
          hintText: 'Enter your API key of OpenWeatherMap');
    }

    return AlertDialog(
      title: Text(_title),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: textController,
              decoration: inputDecoration,
            ),
            ElevatedButton(
              onPressed: () {
                if (_title == 'Change Location') {
                  submitLocation(context, textController);
                } else if (_title == 'Change API') {
                  submitAPI(context, textController);
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  submitLocation(BuildContext context,
      TextEditingController locationTextController) async {
    String location = locationTextController.text;
    //Get locations from the written name
    List<GeoLocation> geoLocations =
        await DownloadWeather.downloadLocationCoords(location);
    //Show the geoLocations to the user
    var chosenLocation = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return ChooseCoord.fromGeoList(geoLocations);
        });
    //Save the location according to the context
    if (chosenLocation != null) {
      if (_changeLocation) {
        var result = await sembastDb.addLocation(chosenLocation);
        Navigator.pop(context, chosenLocation);
      }
    }
  }

  void submitAPI(
      BuildContext context, TextEditingController textController) async {
    String api = textController.text;
    int id = await sembastDb.addApiKey(api);
    if (id >= 0) {
      Navigator.pop(context);
    }
  }
}
