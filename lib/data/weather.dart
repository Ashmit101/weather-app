class Weather {
  String main;
  String description;
  String name;
  Map<String, dynamic> wind;
  Map<String, dynamic> temperature;
  num sunrise;
  num sunset;
  String icon;

  Weather(this.name, this.main, this.description, this.temperature, this.wind,
      this.sunrise, this.sunset, this.icon);

  Weather.fromJsonMap(Map<String, dynamic> weatherMap)
      : name = weatherMap['name'] as String,
        main = weatherMap['weather'][0]['main'] as String,
        description = weatherMap['weather'][0]['description'] as String,
        sunrise = weatherMap['sys']['sunrise'] as num,
        sunset = weatherMap['sys']['sunset'] as num,
        wind = weatherMap['wind'],
        temperature = weatherMap['main'],
        icon = weatherMap['weather'][0]['icon'];

  // var windMap = {
  //   'speed': weatherMap['wind']['speed'] as double,
  //   'deg': weatherMap['wind']['speed'] as int
  // };

  // var tempMap={
  //   'temp':weatherMap['main'][]
  // }

  @override
  String toString() {
    var weatherStr = '$name\n$main\n$description';
    return weatherStr;
  }
}
