import 'weather.dart';

class DailyWeather extends Weather {
  num moonRise;
  num moonSet;
  num moonPhase;

  DailyWeather(
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
      this.moonRise,
      this.moonSet,
      this.moonPhase)
      : super(
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
            windDeg);

  DailyWeather.fromJsonMap(weatherMap)
      : moonSet = weatherMap['moonset'],
        moonRise = weatherMap['moonrise'],
        moonPhase = weatherMap['moon_phase'],
        super.fromJsonMap(weatherMap);

  static List<DailyWeather> getDailyList(dailyMap) {
    var dailyList = <DailyWeather>[];
    dailyMap.forEach((weatherMap) {
      var dailyWeather = DailyWeather.fromJsonMap(weatherMap);
      dailyList.add(dailyWeather);
    });
    //print('DailyWeather are for ${dailyList.length} days');
    //Remove today from the list
    dailyList.removeAt(0);
    return dailyList;
  }
}
