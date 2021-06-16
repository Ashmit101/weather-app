import 'package:flutter/material.dart';

class LocationChooser extends StatefulWidget {
  const LocationChooser({Key? key}) : super(key: key);

  @override
  _LocationChooserState createState() => _LocationChooserState();
}

class _LocationChooserState extends State<LocationChooser> {
  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle =
        ElevatedButton.styleFrom(textStyle: TextStyle(fontSize: 24));
    TextEditingController locationTextController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Location'),
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            Icon(
              Icons.explore,
              size: 50,
            ),
            Text("Search your location"),
            TextField(
              controller: locationTextController,
            ),
            ElevatedButton(
              style: buttonStyle,
              onPressed: () {},
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
