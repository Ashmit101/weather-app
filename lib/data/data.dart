class Constants {
  static const String apiKey = '68d3784d0f6da71f53a458fc66562917';

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
  static Uri oneCallApi(double lat, double lon,
      {String unit = 'metric', String? api}) {
    if (api?.length == 0 || api == null) {
      api = apiKey;
    }
    var uri = Uri.parse(
        'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=minutely&appid=$api&units=$unit');
    return uri;
  }

  //Get location name from the coordinates
  static Uri getLocationFromCoord(double lat, double lon, {String? api}) {
    if (api?.length == 0 || api == null) {
      api = apiKey;
    }
    print('(Constants) API called : $api');
    var uri = Uri.parse(
        'http://api.openweathermap.org/geo/1.0/reverse?lat=$lat&lon=$lon&appid=$api');
    return uri;
  }

  //Get coordinates from the cityname
  static Uri getCoordFromLocation(String cityName, {String? api}) {
    if (api?.length == 0 || api == null) {
      api = apiKey;
    }
    print('(Constants) API called : $api');
    var uri = Uri.parse(
        'http://api.openweathermap.org/geo/1.0/direct?q=$cityName&limit=3&appid=$api');
    return uri;
  }

  //Get the condition of current weather
  static Uri getCurrentWeather(String cityName, {String? api}) {
    if (api?.length == 0 || api == null) {
      api = apiKey;
    }
    var uri = Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$api');
    return uri;
  }

  //Get the image for the weather condition
  static Uri getIcon(String icon) {
    var uri = Uri.parse('http://openweathermap.org/img/wn/$icon@2x.png');
    return uri;
  }

  //Get DateTime object from the Unix time from the weather
  static DateTime getDateTimeFromUTC(int utcTime, int offset) {
    var dateTime =
        DateTime.fromMillisecondsSinceEpoch(utcTime * 1000, isUtc: true);
    dateTime = dateTime.add(Duration(seconds: offset));
    return dateTime;
  }
}
