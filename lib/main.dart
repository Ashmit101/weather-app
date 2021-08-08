import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'screens/location_chooser.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'tools/sembast_db.dart';
import 'data/geolocation.dart';

SembastDb sembastDb = SembastDb();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    checkInternet();
    return MaterialApp(
      title: 'Weather',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LocationChooser(),
    );
  }

  checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      print('Connected : mobile');
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print('Connected : wifi');
    } else {
      print('Not connected : Offline');
    }
  }
}

class FlashScreen extends StatefulWidget {
  const FlashScreen({Key? key}) : super(key: key);

  @override
  _FlashScreenState createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  bool progressVisibile = true;
  GeoLocation? savedLocation;
  String message = 'Starting...';
  TextStyle messageStyle = TextStyle(
      color: Colors.white, fontSize: 12, decoration: TextDecoration.none);

  @override
  Widget build(BuildContext context) {
    getSavedLocation();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FlutterLogo(),
          ),
          Visibility(
            visible: progressVisibile,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          ),
          Text(
            message,
            style: messageStyle,
          )
        ],
      ),
    );
  }

  getSavedLocation() async {
    List<GeoLocation> locations = await sembastDb.getLocation();
    if (locations.isEmpty) {
      //Go to location chooser
      setState(() {
        message = 'No location found!';
      });
      goto(1);
    } else {
      //Go to today details
      setState(() {
        message = 'Location found : ${locations.length}';
      });
    }
  }

  void goto(int i) {
    setState(() {
      progressVisibile = false;
    });
    switch (i) {
      case 1:
        SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => LocationChooser()));
        });
        break;
      case 2:
        SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => LocationChooser()));
        });
        break;
      default:
    }
  }
}
