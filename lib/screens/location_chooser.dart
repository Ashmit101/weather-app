import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:weather/data/geolocation.dart';
import 'package:weather/screens/today_details.dart';
import 'package:weather/tools/weather_downloader.dart';
import 'package:weather/widgets/choose_coord.dart';
import 'package:geolocator/geolocator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../tools/sembast_db.dart';

TextEditingController locationTextController = TextEditingController();
TextEditingController apiTextController = TextEditingController();
SembastDb sembastDb = SembastDb();

class LocationChooser extends StatefulWidget {
  @override
  _LocationChooserState createState() {
    return _LocationChooserState();
  }
}

class _LocationChooserState extends State<LocationChooser> {
  String weatherInfo = '';
  String city = '';
  late Future<int> internet;
  late Future<List<GeoLocation>> savedLocations;
  var _isProgressVisible = false;
  var _isDeviceLocationProgressVisible = false;

  @override
  void initState() {
    internet = checkInternet();
    savedLocations = getSavedLocation();
    super.initState();
  }

  Future<int> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return 0;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return 0;
    } else {
      return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    String message = 'Starting...';
    TextStyle messageStyle = TextStyle(
        color: Colors.white, fontSize: 12, decoration: TextDecoration.none);
    final ButtonStyle buttonStyle =
        ElevatedButton.styleFrom(textStyle: TextStyle(fontSize: 24));
    InputDecoration locationInputDecoration = InputDecoration(
      isDense: true,
      border: OutlineInputBorder(),
      hintText: 'City Name',
    );
    InputDecoration apiInputDecoration = InputDecoration(
      isDense: true,
      border: OutlineInputBorder(),
      hintText: 'Your API key (Optional)',
    );

    return FutureBuilder(
      future: internet,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            var internetCode = snapshot.data as int;
            if (internetCode == 1) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text("No Internet"),
                ),
                body: Center(
                  child: Image(
                    image: AssetImage('graphics/weather_nointernet.png'),
                  ),
                ),
              );
            } else {
              return FutureBuilder(
                  future: savedLocations,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      //After resolving the future
                      if (snapshot.hasData) {
                        var savedLocation = snapshot.data as List<GeoLocation>;
                        if (savedLocation.isEmpty) {
                          return Scaffold(
                              appBar: AppBar(
                                title: Text('Location'),
                              ),
                              body: SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.all(15.0),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.explore,
                                        size: 50,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Search your location"),
                                      ),
                                      TextField(
                                        decoration: locationInputDecoration,
                                        controller: locationTextController,
                                      ),
                                      Container(
                                        height: 8,
                                      ),
                                      //API textfield
                                      TextField(
                                        decoration: apiInputDecoration,
                                        controller: apiTextController,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            style: buttonStyle,
                                            onPressed: () {
                                              String apiKey =
                                                  apiTextController.text;
                                              String cityName =
                                                  locationTextController.text;
                                              if (cityName != '') {
                                                setState(() {
                                                  _isProgressVisible = true;
                                                });
                                                submit(
                                                    context, apiKey, cityName);
                                              }
                                            },
                                            child: Text('Submit'),
                                          ),
                                          Visibility(
                                            visible: _isProgressVisible,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                  height: 15,
                                                  width: 15,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 3,
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                      ElevatedButton(
                                        style: buttonStyle,
                                        onPressed: () {
                                          setState(() {
                                            _isDeviceLocationProgressVisible =
                                                true;
                                          });
                                          return getDeviceLocation(context);
                                        },
                                        child: Text('Use device location'),
                                      ),
                                      Visibility(
                                        visible:
                                            _isDeviceLocationProgressVisible,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                              height: 15,
                                              width: 15,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 3,
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                        }
                        gotoCurrentWeather(context, savedLocation[0]);
                      }
                    }
                    //While waiting
                    return Scaffold(
                      appBar: AppBar(
                        title: Text('Weather'),
                      ),
                      body: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: FlutterLogo(),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                            Text(
                              message,
                              style: messageStyle,
                            )
                          ],
                        ),
                      ),
                    );
                  });
            }
          }
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<List<GeoLocation>> getSavedLocation() async {
    List<GeoLocation> savedLocation = await sembastDb.getLocation();
    return savedLocation;
  }

  void getLocationCoordinate(BuildContext context, String cityName) async {
    List<GeoLocation> geoLocationList =
        await DownloadWeather.downloadLocationCoords(cityName);
    showDialogWithLocations(context, geoLocationList);
    setState(() {
      _isProgressVisible = false;
    });
  }

  void showDialogWithLocations(
      BuildContext context, List<GeoLocation> geoLocations) async {
    //Location chosen by the user
    var chosenLocation = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return ChooseCoord.fromGeoList(geoLocations);
        });
    gotoCurrentWeather(context, chosenLocation);
  }

  getDeviceLocation(BuildContext context) async {
    print('Pressed auto locate');
    bool serviceEnabled;
    LocationPermission permission;

    //Test if location permission enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //Location services are not enabled
      print('Location services are disabled');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return;
      }
    } else {
      print('Permission granted');
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permission denied. Unable to ask again.');
      return;
    } else {
      print('Permission granted - forever');
    }

    Position currentPosition = await Geolocator.getCurrentPosition();
    print(currentPosition);
    List<dynamic> locations =
        await DownloadWeather.downloadLocationNameFromCoord(
            currentPosition.latitude, currentPosition.longitude);
    var location = locations[0] as Map<String, dynamic>;
    print('List has ${locations.length} items');
    List<GeoLocation> geoLocationList =
        await DownloadWeather.downloadLocationCoords(
            location['local_names']['en']);
    showDialogWithLocations(context, geoLocationList);
    setState(() {
      _isDeviceLocationProgressVisible = false;
    });
  }

  gotoCurrentWeather(BuildContext context, GeoLocation location) {
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => CurrentDetails(location)));
    });
  }

  void submit(BuildContext context, String? apiKey, String cityName) async {
    await sembastDb.addApiKey(apiKey);
    getLocationCoordinate(context, cityName);
  }
}
