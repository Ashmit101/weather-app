import 'package:flutter/material.dart';
import 'screens/location_chooser.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'tools/sembast_db.dart';

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
