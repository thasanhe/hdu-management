import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/common/common_style.dart';
import 'package:hdu_management/models/daily_management.dart';
import 'package:hdu_management/models/patient.dart';
import 'package:hdu_management/services/patient_service.dart';
import 'package:hdu_management/widgets/management_add_tile.dart';
import 'package:hdu_management/widgets/management_tile.dart';
import 'package:hdu_management/widgets/progress.dart';
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

  List<ManagementTile> buildHistoricalManagementTiles() {
    return dailyManagementList.map((e) {
      return ManagementTile(
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
        child: ManagementAddTile(
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
    if (!isLoading) {
      // items.add(TextButton(
      //   onPressed: () {
      //     _showModalSheet();
      //   },
      //   child: Text('Add management'),
      // ));
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
            floatingActionButton: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              // color: Colors.black,
              decoration: BoxDecoration(
                color: colorBrightYellow,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: TextButton.icon(
                  onPressed: () {
                    _showModalSheet();
                  },
                  icon: Icon(
                    CupertinoIcons.pen,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          );
  }
}
