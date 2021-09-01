import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/models/on_admission_status.dart';
import 'package:hdu_management/models/patient.dart';
import 'package:hdu_management/tabs/investigation_tab.dart';
import 'package:hdu_management/tabs/patient_management.dart';
import 'package:hdu_management/services/patient_service.dart';
import 'package:hdu_management/widgets/patient_tile.dart';

String selectedCategorie = "Adults";

class PatientProfile extends StatefulWidget {
  final Patient patient;
  const PatientProfile({Key? key, required this.patient}) : super(key: key);

  @override
  _PatientProfileState createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile>
    with SingleTickerProviderStateMixin {
  List<String> categories = ["Inward", "Discharged", "Transferred", "Death"];

  PatientService patientService = PatientService();
  OnAdmissionStatus? onAdmissionStatus;
  bool isOnAdmStatusFetched = false;

  late TabController tabController;
  int selectedIndex = 0;

  fetchOnAdmissionStatusByPatient() async {
    this.isOnAdmStatusFetched = false;
    onAdmissionStatus = await patientService
        .getOnAdmissionStatusByPatient(widget.patient.bhtNumber!);

    setState(() {
      this.onAdmissionStatus = onAdmissionStatus;
      this.isOnAdmStatusFetched = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchOnAdmissionStatusByPatient();
    tabController = TabController(
      initialIndex: selectedIndex,
      length: 4,
      vsync: this,
    );
  }

  getProfile() {
    return Column(children: [
      Container(
        child: Text(onAdmissionStatus!.coMobidities.toString()),
      ),
      Text(DateTime.now()
          .difference(widget.patient.symptomsDate)
          .inDays
          .toString()),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final daysfromSymptoms =
        DateTime.now().difference(widget.patient.symptomsDate).inDays;
    final daysFromRAT =
        DateTime.now().difference(widget.patient.pcrRatDate).inDays;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          leading: GestureDetector(
            child: Icon(CupertinoIcons.back),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          title: Container(
            height: 35,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                Chip(
                  label: Text(
                    " $daysfromSymptoms Days Symptoms",
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Color(0xffEFEFEF),
                ),
                SizedBox(
                  width: 10,
                ),
                Chip(
                  label: Text(
                    "$daysFromRAT Days RAT/PCR",
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Color(0xffEFEFEF),
                ),
              ],
            ),
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ),

        body: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                PatientsTile(
                  patient: widget.patient,
                  isGestureEnabled: false,
                ),
                DefaultTabController(
                  length: 4, // length of tabs
                  initialIndex: 0,
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          height: 30,
                          child: TabBar(
                            isScrollable: true,
                            overlayColor: MaterialStateColor.resolveWith(
                                (states) => Colors.white),
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            indicator: BoxDecoration(
                              color: Color(0xffFFEEE0),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.black,
                            tabs: [
                              Container(
                                child: Tab(text: 'Profile'),
                                width: 80,
                              ),
                              Container(
                                child:
                                    Tab(text: 'Parameteters'), // taken from hdu
                                width: 100,
                              ),
                              Container(
                                child:
                                    Tab(text: 'Investigations'), //lab reports
                                width: 100,
                              ),
                              Container(
                                child: Tab(text: 'Management'),
                                width: 100,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: TabBarView(children: <Widget>[
                              Container(
                                child: Center(
                                  child: Text('Display Tab 1',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Container(
                                child: Center(
                                  child: Text('Display Tab 2',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Container(
                                child: InvestigationTab(),
                              ),
                              PatientManagement(patient: widget.patient),
                            ]),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ]),
        ),
        // body: Column(
        //   children: [

        //     TabBarView(
        //       children: [
        //         Container(
        //           color: Colors.white,
        //           child:
        //               isOnAdmStatusFetched ? getProfile() : circularProgress(),
        //         ),
        //         Icon(Icons.directions_transit),
        //         Icon(Icons.directions_bike),
        //       ],
        //     ),
        //   ],
        // ),
        // ),
      ),
    );
  }
}
