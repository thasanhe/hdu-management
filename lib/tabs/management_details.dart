import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/models/drug_chart.dart';
import 'package:hdu_management/models/parameters.dart';
import 'package:hdu_management/models/patient.dart';
import 'package:hdu_management/models/prescription.dart';
import 'package:hdu_management/services/patient_service.dart';
import 'package:hdu_management/widgets/management_details_container.dart';
import 'package:hdu_management/widgets/prescription/add_prescription.dart';
import 'package:hdu_management/widgets/progress.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class ManagementDetails extends StatefulWidget {
  final Patient patient;
  const ManagementDetails({Key? key, required this.patient}) : super(key: key);
  @override
  _ManagementDetailsState createState() => _ManagementDetailsState();
}

class _ManagementDetailsState extends State<ManagementDetails> {
  final _formStateKey = GlobalKey<FormState>();

  late PatientService patientService;

  late List<DrugChart> drugsListList = [];
  late List<Parameters> parametersList = [];
  late List<Prescription> prescriptionsList = [];

  double? bpValue;

  Map<String, double> parameterMap = {};

  double? cbsValue;
  double? prValue;
  double? rrValue;
  double? spo2Value;

  bool isLoading = true;

  DateTime _selectedDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _focusedDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  loadPrescriptions() async {
    isLoading = true;
    final retrievedPrescriptions =
        await patientService.getPrescriptionByPatientAndSelectdTime(
            widget.patient.bhtNumber!,
            DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day));
    setState(() {
      this.prescriptionsList = retrievedPrescriptions;
      isLoading = false;
    });
  }

  loadParameters() async {
    // isLoading = true;
    final retrievedParameters =
        await patientService.getParametersByPatientAndTimeStampDesc(
            widget.patient.bhtNumber!,
            DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day));
    setState(() {
      this.parametersList = retrievedParameters;
      isLoading = false;
    });
  }

  Parameters? prepareParametersToSave(double? value, String name) {
    if (value == null) {
      return null;
    }
    return Parameters(
      bhtNumber: widget.patient.bhtNumber!,
      name: name,
      value: value,
      slot: 0,
      createdDateTime: DateTime.now(),
      measuredDate:
          DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day),
    );
  }

  saveParameters() {
    final formState = _formStateKey.currentState;
    formState!.save();

    List<Parameters?> temp = [];

    List<Parameters> toBeSaved = [];
    temp.add(prepareParametersToSave(bpValue, 'bp'));
    temp.add(prepareParametersToSave(cbsValue, 'cbs'));
    temp.add(prepareParametersToSave(spo2Value, 'spo2'));
    temp.add(prepareParametersToSave(rrValue, 'rr'));
    temp.add(prepareParametersToSave(prValue, 'pr'));

    toBeSaved = temp
        .where((element) => double.nan != element!.value)
        .toList()
        .whereType<Parameters>()
        .toList();

    // toBeSaved = temp.whereType<Parameters>().toList();

    print(toBeSaved);

    patientService.createParameters(toBeSaved);
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
        child: AddPrescription(
          selectedDate:
              DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day),
          bhtNumber: widget.patient.bhtNumber!,
          title: 'Add Drug Chart',
          prescriptionsList: prescriptionsList,
          onRefresh: loadPrescriptions,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    patientService = PatientService();
    loadParameters();
    loadPrescriptions();
  }

  getInputDecoration(String label, {String? hint}) {
    return InputDecoration(
      isDense: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      labelText: label,
      labelStyle: TextStyle(fontSize: 15.0),
      hintText: hint,
    );
  }

  void _showParameterInputDialog() {
    showDialog(
      context: context,
      builder: (context) {
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
            child: Text('Enter parameters'),
          ),
          content: Container(
            height: 225,
            child: Form(
              key: _formStateKey,
              autovalidateMode: AutovalidateMode.always,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 100,
                          child: TextFormField(
                            onSaved: (input) {
                              bpValue = input!.isNotEmpty
                                  ? double.parse(input)
                                  : double.nan;
                            },
                            decoration: getInputDecoration("BP"),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Container(
                          width: 100,
                          child: TextFormField(
                            onSaved: (input) {
                              cbsValue = input!.isNotEmpty
                                  ? double.parse(input)
                                  : double.nan;
                            },
                            decoration: getInputDecoration("CBS"),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 100,
                          child: TextFormField(
                            onSaved: (input) {
                              prValue = input!.isNotEmpty
                                  ? double.parse(input)
                                  : double.nan;
                            },
                            decoration: getInputDecoration("PR"),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Container(
                          width: 100,
                          child: TextFormField(
                            onSaved: (input) {
                              rrValue = input!.isNotEmpty
                                  ? double.parse(input)
                                  : double.nan;
                            },
                            decoration: getInputDecoration("RR"),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      onSaved: (input) {
                        spo2Value = input!.isNotEmpty
                            ? double.parse(input)
                            : double.nan;
                      },
                      decoration: getInputDecoration("SPO2"),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
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
                  saveParameters();
                },
                child: Text('Add'))
          ],
        );
      },
    );
  }

  void _showDialog(DateTime date) {
    showDialog(
      context: context,
      builder: (context) {
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
            child: Text(DateFormat('MMMMEEEEd').format(date)),
          ),
          content: Container(
            width: 50,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  child: Text('Add Parameters'),
                  onTap: () {
                    Navigator.pop(context);
                    _showParameterInputDialog();
                  },
                ),
                Divider(
                  thickness: 2,
                ),
                Text('Add Investigations'),
                Divider(
                  thickness: 2,
                ),
                GestureDetector(
                    child: Text('Add Drug Chart'),
                    onTap: () {
                      print('Add management');
                      Navigator.pop(context);
                      _showModalSheet();
                    }),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TableCalendar(
            firstDay: DateTime(2021, 01, 01),
            lastDay: DateTime.now(),
            focusedDay: _selectedDay,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
            ),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              print('selected');

              setState(() {
                this._selectedDay = selectedDay;
                this._focusedDay =
                    focusedDay; // update `_focusedDay` here as well
              });

              loadParameters();
              loadPrescriptions();
            },
            calendarFormat: CalendarFormat.week,
            onPageChanged: (focusedDay) {
              this._focusedDay = focusedDay;
            },
            onDayLongPressed: (selectedDay, focussedDay) {
              _showDialog(selectedDay);
              setState(() {
                this._selectedDay = selectedDay;
              });
              print(selectedDay);

              print('long pressed');
            },
          ),
          isLoading
              ? circularProgress()
              : ManagementDetailsContainer(
                  patient: widget.patient,
                  selectedDay: _selectedDay,
                  drugsListList: drugsListList,
                  prescriptionsList: prescriptionsList,
                  parametersList: parametersList,
                ),
        ],
      ),
    );
  }
}
