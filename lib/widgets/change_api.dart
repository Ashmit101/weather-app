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

var decoration = inputDecoration;

TextEditingController textController = TextEditingController();

class ChangeAPI extends StatefulWidget {
  const ChangeAPI({Key? key}) : super(key: key);

  @override
  _ChangeAPIState createState() => _ChangeAPIState();
}

class _ChangeAPIState extends State<ChangeAPI> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Change API"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: textController,
                decoration: decoration,
                validator: (value) {
                  if (value != null) {
                    if (value.length != 32 && value.length != 0) {
                      return "The API key should be 32 characters long.";
                    }
                  }
                  return null;
                },
              ),
              APIInstruction(),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Validated
                    // Now check whether the key is correct and active
                    submitAPI(context, textController);
                  }
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitAPI(
      BuildContext context, TextEditingController textController) async {
    String apiKey = textController.text;
    bool apiIsCorrect = await DownloadWeather.checkAPI(apiKey);
    if (apiIsCorrect) {
      int id = await sembastDb.addApiKey(apiKey);
      if (id >= 0) {
        Navigator.pop(context, apiKey);
      }
    } else {
      setState(() {
        decoration = errorInputDecoration;
      });
    }
  }
}
