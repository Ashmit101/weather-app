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
  Weather? weather;
  String message;
  var jsonWeatherMap;
  _CurrentDetailsState(this.message) {
    jsonWeatherMap = jsonDecode(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather'),
      ),
      body: Column(
        children: [Text(message)],
      ),
    );
  }
}
