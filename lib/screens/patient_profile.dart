import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/models/patient.dart';

class PatientProfile extends StatelessWidget {
  final Patient patient;
  const PatientProfile({Key? key, required this.patient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(patient.name + " : " + patient.bhtNumber.toString()),
          bottom: TabBar(
            labelPadding: EdgeInsets.all(0),
            tabs: [
              Tab(
                child: Container(
                  // color: Colors.red,
                  child: Center(
                    child: Text(
                      'History',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  // color: Colors.green,
                  child: Center(
                    child: Text(
                      'Management',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  // color: Colors.grey[600],
                  child: Center(
                    child: Text(
                      'Summary',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Icon(Icons.directions_car),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}
