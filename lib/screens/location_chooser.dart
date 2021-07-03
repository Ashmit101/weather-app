import 'dart:convert';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather/screens/today_details.dart';
import '../data/data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

TextEditingController locationTextController = TextEditingController();

class LocationChooser extends StatefulWidget {
  @override
  _LocationChooserState createState() => _LocationChooserState();
}

class _LocationChooserState extends State<LocationChooser> {
  String weatherInfo = '';
  String city = '';

  @override
  void initState() {
    getLocation(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle =
        ElevatedButton.styleFrom(textStyle: TextStyle(fontSize: 24));

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
                ElevatedButton(
                  style: buttonStyle,
                  onPressed: () => downloadWeatherJsonWithName(context),
                  child: Text('Submit'),
                ),
                ElevatedButton(
                  style: buttonStyle,
                  onPressed: () => getDeviceLocation(context),
                  child: Text('Use device location'),
                ),
              ],
            ),
          ),
        ));
  }
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
  downloadWeatherJsonWithCoord(context, currentPosition);
}

void getLocation(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedLocation = prefs.getString('location');
  downloadWeatherJsonWithName(context, savedLocation);
}

//Save location to the shared prefs
void saveLocation(String city) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('location', city);
}

gotoCurrentWeather(BuildContext context, String message) {
  SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => CurrentDetails(message)));
  });
}

downloadWeatherJsonWithName(BuildContext context,
    [String? savedLocation]) async {
  //Get http response
  String message;
  String cityName;
  if (savedLocation != null) {
    cityName = savedLocation;
  } else {
    cityName = locationTextController.text;
  }
  if (cityName.length > 1) {
    var response = await http.get(Uri.parse(
        "http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=${API.apiKey}"));
    message = response.body;
    print('Status code : ${response.statusCode}');
    if (response.statusCode == 200) {
      if (savedLocation == null) {
        //Save location for future
        saveLocation(cityName);
      }
      gotoCurrentWeather(context, message);
    }
  } else {
    message = 'Please enter a city name';
  }
}

downloadWeatherJsonWithCoord(BuildContext context, Position position) async {
  print('Downloading from device location');

  var lat = position.latitude;
  var lon = position.longitude;

  String message;

  var response = await http.get(Uri.parse(
      "http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=${API.apiKey}"));
  message = response.body;

  if (response.statusCode == 200) {
    var mappedWeather = jsonDecode(message);
    saveLocation(mappedWeather['name']);
    gotoCurrentWeather(context, message);
  } else {
    print(response.statusCode);
  }
}
