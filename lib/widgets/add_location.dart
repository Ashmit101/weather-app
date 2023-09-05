import 'package:flutter/material.dart';
import 'package:weather/tools/sembast_db.dart';
import '../tools/weather_downloader.dart';
import '../data/geolocation.dart';
import 'choose_coord.dart';

SembastDb sembastDb = SembastDb();

class AddLocation extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();
    InputDecoration inputDecoration = InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Location',
        hintText: 'Enter a name of a city');

    return AlertDialog(
      title: Text('Add location'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: textController,
                decoration: inputDecoration,
                validator: (value) {
                  if (value != null) {
                    if (value.isEmpty) {
                      return "Enter the name of your location";
                    }
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    submitLocation(context, textController);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
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
    int id = await sembastDb.addLocation(chosenLocation);
    if (chosenLocation != null && id >= 0) {
      Navigator.pop(context, chosenLocation);
    }
  }
}
