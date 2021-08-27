import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/models/gender.dart';
import 'package:hdu_management/models/patient.dart';
import 'package:hdu_management/models/patient_status.dart';
import 'package:hdu_management/screens/patient_profile.dart';
import 'package:hdu_management/services/patient_service.dart';
import 'package:hdu_management/utils/utils.dart';
import 'package:hdu_management/widgets/progress.dart';

class PatientSearch extends StatefulWidget {
  String? searchQuery;
  List<int?>? occupiedBeds;
  PatientSearch({required this.searchQuery, required this.occupiedBeds});
  @override
  _PatientSearchState createState() => _PatientSearchState();
}

class _PatientSearchState extends State<PatientSearch> {
  late PatientService patientService;
  List<Patient>? patientsList;
  List<Patient>? patientsForList;
  bool isPatientFeched = false;

  @override
  void initState() {
    super.initState();
    fetchAllPatients();
  }

  filterPatients(String? query) {
    if (query != null) {
      patientsForList = patientsList!
          .where((element) =>
              element.name
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              element.bedNumber.toString().contains(query))
          .toList();
    }
  }

  fetchAllPatients() async {
    patientService = PatientService();
    this.isPatientFeched = false;
    this.patientsList = await patientService.getAllPatients();
    this.patientsForList = patientsList;
    widget.occupiedBeds = patientsList!.map((pt) => pt.bedNumber).toList();
    setState(() {
      this.isPatientFeched = true;
    });
  }

  getSubtitle(Patient patient) {
    final admitionDate =
        '${patient.dateOfAdmissionHDU!.day}/${patient.dateOfAdmissionHDU!.month}/${patient.dateOfAdmissionHDU!.year}';

    return Text(
      'DOA: $admitionDate',
      style: TextStyle(fontSize: 12),
    );
  }

  getColorsByStatus(PatientStatus status) {
    if (status == PatientStatus.inward)
      return Colors.green[400];
    else if (status == PatientStatus.transferred)
      return Colors.orange[400];
    else if (status == PatientStatus.lama)
      return Colors.pink[400];
    else if (status == PatientStatus.discharged) return Colors.grey[400];
    return Colors.red[400];
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buildListItems() {
      List<Widget> listItems = [];

      if (widget.searchQuery != null) {
        filterPatients(widget.searchQuery);
      }

      this.patientsForList!.forEach((patient) {
        Card ptCard = Card(
          elevation: 0,
          child: ListTile(
            leading: CircleAvatar(
              child: patient.bedNumber != null
                  ? Text(patient.bedNumber!.toString())
                  : Text('N/A'),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                      EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
                  decoration: BoxDecoration(
                      color: getColorsByStatus(patient.currentStatus),
                      borderRadius: BorderRadius.circular(8)),
                  child: Container(
                    child: Text(
                      Utils.patientStatusToString(patient.currentStatus)
                          .toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    right: 5,
                  ),
                  child: Text(
                    patient.gender == Gender.male ? 'MALE' : 'FEMALE',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    right: 5,
                  ),
                  child: Text(
                    '${patient.age.toString()} Y',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            title: Text(patient.name),
            subtitle: getSubtitle(patient),
          ),
        );

        Container cont = Container(
          height: 85,
          child: ptCard,
        );

        GestureDetector gd = GestureDetector(
          child: cont,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PatientProfile(
                  patient: patient,
                ),
              ),
            );
          },
        );

        listItems.add(gd);
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
