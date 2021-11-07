class Weather {
  //Fields
  num time;
  num? sunrise;
  num? sunset;
  dynamic temp;
  dynamic feelsLike;
  num pressure;
  num humidity;
  num dewPoint;
  num uvi;
  num clouds;
  num? visibility;
  num windSpeed;
  int windDeg;
  int? weatherID;
  String? weatherMain;
  String? weatherDescription;
  String? weatherIcon;
  String? location;

  Weather(
      this.weatherMain,
      this.weatherDescription,
      this.weatherID,
      this.weatherIcon,
      this.time,
      this.temp,
      this.feelsLike,
      this.pressure,
      this.humidity,
      this.dewPoint,
      this.uvi,
      this.clouds,
      this.visibility,
      this.windSpeed,
      this.windDeg,
      [this.sunrise,
      this.sunset]);

  Weather.fromJsonMap(Map<String, dynamic> currentMap)
      : time = currentMap['dt'] as num,
        sunrise = currentMap['sunrise'],
        sunset = currentMap['sunset'],
        temp = currentMap['temp'],
        feelsLike = currentMap['feels_like'],
        pressure = currentMap['pressure'] as num,
        humidity = currentMap['humidity'] as num,
        dewPoint = currentMap['dew_point'] as num,
        clouds = currentMap['clouds'] as num,
        uvi = currentMap['uvi'] as num,
        visibility = currentMap['visibility'],
        windSpeed = currentMap['wind_speed'] as num,
        windDeg = currentMap['wind_deg'] as int,
        weatherID = currentMap['weather'][0]['id'] as int,
        weatherMain = currentMap['weather'][0]['main'] as String,
        weatherDescription = currentMap['weather'][0]['description'] as String,
        weatherIcon = currentMap['weather'][0]['icon'] as String,
        location = currentMap['location'];
}
