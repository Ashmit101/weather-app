class Constants {
  // static final String apiKey = '0cd1d9bfbf9969a81fc5105bf1239b9d';
  static final String apiKey = '68d3784d0f6da71f53a458fc66562917';

  //Common phrases
  static final String error = 'Error';
  static final String downloading = 'Downloading';

  //Sharedprefs keys
  static final String multipleLocationKey = 'locations';
  static final String currentLocationKey = 'current-location';

  //Units
  static final String imperial = 'imperial';
  static final String metric = 'metric';
  static final String standard = 'standard';

  //Return required api calls
  static Uri oneCallApi(double lat, double lon, {String unit = 'metric'}) {
    var uri = Uri.parse(
        'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=minutely&appid=$apiKey&units=$unit');
    return uri;
  }

  //Get location name from the coordinates
  static Uri getLocationFromCoord(double lat, double lon) {
    var uri = Uri.parse(
        'http://api.openweathermap.org/geo/1.0/reverse?lat=$lat&lon=$lon&appid=$apiKey');
    return uri;
  }

  //Get coordinates from the cityname
  static Uri getCoordFromLocation(String cityName) {
    var uri = Uri.parse(
        'http://api.openweathermap.org/geo/1.0/direct?q=$cityName&limit=3&appid=$apiKey');
    return uri;
  }

  //Get the condition of current weather
  static Uri getCurrentWeather(String cityName) {
    var uri = Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey');
    return uri;
  }

  //Get the image for the weather condition
  static Uri getIcon(String icon) {
    var uri = Uri.parse('http://openweathermap.org/img/wn/$icon@2x.png');
    return uri;
  }

  //Get DateTime object from the Unix time from the weather
  static DateTime getDateTimeFromUTC(String utcTime) {
    return DateTime.fromMillisecondsSinceEpoch(int.parse(utcTime) * 1000,
        isUtc: true);
  }
}
