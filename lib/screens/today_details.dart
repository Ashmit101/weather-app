import 'package:flutter/material.dart';
import 'package:weather/data/weather_object.dart';

class CurrentDetails extends StatefulWidget {
  const CurrentDetails({Key? key}) : super(key: key);

  @override
  _CurrentDetailsState createState() => _CurrentDetailsState();
}

class _CurrentDetailsState extends State<CurrentDetails> {
  Weather? weather;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather'),
      ),
      body: Column(
        children: [Text('City')],
      ),
    );
  }
}
