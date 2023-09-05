import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:weather/data/geolocation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:weather/screens/today_details.dart';
import 'package:weather/widgets/location_form.dart';
import '../tools/sembast_db.dart';

TextEditingController locationTextController = TextEditingController();
TextEditingController apiTextController = TextEditingController();
SembastDb sembastDb = SembastDb();
InputDecoration apiDecoration = InputDecoration(
  isDense: true,
  border: OutlineInputBorder(),
  hintText: 'Your API key (Optional)',
);
InputDecoration apiDecorationError = InputDecoration(
  isDense: true,
  border: OutlineInputBorder(),
  hintText: 'Your API key (Optional)',
  errorText: 'Error API',
);

var apiInputDecoration = apiDecoration;

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
                        print(
                            '[location_chooser.dart] Number of saved locations: ${savedLocation.length}');
                        if (savedLocation.isEmpty) {
                          return LocationForm();
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

  gotoCurrentWeather(BuildContext context, GeoLocation location) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => CurrentDetails(location)));
    });
  }
}
