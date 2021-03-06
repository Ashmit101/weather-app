import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/data/geolocation.dart';
import 'package:weather/tools/sembast_db.dart';

import '../data/data.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

SembastDb sembastDb = SembastDb();

class DownloadWeather {
  static Future<Map<String, dynamic>> downloadCurrentWeatherMap(
      GeoLocation location) async {
    //Get http response
    var response = await http.get(Constants.getCurrentWeather(location.name,
        api: await sembastDb.getApi()));
    var statusCode = response.statusCode;

    if (statusCode == 200) {
      print(
          '[weather_downloader.dart] $statusCode : Weather data successfully downloaded');
    } else {
      print(
          '[weather_downloader.dart] $statusCode : Failure downloading weather data');
    }

    Map<String, dynamic> weatherMap = jsonDecode(response.body);
    weatherMap['current']['location'] = location.name;
    return weatherMap;
  }

  static Future<Map<String, dynamic>> downloadWeatherJson(
      GeoLocation location) async {
    //SharedPreference instance
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();

    //unit
    int unitId = _sharedPreferences.getInt('unit') ?? 0;
    String unitString = Constants.getUnitString(unitId);

    //Get http response
    var response = await http.get(Constants.oneCallApi(
        location.lat, location.lon,
        api: await sembastDb.getApi(), unit: unitString));
    var statusCode = response.statusCode;

    if (statusCode == 200) {
      print(
          '[weather_downloader.dart] $statusCode : Weather data successfully downloaded');
    } else {
      print(
          '[weather_downloader.dart] $statusCode : Failure downloading weather data');
      print('[weather_downloader.dart] $statusCode');
      if (statusCode == 401) {
        print('[weather_downloader.dart] Wrong API key');
        int id = await sembastDb.addApiKey(Constants.apiKey);
        if (id >= 0) {
          response = await http.get(Constants.oneCallApi(
              location.lat, location.lon,
              api: await sembastDb.getApi(), unit: unitString));
          statusCode = response.statusCode;
        }
      }
    }
    Map<String, dynamic> weatherMap = jsonDecode(response.body);
    weatherMap['current']['location'] = location.name;
    weatherMap['unit'] = unitId;
    return weatherMap;
  }

  static Future<dynamic> downloadLocationCoords(String cityName) async {
    print("[weather_downloader.dart] DownloadWeather: downloadLocationCoords");
    List<GeoLocation> geoLocations = <GeoLocation>[];
    var response = await http
        .get(Constants.getCoordFromLocation(cityName,
            api: await sembastDb.getApi()))
        .catchError((error) {
      print('[weather_downloader.dart] Downloading error: $error');
    });
    var statusCode = response.statusCode;
    if (statusCode != 200) {
      print(
          '[weather_downloader.dart] $statusCode : Failure downloading weather.');
      if (statusCode == 401) {
        print('[weather_downloader.dart] DownloadWeather: API might be wrong');
        return 401;
      }
    } else {
      print(
          '[weather_downloader.dart] $statusCode : Weather downloaded successfully.');
      List<dynamic> locationList = jsonDecode(response.body);
      locationList.forEach((geoLocationMap) {
        geoLocations.add(GeoLocation.fromJsonMap(geoLocationMap));
      });
      print(
          '[weather_downloader.dart] Number of locations: ${locationList.length}');
      if (geoLocations.length == locationList.length) {
        geoLocations.forEach((element) {
          print(
              '[weather_downloader.dart] ${element.name}, ${element.country}');
        });
      }
    }
    return geoLocations;
  }

  static Future downloadLocationNameFromCoord(double lat, double lon) async {
    var response = await http.get(Constants.getLocationFromCoord(lat, lon));
    print('[weather_downloader.dart] $response.body');
    List<dynamic> responseList = jsonDecode(response.body);
    return responseList;
  }

  static Future<bool> checkAPI(String apiKey) async {
    var response =
        await http.get(Constants.getCoordFromLocation('New York', api: apiKey));
    var statusCode = response.statusCode;
    if (statusCode == 401) {
      return false;
    } else {
      return true;
    }
  }
}
