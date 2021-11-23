import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiKeyInstruction extends StatelessWidget {
  const ApiKeyInstruction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('API Key')),
      body: FutureBuilder(
          future: rootBundle.loadString("assets/api_instructions.md"),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return Markdown(
                data: snapshot.data!,
                onTapLink: (String text, String? href, String title) {
                  print('Text: $text, href: $href, title: $title');
                  _launchURL(href);
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}

void _launchURL(String? href) async {
  if (href != null) {
    if (await canLaunch(href)) {
      await launch(href);
    } else {
      print('Could not launch link');
    }
  }
}
