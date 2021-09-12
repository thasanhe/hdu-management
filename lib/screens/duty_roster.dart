import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DutyRoster extends StatelessWidget {
  const DutyRoster({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Text('Call Priyanwada'),
        // TextButton(
        //   onPressed: () => launch('tel://0715864325'),
        //   child: Icon(Icons.call),
        // ),
        Text('v0.0.20'),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
