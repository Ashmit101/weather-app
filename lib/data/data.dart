class Strings {
  // static final String apiKey = '0cd1d9bfbf9969a81fc5105bf1239b9d';
  static final String apiKey = '68d3784d0f6da71f53a458fc66562917';

  //Sharedprefs keys
  static final String multipleLocationKey = 'locations';
  static final String currentLocationKey = 'current-location';

  //Return required api calls
  static Uri oneCallApi(double lat, double lon) {
    var uri = Uri.parse(
        'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=minutely&appid=$apiKey');
    return uri;
  }

  static Uri getLocationFromCoord(double lat, double lon) {
    var uri = Uri.parse(
        'http://api.openweathermap.org/geo/1.0/reverse?lat=$lat&lon=$lon&appid=$apiKey');
    return uri;
  }

  static Uri getCoordFromLocation(String cityName) {
    var uri = Uri.parse(
        'http://api.openweathermap.org/geo/1.0/direct?q=$cityName&appid=$apiKey');
    return uri;
  }
}
