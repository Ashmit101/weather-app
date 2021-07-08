import '../data/data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DownloadWeather {
  static Future<Map<String, dynamic>> downloadWeatherJson() async {
    //Get http response
    var response = await http.get(Strings.oneCallApi(27.700769, 85.300140));
    var statusCode = response.statusCode;
    if (statusCode == 200) {
      print('$statusCode : Weather data successfully downloaded');
    } else {
      print('$statusCode : Failure downloading weather data');
    }
    Map<String, dynamic> weatherMap = jsonDecode(response.body);
    return weatherMap;
  }

  // static Future<Weather> downlaodWeatherWithName(String cityName) async {
  //   http.Response response = await downloadWeatherJsonWithName(cityName);
  //   Map<String, dynamic> weatherMap = jsonDecode(response.body);
  //   return Weather.fromJsonMap(weatherMap);
  // }
}
