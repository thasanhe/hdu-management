import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/models/gender.dart';
import 'package:hdu_management/models/patient.dart';
import 'package:hdu_management/screens/patient_profile.dart';
import 'package:hdu_management/services/patient_service.dart';
import 'package:hdu_management/widgets/progress.dart';

class PatientSearch extends StatefulWidget {
  @override
  _PatientSearchState createState() => _PatientSearchState();
}

class _PatientSearchState extends State<PatientSearch> {
  final PatientService patientService = PatientService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: patientService.getPatients(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }

        final patientsList = snapshot.data as List<Patient>;

        List<Widget> listItems = [];

        patientsList.forEach((patient) {
          ListTile lt = ListTile(
            leading: Icon(Icons.person),
            title: Text(patient.name),
            subtitle: Text(patient.gender == Gender.female ? 'Female' : 'Male'),
          );

          TextButton tb = TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PatientProfile(
                              patient: patient,
                            )));
              },
              child: lt);

          listItems.add(tb);
          listItems.add(Divider(
            thickness: 2,
          ));
        });

        return ListView(
          children: listItems,
        );
      },
    );
  }
}
