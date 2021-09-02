import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/models/daily_management.dart';
import 'package:hdu_management/models/patient.dart';
import 'package:hdu_management/services/patient_service.dart';
import 'package:hdu_management/widgets/add_management.dart';
import 'package:hdu_management/widgets/progress.dart';
import 'package:hdu_management/widgets/show_management.dart';
import 'package:intl/intl.dart';

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

  List<ShowManagement> buildHistoricalManagementTiles() {
    return dailyManagementList.map((e) {
      return ShowManagement(
        title: DateFormat('dd-MM-yyyy@hh:mm a').format(e.createdDateTime),
        expandedItemsList: e.management,
      );
    }).toList();
  }

  void _showModalSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(25.0),
            topRight: const Radius.circular(25.0),
          ),
        ),
        child: AddManagement(
          bhtNumber: widget.patient.bhtNumber!,
          title: 'Add Management',
          expandedItemsList: dailyManagementList.isNotEmpty
              ? dailyManagementList.first.management
              : [],
          onRefresh: loadManagement,
        ),
      ),
    );
  }

  List<Widget> buildListView(bool isLoading) {
    List<Widget> items = [];
    items.add(GestureDetector(
      onTap: () {
        _showModalSheet();
      },
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        color: Color(0xffFFEEE0),
        elevation: 0,
        margin: EdgeInsets.only(bottom: 10, top: 10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.center,
            height: 40,
            color: Color(0xffFFEEE0),
            child: Text(
              "Add Management",
              style: TextStyle(fontSize: 15),
            ),
            // trailing: buildSubTitle(),
            // children: buildExpandedItems(),
          ),
        ),
      ),
    ));
    if (!isLoading) {
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
        : Scaffold(
            body: Container(
              color: Colors.white,
              padding: EdgeInsets.only(bottom: 10),
              alignment: Alignment.topCenter,
              child: ListView(
                children: buildListView(isLoading),
              ),
            ),
          );
  }
}
