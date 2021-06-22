import 'package:flutter/material.dart';
import 'package:weather/data/weather.dart';
import 'dart:convert';

class CurrentDetails extends StatefulWidget {
  String message;

  CurrentDetails(this.message);

  @override
  _CurrentDetailsState createState() => _CurrentDetailsState(message);
}

class _CurrentDetailsState extends State<CurrentDetails> {
  late Weather weather;
  String message;
  var jsonWeatherMap;

  // TextEditingController nameController = TextEditingController();
  // TextEditingController mainController = TextEditingController();
  // TextEditingController descriptionController = TextEditingController();
  // TextEditingController temperatureController = TextEditingController();

  _CurrentDetailsState(this.message) {
    jsonWeatherMap = jsonDecode(message);
  }

  @override
  Widget build(BuildContext context) {
    final sizeX = MediaQuery.of(context).size.width;
    final sizeY = MediaQuery.of(context).size.height;
    weather = Weather.fromJsonMap(jsonWeatherMap);

    String name = weather.name;
    String main = weather.main;
    String description = weather.description;
    String icon = weather.icon;

    //Temperature data
    double temperature = weather.temperature['temp'];
    double feels_like = weather.temperature['feels_like'];
    double temp_min = weather.temperature['temp_min'];
    double temp_max = weather.temperature['temp_max'];
    int pressure = weather.temperature['pressure'];
    int humidity = weather.temperature['humidity'];

    //Wind data
    double speed = weather.wind['speed'];
    int degree = weather.wind['deg'];

    TextStyle textStyle = TextStyle(fontSize: 18);
    TextStyle tempStyle = TextStyle(fontSize: 30);

    return Scaffold(
        appBar: AppBar(
          title: Text(name),
        ),
        body: SingleChildScrollView(
            child: Container(
          width: sizeX,
          height: sizeY,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
                  child: ListTile(
                      leading: Image.network(
                          "http://openweathermap.org/img/wn/$icon@2x.png"),
                      title: Text(main),
                      subtitle: Text(description))),
              Card(
                child: Column(
                  children: [
                    Text(
                      temperature.toString(),
                      style: TextStyle(
                        fontSize: 50,
                      ),
                    ),
                    Table(
                      children: [
                        TableRow(
                          children: [
                            //feels like
                            Center(
                                child: Text(
                              'Feels like',
                              style: textStyle,
                            )),
                            //feels like value
                            Center(
                                child: Text(
                              feels_like.toString(),
                              style: textStyle,
                            )),
                          ],
                        ),
                        TableRow(
                          children: [
                            //feels like
                            Center(
                                child: Text(
                              'Minimum',
                              style: textStyle,
                            )),
                            //feels like value
                            Center(
                                child: Text(
                              temp_min.toString(),
                              style: textStyle,
                            )),
                          ],
                        ),
                        TableRow(
                          children: [
                            //feels like
                            Center(
                                child: Text(
                              'Maximum',
                              style: textStyle,
                            )),
                            //feels like value
                            Center(
                                child: Text(
                              temp_max.toString(),
                              style: textStyle,
                            )),
                          ],
                        ),
                        TableRow(
                          children: [
                            //feels like
                            Center(
                                child: Text(
                              'Pressure',
                              style: textStyle,
                            )),
                            //feels like value
                            Center(
                                child: Text(
                              pressure.toString(),
                              style: textStyle,
                            )),
                          ],
                        ),
                        TableRow(
                          children: [
                            //feels like
                            Center(
                                child: Text(
                              'Humidity',
                              style: textStyle,
                            )),
                            //feels like value
                            Center(
                                child: Text(
                              humidity.toString(),
                              style: textStyle,
                            )),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Card(
                child: Column(
                  children: [
                    Text(
                      'Wind',
                      style: TextStyle(
                        fontSize: 50,
                      ),
                    ),
                    Table(
                      children: [
                        TableRow(
                          children: [
                            Center(
                                child: Text(
                              'Speed',
                              style: textStyle,
                            )),
                            Center(
                                child: Text(
                              speed.toString(),
                              style: textStyle,
                            )),
                          ],
                        ),
                        TableRow(
                          children: [
                            //feels like
                            Center(
                                child: Text(
                              'Degree',
                              style: textStyle,
                            )),
                            //feels like value
                            Center(
                                child: Text(
                              degree.toString(),
                              style: textStyle,
                            )),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
