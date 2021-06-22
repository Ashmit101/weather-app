import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather/screens/today_details.dart';
import '../data/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController locationTextController = TextEditingController();

class LocationChooser extends StatefulWidget {
  @override
  _LocationChooserState createState() => _LocationChooserState();
}

class _LocationChooserState extends State<LocationChooser> {
  String weatherInfo = '';
  String city = '';

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle =
        ElevatedButton.styleFrom(textStyle: TextStyle(fontSize: 24));
    getLocation(context);

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
                  onPressed: () => downloadWeatherJson(context),
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ));
  }
}

void getLocation(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedLocation = prefs.getString('location');
  downloadWeatherJson(context, savedLocation);
}

void saveLocation(String city) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('location', city);
}

gotoCurrentWeather(BuildContext context, String message) {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => CurrentDetails(message)));
}

downloadWeatherJson(BuildContext context, [String? savedLocation]) async {
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
        saveLocation(cityName);
      }
      gotoCurrentWeather(context, message);
    }
  } else {
    message = 'Please enter a city name';
  }
}
