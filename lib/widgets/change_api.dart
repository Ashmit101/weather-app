import 'package:flutter/material.dart';
import 'package:weather/tools/sembast_db.dart';
import '../tools/weather_downloader.dart';
import './api_field.dart';

SembastDb sembastDb = SembastDb();

var inputDecoration = InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'API',
    hintText: 'Enter your API key of OpenWeatherMap');

var errorInputDecoration = InputDecoration(
    border: OutlineInputBorder(),
    errorText: 'API not working',
    labelText: 'API',
    hintText: 'Enter your API key of OpenWeatherMap');

var decoration;

TextEditingController textController = TextEditingController();

class ChangeAPI extends StatefulWidget {
  const ChangeAPI({Key? key}) : super(key: key);

  @override
  _ChangeAPIState createState() => _ChangeAPIState();
}

class _ChangeAPIState extends State<ChangeAPI> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Change API"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              maxLength: 32,
              controller: textController,
              decoration: decoration,
            ),
            APIField(),
            ElevatedButton(
              onPressed: () {
                submitAPI(context, textController);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void submitAPI(
      BuildContext context, TextEditingController textController) async {
    print("Change API: Inside submitAPI");
    String api = textController.text;
    int apiLength = api.length;
    if (apiLength != 32) {
      print('Error: API key must be of 32 characters');
      setState(() {
        decoration = errorInputDecoration;
      });
    } else {
      print('API key is 32 characters');
      bool apiIsCorrect = await DownloadWeather.checkAPI(api);
      if (apiIsCorrect) {
        int id = await sembastDb.addApiKey(api);
        if (id >= 0) {
          Navigator.pop(context, api);
        }
      } else {
        setState(() {
          decoration = errorInputDecoration;
        });
      }
    }
  }
}
