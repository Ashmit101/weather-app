import 'package:flutter/material.dart';
import 'package:weather/data/daily_weather.dart';
import 'package:weather/data/weather.dart';
import 'package:weather/data/weather_forecast.dart';
import 'package:weather/tools/weather_downloader.dart';
import 'package:weather/widgets/daily_weather_tile.dart';
import 'dart:convert';
import '../data/geolocation.dart';
import 'package:weather/screens/side_locatons.dart';
import '../data/data.dart';
import '../widgets/hourly_weather_tile.dart';
import '../data/units.dart';

//Constants, objects used all over
Units units = Units();

class CurrentDetails extends StatefulWidget {
  GeoLocation location;

  CurrentDetails(this.location);

  @override
  _CurrentDetailsState createState() => _CurrentDetailsState(location);
}

class _CurrentDetailsState extends State<CurrentDetails> {
  GeoLocation location;
  late Map<String, dynamic> weatherMap;
  String load = 'loading';

  // TextEditingController nameController = TextEditingController();
  // TextEditingController mainController = TextEditingController();
  // TextEditingController descriptionController = TextEditingController();
  // TextEditingController temperatureController = TextEditingController();

  _CurrentDetailsState(this.location);

  @override
  Widget build(BuildContext context) {
    Future<WeatherForecast> weatherForecast = downloadWeatherForecast(location);

    return FutureBuilder(
      builder: (context, snapshot) {
        //Check if future is resolved
        if (snapshot.connectionState == ConnectionState.done) {
          //If we got an error
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text(Constants.error),
              ),
              body: Center(child: Text('${snapshot.error} occured.')),
            );
          } else if (snapshot.hasData) {
            //If we got the data
            WeatherForecast weather = snapshot.data as WeatherForecast;
            return Scaffold(
              appBar: AppBar(
                title: Text(location.name),
              ),
              body: ListView(children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                          Constants.getIcon(weather.currentWeather.weatherIcon!)
                              .toString()),
                      Text(weather.currentWeather.weatherMain!),
                      Text(
                          '${weather.currentWeather.temp}${units.getTempUnit()}'),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(weather.currentWeather.windSpeed.toString()),
                            Text(weather.currentWeather.humidity.toString())
                          ]),
                    ]),
                Text('Today'),
                Container(
                  height: 100,
                  child: ListView.builder(
                    itemCount: weather.hourlyWeather.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      print('Printing $index hourly weather');
                      return HourlyWeatherTile(weather.hourlyWeather[index]);
                    },
                  ),
                ),
                Text('Coming week'),
                // ListView.builder(
                //     itemCount: weather.dailyWeather.length,
                //     itemBuilder: (BuildContext context, int index) {
                //       return DailyWeatherTile(weather.dailyWeather[index]);
                //     }),
                Column(
                  children: getDailes(weather.dailyWeather),
                ),
              ]),
            );
          }
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(Constants.downloading),
          ),
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      future: weatherForecast,
    );
  }

  Future<WeatherForecast> downloadWeatherForecast(GeoLocation location) async {
    weatherMap = await DownloadWeather.downloadWeatherJson(location);
    var weather = WeatherForecast(weatherMap);
    return weather;
  }

  getDailes(List<DailyWeather> dailyWeathers) {
    var dailyTiles = <DailyWeatherTile>[];
    dailyWeathers.forEach((dailyWeather) {
      dailyTiles.add(DailyWeatherTile(dailyWeather));
    });
    return dailyTiles;
  }
}

goToLocations(BuildContext context) {
  print('Pressed more locations');
  Navigator.push(context, MaterialPageRoute(builder: (context) => Locations()));
}
