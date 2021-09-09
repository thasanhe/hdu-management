import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/common/common_style.dart';
import 'package:hdu_management/models/on_admission_status.dart';
import 'package:hdu_management/models/patient.dart';
import 'package:hdu_management/models/patient_status.dart';
import 'package:hdu_management/tabs/profile.dart';
import 'package:hdu_management/tabs/daily_management.dart';
import 'package:hdu_management/services/patient_service.dart';
import 'package:hdu_management/widgets/patient_profile_header.dart';
import 'package:hdu_management/widgets/progress.dart';

String selectedCategorie = "Adults";

class PatientManagement extends StatefulWidget {
  final double bhtNumber;
  final VoidCallback onRefresh;
  const PatientManagement({
    Key? key,
    required this.bhtNumber,
    required this.onRefresh,
  }) : super(key: key);

  @override
  _PatientManagementState createState() => _PatientManagementState();
}

class _PatientManagementState extends State<PatientManagement>
    with SingleTickerProviderStateMixin {
  final _dateOfUpdateController = TextEditingController();
  Patient? patient;
  OnAdmissionStatus? onAdmissionStatus;

  PatientService patientService = PatientService();
  bool isPatientFetched = false;
  bool isOnAdmissionStatusFetched = false;

  late TabController tabController;
  int selectedIndex = 0;

  DateTime? dateOfUpdate;

  fetchPatient() async {
    this.isPatientFetched = false;
    var pt = await patientService.getPatientByBht(widget.bhtNumber);

    setState(() {
      this.patient = pt;
      this.isPatientFetched = true;
    });
  }

  fetchOnAdmissionStatus() async {
    this.isOnAdmissionStatusFetched = false;
    var onAdmissionStatus =
        await patientService.getOnAdmissionStatusByPatient(widget.bhtNumber);

    setState(() {
      this.onAdmissionStatus = onAdmissionStatus;
      this.isOnAdmissionStatusFetched = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPatient();
    fetchOnAdmissionStatus();
    tabController = TabController(
      initialIndex: selectedIndex,
      length: 4,
      vsync: this,
    );
    this.dateOfUpdate = DateTime.now();
  }

  int _selectedStatus = -1;

  List<String> statusList = [
    'On Air',
    'On Intermittent O2',
    'On O2 Concentrator-l/min', // val rate - l/min
    'On Nasal Cannula-l/min', // val rate - l/min
    'On SFM-l/min', // val rate - l/min
    'On NRBM-l/min', // val rate - l/min
    'On HFNC-l/min', // val rate - l/min
    'On HFNC + NRBM-l/min', // two val // val rate - l/min
    'On CPAP-cmH2O', //pressure - cmH2O
    'On BiPAP-cmH2O', // IPAP - EPAP pressure - cmH2O
    'On Ventilator CPAP-cmH2O', // cpap bipap pressure - cmH2O
    'On Ventilator BiPAP-cmH2O', //IPAP - EPAP pressure - cmH2O
    'Intubated',
    'Transferred', //13
    'Death', //14
    'Discharged', //15
  ];

  final _formStateKey = GlobalKey<FormState>();

  double? value1;
  double? value2;

  void _showUpdateDialog() {
    print('updating dialog');
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            title: Container(
              padding: EdgeInsets.all(20),
              child: Text('Update patient'),
            ),
            content: Container(
              height: 225,
              alignment: Alignment.topLeft,
              child: Form(
                key: _formStateKey,
                autovalidateMode: AutovalidateMode.always,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: getMainStatusList(setState),
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              TextButton(
                  onPressed: () {
                    _updatePatient();
                    print('on saved');
                    Navigator.pop(context);
                  },
                  child: Text('Save'))
            ],
          );
        });
      },
    );
  }

  onTapDatePickerDOUpdate() async {
    try {
      this.dateOfUpdate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 30)),
        lastDate: DateTime.now(),
      );
      dateOfUpdate = dateOfUpdate!.add(Duration(
          hours: DateTime.now().hour,
          minutes: DateTime.now().minute,
          seconds: DateTime.now().second));

      _dateOfUpdateController.text =
          '${dateOfUpdate!.day}/${dateOfUpdate!.month}/${dateOfUpdate!.year}';
    } catch (e) {
      print(e);
    }
  }

  getMainStatusList(Function setState) {
    List<Widget> inputStatusItems = [];
    inputStatusItems.add(SizedBox(
      height: 15,
    ));

    inputStatusItems.add(TextFormField(
      controller: _dateOfUpdateController,
      validator: (input) {
        if (input == null || input.isEmpty) {
          return "Please select date";
        }
        return null;
      },
      onTap: onTapDatePickerDOUpdate,
      decoration: getInputDecorationCalendar("Date of Update"),
    ));

    inputStatusItems.add(SizedBox(
      height: 15,
    ));

    inputStatusItems.add(Container(
      child: DropdownButtonFormField(
        isDense: true,
        onChanged: (value) {
          setState(() {
            this._selectedStatus = int.parse(value.toString());
          });
        },
        decoration: getInputDecorationTextFormField('Update Patient Status'),
        items: getDrodownMenuItems(),
      ),
    ));
    inputStatusItems.add(SizedBox(
      height: 15,
    ));
    inputStatusItems.addAll(getStatusValues());
    inputStatusItems.add(SizedBox(
      height: 15,
    ));
    return inputStatusItems;
  }

  getStatusValues() {
    return <Widget>[
      Visibility(
        visible: this._selectedStatus >= 2 && this._selectedStatus <= 6,
        child: Container(
          width: 100,
          child: TextFormField(
            onSaved: (input) {
              if (input!.isNotEmpty) {
                value1 = double.parse(input);
              }
            },
            decoration:
                getInputDecorationTextFormField("Rate l/min", hint: 'l/min'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
        ),
      ),
      Visibility(
        visible: this._selectedStatus == 7,
        child: Container(
          // width: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 100,
                child: TextFormField(
                  onSaved: (input) {
                    if (input!.isNotEmpty) {
                      value1 = double.parse(input);
                    }
                  },
                  decoration: getInputDecorationTextFormField("HFNC rate",
                      hint: 'l/min'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Container(
                width: 100,
                child: TextFormField(
                  onSaved: (input) {
                    if (input!.isNotEmpty) {
                      value2 = double.parse(input);
                    }
                  },
                  decoration: getInputDecorationTextFormField("NRBM rate",
                      hint: 'l/min'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),
        ),
      ),
      Visibility(
        visible: this._selectedStatus == 8 || this._selectedStatus == 10,
        child: Container(
          width: 100,
          child: TextFormField(
            onSaved: (input) {
              if (input!.isNotEmpty) {
                value1 = double.parse(input);
              }
            },
            decoration:
                getInputDecorationTextFormField("Pressure", hint: 'cmH2O'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
        ),
      ),
      Visibility(
        visible: this._selectedStatus == 11 || this._selectedStatus == 9,
        child: Container(
          // width: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 100,
                child: TextFormField(
                  onSaved: (input) {
                    if (input!.isNotEmpty) {
                      value1 = double.parse(input);
                    }
                  },
                  decoration: getInputDecorationTextFormField("IPAP Presure",
                      hint: 'cmH2O'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Container(
                width: 100,
                child: TextFormField(
                  onSaved: (input) {
                    if (input!.isNotEmpty) {
                      value2 = double.parse(input);
                    }
                  },
                  decoration: getInputDecorationTextFormField("EPAP Presure",
                      hint: 'cmH2O'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),
        ),
      )
    ];
  }

  getDrodownMenuItems() {
    return statusList.map((e) {
      return DropdownMenuItem(
        child: Text(e.split('-').first),
        value: statusList.indexOf(e),
      );
    }).toList();
  }

  void _updatePatient() async {
    FormState formState = _formStateKey.currentState!;
    if (formState.validate()) {
      formState.save();
      PatientStatus ps = PatientStatus(
        bhtNumber: patient!.bhtNumber!,
        status: statusList.elementAt(_selectedStatus).split('-')[0],
        value1: value1,
        value2: value2,
        unit: statusList.elementAt(_selectedStatus).split('-').length > 1
            ? statusList.elementAt(_selectedStatus).split('-')[1]
            : null,
        assignedDateTime: dateOfUpdate != null ? dateOfUpdate! : DateTime.now(),
      );

      try {
        await patientService.createPatientStatus(
            ps, patient!.currentStatusDate!);
        fetchPatient();
        widget.onRefresh();

        print('on Refreshed');
      } catch (e) {
        print('Error while creating patient status');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('rendering');
    return Scaffold(
      body: !isPatientFetched || !isOnAdmissionStatusFetched
          ? circularProgress()
          : Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(),
                    PatientsProfileHeader(
                      patient: patient!,
                      isSearch: false,
                      showUpdateDialog: _showUpdateDialog,
                    ),
                    DefaultTabController(
                      length: 3, // length of tabs
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
                                    child: Tab(text: 'Management'),
                                    width: 100,
                                  ),
                                  Container(
                                    child: Tab(text: 'Charts'),
                                    width: 100,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: TabBarView(children: <Widget>[
                                  Container(
                                    child: Profile(
                                      patient: this.patient!,
                                      onAdmissionStatus:
                                          this.onAdmissionStatus!,
                                    ),
                                  ),
                                  DailyManagement(patient: patient!),
                                  Container(
                                    child: Center(
                                      child: Text('Display Charts',
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ]),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
    );
  }
}
