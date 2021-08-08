import 'package:weather/data/geolocation.dart';

import '../data/data.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class DownloadWeather {
  static Future<Map<String, dynamic>> downloadCurrentWeatherMap(
      GeoLocation location) async {
    //Get http response
    var response = await http.get(Constants.getCurrentWeather(location.name));
    var statusCode = response.statusCode;

    if (statusCode == 200) {
      print('$statusCode : Weather data successfully downloaded');
    } else {
      print('$statusCode : Failure downloading weather data');
    }

    Map<String, dynamic> weatherMap = jsonDecode(response.body);
    weatherMap['current']['location'] = location.name;
    return weatherMap;
  }

  static Future<Map<String, dynamic>> downloadWeatherJson(
      GeoLocation location) async {
    //Get http response
    var response =
        await http.get(Constants.oneCallApi(location.lat, location.lon));
    var statusCode = response.statusCode;

    if (statusCode == 200) {
      print('$statusCode : Weather data successfully downloaded');
    } else {
      print('$statusCode : Failure downloading weather data');
    }
    Map<String, dynamic> weatherMap = jsonDecode(response.body);
    weatherMap['current']['location'] = location.name;
    return weatherMap;
  }

  static Future<List<GeoLocation>> downloadLocationCoords(
      String cityName) async {
    List<GeoLocation> geoLocations = <GeoLocation>[];
    List<Map<String, dynamic>> geoLocationsMap = [];
    var response = await http.get(Constants.getCoordFromLocation(cityName));
    var statusCode = response.statusCode;
    if (statusCode != 200) {
      print('$statusCode : Failure downloading weather.');
    } else {
      print('$statusCode : Weather downloaded successfully.');
      List<dynamic> locationList = jsonDecode(response.body);
      locationList.forEach((geoLocationMap) {
        geoLocations.add(GeoLocation.fromJsonMap(geoLocationMap));
      });
      print('Number of locations: ${locationList.length}');
      if (geoLocations.length == locationList.length) {
        geoLocations.forEach((element) {
          print('${element.name}, ${element.country}');
        });
      }
    }
    return geoLocations;
  }

  // static Future<Weather> downlaodWeatherWithName(String cityName) async {
  //   http.Response response = await downloadWeatherJsonWithName(cityName);
  //   Map<String, dynamic> weatherMap = jsonDecode(response.body);
  //   return Weather.fromJsonMap(weatherMap);
  // }

  static Future downloadLocationNameFromCoord(double lat, double lon) async {
    var response = await http.get(Constants.getLocationFromCoord(lat, lon));
    print(response.body);
    List<dynamic> responseList = jsonDecode(response.body);
    return responseList;
  }
}
