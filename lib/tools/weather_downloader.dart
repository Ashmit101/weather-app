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
      print('$statusCode : Weather data successfully downloaded');
    } else {
      print('$statusCode : Failure downloading weather data');
    }
    Map<String, dynamic> weatherMap = jsonDecode(response.body);
    weatherMap['current']['location'] = location.name;
    weatherMap['unit'] = unitId;
    return weatherMap;
  }

  static Future<List<GeoLocation>> downloadLocationCoords(
      String cityName) async {
    List<GeoLocation> geoLocations = <GeoLocation>[];
    var response = await http
        .get(Constants.getCoordFromLocation(cityName,
            api: await sembastDb.getApi()))
        .catchError((error) {
      print('Downloading error: $error');
    });
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

  static Future downloadLocationNameFromCoord(double lat, double lon) async {
    var response = await http.get(Constants.getLocationFromCoord(lat, lon));
    print(response.body);
    List<dynamic> responseList = jsonDecode(response.body);
    return responseList;
  }
}
