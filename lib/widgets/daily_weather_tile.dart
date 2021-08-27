import 'package:flutter/material.dart';
import 'package:weather/data/daily_weather.dart';
import '../data/data.dart';
import '../tools/dateformatting.dart';
import '../data/units.dart';

class DailyWeatherTile extends StatelessWidget {
  final DailyWeather dailyWeather;
  final int offset;
  const DailyWeatherTile(this.dailyWeather, this.offset, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Units units = Units();
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(Format.getWeekDay(
              Constants.getDateTimeFromUTC(dailyWeather.time as int, offset))),
          Image.network(
              Constants.getIcon(dailyWeather.weatherIcon!).toString()),
          Text('${dailyWeather.temp['day']}${units.getTempUnit()}')
        ],
      ),
    );
  }
}
