import 'package:flutter/material.dart';
import 'package:weather/widgets/units_dropdown.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          Card(
            child: Row(
              children: [
                Text('Units'),
                UnitsDropdownButton(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
