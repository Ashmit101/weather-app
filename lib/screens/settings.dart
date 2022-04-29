import 'package:flutter/material.dart';
import '../data/settings_data.dart';
import '../data/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool changed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('BUild');
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, changed);
        return false;
      },
      child: FutureBuilder(
          future: getSavedData(),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                //Settings map
                Map<String, dynamic> settingMap = snapshot.data!;

                return Scaffold(
                  appBar: AppBar(
                    title: Text('Settings'),
                  ),
                  body: Column(
                    children: [
                      Card(
                        child: Row(
                          children: [
                            Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  showOptions(context);
                                },
                                child: ListTile(
                                  title: const Text("Units"),
                                  subtitle: Text(settingMap['unit']),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return Center(
                  child:
                      Text('An Error Occured: Unable to get SharedPreferences'),
                );
              }
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  void showOptions(BuildContext context) async {
    var selectedUnit = await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text("Select unit"),
            children: [
              SimpleDialogOption(
                child: Text(Constants.standard),
                onPressed: () {
                  Navigator.pop(context, Units.standard);
                },
              ),
              SimpleDialogOption(
                child: Text(Constants.metric),
                onPressed: () {
                  Navigator.pop(context, Units.metric);
                },
              ),
              SimpleDialogOption(
                child: Text(Constants.imperial),
                onPressed: () {
                  Navigator.pop(context, Units.imperial);
                },
              ),
            ],
          );
        });
    if (selectedUnit != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int unitId;
      switch (selectedUnit) {
        case Units.standard:
          unitId = 1;
          break;
        case Units.imperial:
          unitId = 2;
          break;
        default:
          unitId = 0;
          break;
      }
      await prefs.setInt('unit', unitId);
      changed = true;
      print('Unit saved : $unitId');
      setState(() {});
    }
  }

  Future<Map<String, dynamic>> getSavedData() async {
    Map<String, dynamic> settingsMap = Map();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //unit
    int unitId = prefs.getInt('unit') ?? 0;
    String unitString = getUnitString(unitId);

    //Fill map
    settingsMap['unit'] = unitString;

    //return
    return settingsMap;
  }

  String getUnitString(int unitId) {
    switch (unitId) {
      case 1:
        return Constants.standard;
      case 2:
        return Constants.imperial;
      default:
        return Constants.metric;
    }
  }
}
