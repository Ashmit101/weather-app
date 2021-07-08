// import 'dart:html';

import 'package:flutter/material.dart';
// import '../tools/weather_downloader.dart';
import '../data/weather.dart';

Weather? _weather;

class LocationTile extends StatefulWidget {
  LocationTile(weather) {
    _weather = weather;
    print(weather.name);
  }

  @override
  _LocationTileState createState() => _LocationTileState();
}

class _LocationTileState extends State<LocationTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(_weather!.name),
        leading: Image.network(
            "http://openweathermap.org/img/wn/${_weather!.icon}@2x.png"),
        subtitle: Text(_weather!.main),
      ),
    );
  }
}

  // void getWeather(String city) async {
  //   Weather weather = await DownloadWeather.downlaodWeatherWithName(city);
  //   _weather = weather;
  // }

