import 'package:flutter/material.dart';
import '../tools/weather_downloader.dart';

TextEditingController locationController = TextEditingController();

class AddLocation extends StatefulWidget {
  const AddLocation({Key? key}) : super(key: key);

  @override
  _AddLocationState createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add location'),
      content: Container(
        child: TextField(
          controller: locationController,
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text('Cancel')),
        TextButton(onPressed: () => getLocation(), child: Text('Add')),
      ],
      elevation: 24.0,
    );
  }
}

getLocation() async {
  String location = locationController.text;
  print('Location : $location');
  var response = await DownloadWeather.downloadWeatherJsonWithName(location);
  if (response.statusCode == 200) {
    print('Location added');
  }
}
