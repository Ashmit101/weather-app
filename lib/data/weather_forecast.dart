import 'weather.dart';
import 'daily_weather.dart';
import 'hourly_weather.dart';

class WeatherForecast {
  Weather currentWeather;
  List<DailyWeather> dailyWeather;
  List<HourlyWeather> hourlyWeather;
  int timeshift;

  WeatherForecast(Map<String, dynamic> weatherMap)
      : currentWeather = Weather.fromJsonMap(
          weatherMap['current'],
        ),
        hourlyWeather = HourlyWeather.getHourlyList(weatherMap['hourly']),
        dailyWeather = DailyWeather.getDailyList(weatherMap['daily']),
        timeshift = weatherMap['timezone_offset'];
}
