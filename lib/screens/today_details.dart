import 'package:flutter/material.dart';
import 'package:weather/data/daily_weather.dart';
import 'package:weather/data/weather_forecast.dart';
import 'package:weather/screens/settings.dart';
import 'package:weather/tools/weather_downloader.dart';
import 'package:weather/widgets/daily_weather_tile.dart';
import '../data/geolocation.dart';
import '../data/data.dart';
import '../widgets/hourly_weather_tile.dart';
import '../data/units.dart';
import '../widgets/add_location.dart';

//Constants, objects used all over
Units units = Units();

class CurrentDetails extends StatefulWidget {
  final GeoLocation location;

  CurrentDetails(this.location);

  @override
  _CurrentDetailsState createState() => _CurrentDetailsState(location);
}

class _CurrentDetailsState extends State<CurrentDetails> {
  GeoLocation location;
  late Map<String, dynamic> weatherMap;
  String load = 'loading';
  late Future<WeatherForecast> weatherForecast;

  _CurrentDetailsState(this.location);

  @override
  void initState() {
    weatherForecast = downloadWeatherForecast(location);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

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
                actions: [
                  PopupMenuButton(
                    onSelected: (value) {
                      switch (value) {
                        case PopUpItem.changeLocation:
                          changeLocation(context);
                          break;
                        case PopUpItem.changeApi:
                          changeAPI(context);
                          break;
                        case PopUpItem.settings:
                          gotoSettings(context);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: PopUpItem.changeLocation,
                        child: Text('Change location'),
                      ),
                      PopupMenuItem(
                        value: PopUpItem.changeApi,
                        child: Text('Change API'),
                      ),
                      PopupMenuItem(
                          value: PopUpItem.settings, child: Text('Settings')),
                    ],
                  ),
                ],
              ),
              body: ListView(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                Constants.getIcon(
                                        weather.currentWeather.weatherIcon!)
                                    .toString(),
                                scale: 1.5,
                              ),
                              Text(
                                weather.currentWeather.weatherMain!,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${weather.currentWeather.temp.round()}${units.getTempUnit()}',
                          style: TextStyle(fontSize: 90),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.air),
                                    Text(
                                        '${weather.currentWeather.windSpeed}${units.getWindSpeedUnit()}'),
                                  ],
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image(
                                    image: AssetImage('graphics/humidity.png'),
                                  ),
                                  Text(
                                      '${weather.currentWeather.humidity}${units.getHumidityUnit()}'),
                                ],
                              )
                            ]),
                      ]),
                ),
                Text(
                  'Today',
                  style: titleStyle,
                ),
                Container(
                  height: 150,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: weather.hourlyWeather.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return HourlyWeatherTile(
                          weather.hourlyWeather[index], weather.timeshift);
                    },
                  ),
                ),
                Text(
                  'Coming week',
                  style: titleStyle,
                ),
                Column(
                  children: getDailies(weather.dailyWeather, weather.timeshift),
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

  getDailies(List<DailyWeather> dailyWeathers, int offset) {
    var dailyTiles = <DailyWeatherTile>[];
    dailyWeathers.forEach((dailyWeather) {
      dailyTiles.add(DailyWeatherTile(dailyWeather, offset));
    });
    return dailyTiles;
  }

  changeLocation(BuildContext context) async {
    var changedLocation = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddLocation(true, title: 'Change Location');
        });

    if (changedLocation != null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => CurrentDetails(changedLocation)));
    }
  }

  void changeAPI(BuildContext context) async {
    var changedAPI = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddLocation(false, title: 'Change API');
        });

    if (changedAPI != null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => CurrentDetails(location)));
    }
  }

  void gotoSettings(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Settings()));
  }
}

// goToLocations(BuildContext context) {
//   print('Pressed more locations');
//   Navigator.push(context, MaterialPageRoute(builder: (context) => Locations()));
// }

enum PopUpItem { changeLocation, changeApi, settings }
