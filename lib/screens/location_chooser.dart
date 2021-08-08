import 'dart:convert';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather/data/geolocation.dart';
import 'package:weather/screens/today_details.dart';
import 'package:weather/tools/weather_downloader.dart';
import 'package:weather/widgets/choose_coord.dart';
import '../data/data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import '../tools/sembast_db.dart';

TextEditingController locationTextController = TextEditingController();
SembastDb sembastDb = SembastDb();

class LocationChooser extends StatefulWidget {
  LocationChooser() {
    print('location chooser constructor');
  }
  @override
  _LocationChooserState createState() {
    return _LocationChooserState();
  }
}

class _LocationChooserState extends State<LocationChooser> {
  String weatherInfo = '';
  String city = '';

  var _isProgressVisible = false;

  var _isDeviceLocationProgressVisible = false;

  @override
  Widget build(BuildContext context) {
    String message = 'Starting...';
    TextStyle messageStyle = TextStyle(
        color: Colors.white, fontSize: 12, decoration: TextDecoration.none);

    // print('Location chooser building');
    Future<List<GeoLocation>> savedLocations = getSavedLocation();
    final ButtonStyle buttonStyle =
        ElevatedButton.styleFrom(textStyle: TextStyle(fontSize: 24));

    return FutureBuilder(
        future: savedLocations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            //After resolving the future
            if (snapshot.hasData) {
              var savedLocation = snapshot.data as List<GeoLocation>;
              print('Object received');
              if (savedLocation.isEmpty) {
                return Scaffold(
                    appBar: AppBar(
                      title: Text('Location'),
                    ),
                    body: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.explore,
                              size: 50,
                            ),
                            Text("Search your location"),
                            TextField(
                              controller: locationTextController,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: buttonStyle,
                                  onPressed: () {
                                    String cityName =
                                        locationTextController.text;
                                    if (cityName != '') {
                                      setState(() {
                                        _isProgressVisible = true;
                                      });
                                      getLocationCoordinate(context, cityName);
                                    }
                                    //downloadWeatherJsonWithName(context);
                                  },
                                  child: Text('Submit'),
                                ),
                                Visibility(
                                  visible: _isProgressVisible,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                        height: 15,
                                        width: 15,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              style: buttonStyle,
                              onPressed: () {
                                setState(() {
                                  _isDeviceLocationProgressVisible = true;
                                });
                                return getDeviceLocation(context);
                              },
                              child: Text('Use device location'),
                            ),
                            Visibility(
                              visible: _isDeviceLocationProgressVisible,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                    height: 15,
                                    width: 15,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
              }
              gotoCurrentWeather(context, savedLocation[0]);
            }
          }
          //While waiting
          return Scaffold(
            appBar: AppBar(
              title: Text('Weather'),
            ),
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FlutterLogo(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                  Text(
                    message,
                    style: messageStyle,
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<List<GeoLocation>> getSavedLocation() async {
    List<GeoLocation> savedLocation = await sembastDb.getLocation();
    return savedLocation;
  }
}

void getLocationCoordinate(BuildContext context, String cityName) async {
  List<GeoLocation> geoLocationList =
      await DownloadWeather.downloadLocationCoords(cityName);
  showDialogWithLocations(context, geoLocationList);
}

void showDialogWithLocations(
    BuildContext context, List<GeoLocation> geoLocations) async {
  //Location chosen by the user
  var chosenLocation = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ChooseCoord.fromGeoList(geoLocations);
      });
  print("Saving : ${chosenLocation.name}");
  int id = await sembastDb.addLocation(chosenLocation);
  print("${chosenLocation.name} saved with id $id");
  gotoCurrentWeather(context, chosenLocation);
}

getDeviceLocation(BuildContext context) async {
  print('Pressed auto locate');
  bool serviceEnabled;
  LocationPermission permission;

  //Test if location permission enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    //Location services are not enabled
    print('Location services are disabled');
    return;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied');
      return;
    }
  } else {
    print('Permission granted');
  }

  if (permission == LocationPermission.deniedForever) {
    print('Location permission denied. Unable to ask again.');
    return;
  } else {
    print('Permission granted - forever');
  }

  Position currentPosition = await Geolocator.getCurrentPosition();
  print(currentPosition);
  List<dynamic> locations = await DownloadWeather.downloadLocationNameFromCoord(
      currentPosition.latitude, currentPosition.longitude);
  var location = locations[0] as Map<String, dynamic>;
  print('List has ${locations.length} items');
  List<GeoLocation> geoLocationList =
      await DownloadWeather.downloadLocationCoords(
          location['local_names']['en']);
  showDialogWithLocations(context, geoLocationList);
}

gotoCurrentWeather(BuildContext context, GeoLocation location) {
  SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => CurrentDetails(location)));
  });
}
