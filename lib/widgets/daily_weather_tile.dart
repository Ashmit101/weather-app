import 'package:flutter/material.dart';
import 'package:weather/data/daily_weather.dart';
import '../data/data.dart';
import '../tools/dateformatting.dart';
import '../data/units.dart';

class DailyWeatherTile extends StatelessWidget {
  final DailyWeather dailyWeather;
  final int offset;
  final int unitId;
  const DailyWeatherTile(this.dailyWeather, this.offset, this.unitId,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Units units = Units();
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              Format.getWeekDay(Constants.getDateTimeFromUTC(
                  dailyWeather.time as int, offset)),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Image.network(
                Constants.getIcon(dailyWeather.weatherIcon!).toString()),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '${dailyWeather.temp['day']}${units.getTempUnit(unitId)}',
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
