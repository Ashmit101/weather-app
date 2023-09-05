import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import '../screens/api_instructions.dart';

class APIInstruction extends StatelessWidget {
  const APIInstruction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        gotoApiInstruction(context);
      },
      child: Container(
        width: screenWidth,
        child: Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Text(
            'How to get an API key?',
            textScaleFactor: 0.8,
            style: TextStyle(color: Colors.blueAccent),
          ),
        ),
      ),
    );
  }

  void gotoApiInstruction(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ApiKeyInstruction()));
    });
  }
}
