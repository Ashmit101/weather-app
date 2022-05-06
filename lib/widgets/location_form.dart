import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:weather/tools/weather_downloader.dart';
import 'package:weather/widgets/api_field.dart';

import '../data/geolocation.dart';
import '../screens/today_details.dart';
import 'choose_coord.dart';

TextEditingController locationTextController = TextEditingController();
TextEditingController apiTextController = TextEditingController();

class LocationForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LocationFormState();
  }
}

class LocationFormState extends State<LocationForm> {
  //GlobalKey that uniquely identifies the form
  final _locationFormKey = GlobalKey<FormState>();

  // Decorations
  TextStyle messageStyle = TextStyle(
      color: Colors.white, fontSize: 12, decoration: TextDecoration.none);
  final ButtonStyle buttonStyle =
      ElevatedButton.styleFrom(textStyle: TextStyle(fontSize: 24));
  InputDecoration locationInputDecoration = InputDecoration(
    isDense: true,
    border: OutlineInputBorder(),
    hintText: 'City Name',
  );
  InputDecoration apiInputDecoration = InputDecoration(
    isDense: true,
    border: OutlineInputBorder(),
    hintText: 'API Key (Optional)',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _locationFormKey,
          child: Column(
            children: [
              Icon(
                Icons.explore,
                size: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Search your location"),
              ),
              //Location name text field
              TextFormField(
                controller: locationTextController,
                decoration: locationInputDecoration,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Container(
                height: 8,
              ),
              APIInstruction(),
              //API text field
              TextFormField(
                controller: apiTextController,
                decoration: apiInputDecoration,
                validator: (value) {
                  if (value != null) {
                    if (value.length != 32 && value.length != 0) {
                      return 'API key should be 32 characters long';
                    }
                  }
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_locationFormKey.currentState!.validate()) {
                        String cityName = locationTextController.text;
                        String apiKey = apiTextController.text;

                        submit(context, cityName, apiKey);
                      }
                    },
                    child: const Text('Submit'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void submit(BuildContext context, String cityName, String apiKey) async {
    bool APICorrect = await DownloadWeather.checkAPI(apiKey);
    if (APICorrect) {
      await sembastDb.addApiKey(apiKey);
      getLocationCoordinate(context, cityName);
    }
  }

  void getLocationCoordinate(BuildContext context, String cityName) async {
    var geoLocationList =
        await DownloadWeather.downloadLocationCoords(cityName);
    showDialogWithLocations(context, geoLocationList);
  }

  void showDialogWithLocations(
      BuildContext context, List<GeoLocation> geoLocations) async {
    //Location chosen by the user
    var chosenLocation = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ChooseCoord.fromGeoList(geoLocations);
        });
    if (chosenLocation != null) {
      sembastDb.addLocation(chosenLocation);
      gotoCurrentWeather(context, chosenLocation);
    }
  }

  gotoCurrentWeather(BuildContext context, GeoLocation location) {
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => CurrentDetails(location)));
    });
  }
}
