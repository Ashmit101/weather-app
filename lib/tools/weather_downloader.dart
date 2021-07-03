import '../data/data.dart';
import 'package:http/http.dart' as http;
import '../data/weather.dart';
import 'dart:convert';

class DownloadWeather {
  static Future<http.Response> downloadWeatherJsonWithName(
      String location) async {
    //Get http response
    var response = await http.get(Uri.parse(
        "http://api.openweathermap.org/data/2.5/weather?q=$location&appid=${API.apiKey}"));
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      print('$statusCode : Weather data successfully downloaded');
    } else {
      print('$statusCode : Failure downloading weather data');
    }
    return response;
  }

  static Future<Weather> downlaodWeatherWithName(String cityName) async {
    http.Response response = await downloadWeatherJsonWithName(cityName);
    Map<String, dynamic> weatherMap = jsonDecode(response.body);
    return Weather.fromJsonMap(weatherMap);
  }
}
