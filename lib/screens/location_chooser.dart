import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather/screens/today_details.dart';
import '../data/data.dart';

class LocationChooser extends StatefulWidget {
  const LocationChooser({Key? key}) : super(key: key);

  @override
  _LocationChooserState createState() => _LocationChooserState();
}

class _LocationChooserState extends State<LocationChooser> {
  String weatherInfo = '';
  String city = '';
  TextEditingController locationTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle =
        ElevatedButton.styleFrom(textStyle: TextStyle(fontSize: 24));

    return Scaffold(
      appBar: AppBar(
        title: Text('Location'),
      ),
      body: Container(
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
              onPressed: () => printJson(context),
              child: Text('Submit'),
            ),
            Text(weatherInfo),
          ],
        ),
      ),
    );
  }

  printJson(BuildContext context) async {
    //Get http response
    city = locationTextController.text;
    String message;
    if (city.length > 1) {
      var response = await http.get(Uri.parse(
          "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${API.apiKey}"));
      message = response.body;
      print('Status code : ${response.statusCode}');
      if (response.statusCode == 200) {
        currentWeather(context, response.body);
      }
    } else {
      message = 'Please enter a city name';
    }
    setState(() {
      weatherInfo = message;
    });
  }
}

currentWeather(BuildContext context, String message) {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => CurrentDetails(message)));
}
