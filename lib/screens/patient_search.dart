import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/models/gender.dart';
import 'package:hdu_management/models/patient.dart';
import 'package:hdu_management/screens/patient_profile.dart';
import 'package:hdu_management/services/patient_service.dart';
import 'package:hdu_management/utils/utils.dart';
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

  getSubtitle(Patient patient) {
    final gender = patient.gender == Gender.male ? 'male' : 'female';
    final admitionDate =
        '${patient.dateOfAdmissionHDU!.day}/${patient.dateOfAdmissionHDU!.month}/${patient.dateOfAdmissionHDU!.year}';

    return Text(
      'DOA: $admitionDate   $gender   ${patient.age}y',
      style: TextStyle(fontSize: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buildListItems() {
      List<Widget> listItems = [];

      this.patientsList!.forEach((patient) {
        Card lt = Card(
            child: ListTile(
          leading: CircleAvatar(
            child: patient.bedNumber != null
                ? Text(patient.bedNumber!.toString())
                : Text('N/A'),
          ),
          trailing: Text(
            Utils.patientStatusToString(patient.currentStatus).toUpperCase(),
            style: TextStyle(fontSize: 12),
          ),
          title: Text(patient.name),
          subtitle: getSubtitle(patient),
        ));

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
