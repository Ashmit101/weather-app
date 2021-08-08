import 'package:flutter/material.dart';
import 'package:weather/data/data.dart';
import 'package:weather/data/hourly_weather.dart';
import '../tools/dateformatting.dart';
import '../data/units.dart';

class HourlyWeatherTile extends StatelessWidget {
  final HourlyWeather hourlyWeather;

  const HourlyWeatherTile(this.hourlyWeather, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Units units = Units();
    return Card(
      margin: EdgeInsets.all(8),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(Format.getHourMinute(
                  Constants.getDateTimeFromUTC(hourlyWeather.time.toString()))),
              Image.network(
                Constants.getIcon(hourlyWeather.weatherIcon!).toString(),
                scale: 2,
              ),
              Text('${hourlyWeather.temp}${units.getTempUnit()}')
            ],
          ),
        ),
      ),
    );
  }
}
