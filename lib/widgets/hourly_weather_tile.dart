import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:weather/data/data.dart';
import 'package:weather/data/hourly_weather.dart';
import '../tools/dateformatting.dart';
import '../data/units.dart';

class HourlyWeatherTile extends StatelessWidget {
  final HourlyWeather hourlyWeather;
  final int offset;
  final int unitId;

  const HourlyWeatherTile(this.hourlyWeather, this.offset, this.unitId,
      {Key? key})
      : super(key: key);

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
              Text(Format.getHourMinute(Constants.getDateTimeFromUTC(
                  hourlyWeather.time as int, offset))),
              Image(
                height: 50,
                width: 50,
                image: CachedNetworkImageProvider(
                    Constants.getIcon(hourlyWeather.weatherIcon!).toString()),
              ),
              Text('${hourlyWeather.temp}${units.getTempUnit(unitId)}')
            ],
          ),
        ),
      ),
    );
  }
}
