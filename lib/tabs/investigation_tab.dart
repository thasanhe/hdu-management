import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InvestigationTab extends StatefulWidget {
  const InvestigationTab({Key? key}) : super(key: key);

  @override
  _InvestigationTabState createState() => _InvestigationTabState();
}

class _InvestigationTabState extends State<InvestigationTab> {
  @override
  void initState() {
    super.initState();
  }

  void _showModalSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            color: Colors.tealAccent,
            child: new Center(
              child: new Text("Hi ModalSheet"),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: new Center(
          child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new RaisedButton(
            onPressed: _showModalSheet,
            child: new Text("Modal"),
          ),
        ],
      )),
    );
  }
}
