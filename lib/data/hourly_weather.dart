import 'weather.dart';

class HourlyWeather extends Weather {
  HourlyWeather.sup(
    String weatherMain,
    String weatherDescription,
    int weatherID,
    String weatherIcon,
    num time,
    num temp,
    num feelsLike,
    num pressure,
    num humidity,
    num dewPoint,
    num uvi,
    num clouds,
    num visibility,
    num windSpeed,
    int windDeg,
  ) : super(
          weatherMain,
          weatherDescription,
          weatherID,
          weatherIcon,
          time,
          temp,
          feelsLike,
          pressure,
          humidity,
          dewPoint,
          uvi,
          clouds,
          visibility,
          windSpeed,
          windDeg,
        );

  @override
  HourlyWeather.fromJsonMap(Map<String, dynamic> hourlyMap)
      : super.fromJsonMap(hourlyMap);

  static List<HourlyWeather> getHourlyList(List<dynamic> hourlyMap) {
    var hourlyList = <HourlyWeather>[];
    hourlyMap.forEach((weatherMap) {
      var hourlyWeather = HourlyWeather.fromJsonMap(weatherMap);
      hourlyList.add(hourlyWeather);
    });
    return hourlyList;
  }
}
