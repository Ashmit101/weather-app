import '../data/data.dart';
import 'package:http/http.dart' as http;

class DownloadWeather {
  static Future downloadWeatherJsonWithName(String location) async {
    //Get http response
    var response = await http.get(Uri.parse(
        "http://api.openweathermap.org/data/2.5/weather?q=$location&appid=${API.apiKey}"));
    print('Status code : ${response.statusCode}');
    return response;
  }
}
