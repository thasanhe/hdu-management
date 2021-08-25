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
  late PatientService patientService;
  List<Patient>? patientsList;
  bool isPatientFeched = false;

  @override
  void initState() {
    super.initState();
    fetchAllPatients();
  }

  fetchAllPatients() async {
    patientService = PatientService();
    this.isPatientFeched = false;
    this.patientsList = await patientService.getAllPatients();
    setState(() {
      this.isPatientFeched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buildListItems() {
      List<Widget> listItems = [];

      this.patientsList!.forEach((patient) {
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
                  ),
                ),
              );
            },
            child: lt);

        listItems.add(tb);
        listItems.add(Divider(
          thickness: 2,
        ));
      });

      return listItems;
    }

    return Container(
      child: !isPatientFeched
          ? circularProgress()
          : RefreshIndicator(
              child: ListView(
                children: buildListItems(),
              ),
              onRefresh: () {
                fetchAllPatients();
                print("Refreshing the list");
                return Future.value('');
                // return patientService.getPatients();
              },
            ),
    );
  }
}
