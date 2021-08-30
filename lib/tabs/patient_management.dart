import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/data/data.dart';
import 'package:hdu_management/models/daily_management.dart';
import 'package:hdu_management/models/patient.dart';
import 'package:hdu_management/services/patient_service.dart';
import 'package:hdu_management/widgets/management_add_tile.dart';
import 'package:hdu_management/widgets/management_tile.dart';
import 'package:hdu_management/widgets/progress.dart';

class PatientManagement extends StatefulWidget {
  final Patient patient;
  const PatientManagement({Key? key, required this.patient}) : super(key: key);
  @override
  _PatientManagementState createState() => _PatientManagementState();
}

class _PatientManagementState extends State<PatientManagement> {
  late PatientService patientService;

  late List<DailyManagement> dailyManagementList = [];

  bool isLoading = true;
  Key key = Key('');

  // fetchAllPatients() async {
  //   patientService = PatientService();
  //   this.isPatientFeched = false;
  //   this.patientsList = await patientService.getAllPatients();
  //   this.patientsForList = patientsList;
  //   occupiedBeds = patientsList!.map((pt) => pt.bedNumber).toList();
  //   setState(() {
  //     this.isPatientFeched = true;
  //   });
  // }

  // refreshAfterCreation() {
  //   setState(() {
  //     key = Key('');
  //     isLoading = true;
  //     loadManagement();
  //     isLoading = false;
  //   });
  // }

  loadManagement() async {
    isLoading = true;
    final retrievedManagement =
        await patientService.getDailyManagementByPatientOrderedByTimeStampDesc(
            widget.patient.bhtNumber!);
    setState(() {
      this.dailyManagementList = retrievedManagement;
      isLoading = false;
    });
  }

  List<ManagementTile> buildHistoricalManagementTiles() {
    return dailyManagementList.map((e) {
      return ManagementTile(
        title: e.createdDateTime.toString(),
        expandedItemsList: e.management,
      );
    }).toList();
  }

  List<Widget> buildListView(bool isLoading) {
    List<Widget> items = [];

    if (!isLoading) {
      items.add(
        ManagementAddTile(
          bhtNumber: widget.patient.bhtNumber!,
          title: 'Add management',
          expandedItemsList: dailyManagementList.isNotEmpty
              ? dailyManagementList.first.management
              : [],
          onRefresh: loadManagement,
        ),
      );
      items.addAll(buildHistoricalManagementTiles());
    }
    return items;
  }

  @override
  void initState() {
    super.initState();
    patientService = PatientService();
    loadManagement();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? circularProgress()
        : Container(
            key: key,
            padding: EdgeInsets.only(bottom: 10),
            alignment: Alignment.topCenter,
            child: ListView(
              children: buildListView(isLoading),
            ),
          );
  }
}
