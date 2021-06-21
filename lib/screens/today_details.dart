import 'package:flutter/material.dart';
import 'package:weather/data/weather.dart';
import 'dart:convert';

class CurrentDetails extends StatefulWidget {
  String message;

  CurrentDetails(this.message);

  @override
  _CurrentDetailsState createState() => _CurrentDetailsState(message);
}

class _CurrentDetailsState extends State<CurrentDetails> {
  late Weather weather;
  String message;
  var jsonWeatherMap;

  // TextEditingController nameController = TextEditingController();
  // TextEditingController mainController = TextEditingController();
  // TextEditingController descriptionController = TextEditingController();
  // TextEditingController temperatureController = TextEditingController();

  _CurrentDetailsState(this.message) {
    jsonWeatherMap = jsonDecode(message);
  }

  @override
  Widget build(BuildContext context) {
    final sizeX = MediaQuery.of(context).size.width;
    final sizeY = MediaQuery.of(context).size.height;
    weather = Weather.fromJsonMap(jsonWeatherMap);

    String name = weather.name;
    double temperature = weather.temperature['temp'];
    String main = weather.main;
    String description = weather.description;

    TextStyle textStyle = TextStyle(fontSize: 18);
    TextStyle tempStyle = TextStyle(fontSize: 30);

    return Scaffold(
        appBar: AppBar(
          title: Text(name),
        ),
        body: SingleChildScrollView(
            child: Container(
          width: sizeX,
          height: sizeY,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(name, style: textStyle),
              Text(
                temperature.toString(),
                style: tempStyle,
              ),
              Text(
                main,
                style: textStyle,
              ),
              Text(
                description,
                style: textStyle,
              )
            ],
          ),
        )));
  }
}
