import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/data/data.dart';
import 'package:weather/data/weather.dart';
import 'package:weather/tools/weather_downloader.dart';
import 'package:weather/widgets/location_insert_alert.dart';
import 'package:weather/widgets/location_tile.dart';

List<String>? locations;
List<Weather> _weather = <Weather>[];

class Locations extends StatefulWidget {
  const Locations({Key? key}) : super(key: key);

  @override
  _LocationsState createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  @override
  void initState() {
    _getLocations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Locations'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => addLocation(),
            )
          ],
        ),
        body: ListView.builder(
          itemCount: _weather.length,
          itemBuilder: (context, index) {
            return LocationTile(_weather[index]);
          },
        ));
  }

  addLocation() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddLocation();
        });
  }

  void _getLocations() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    locations = sp.getStringList(Strings.multipleLocationKey);
    print(locations);
    List<Weather> weathers = <Weather>[];
    locations?.forEach((element) async {
      print('Adding weather element');
      print('Number of weathers: ${locations?.length}');
      weathers.add(await DownloadWeather.downlaodWeatherWithName(element));
      if (weathers.length == locations?.length) {
        weathers.forEach((element) {
          print(element.name);
        });
        setState(() {
          _weather = weathers;
        });
      }
    });
  }
}
