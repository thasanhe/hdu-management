import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/common/common_style.dart';
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

  late PatientService _patientService;

  late List<Parameters> _parametersList = [];
  late List<Prescription> _prescriptionsList = [];

  Map<String, String> _parameterInputMap = {};
  int _selectedSlot = -1;

  bool _isLoadingPrescriptions = true;
  bool _isLoadingParameters = true;

  DateTime _selectedDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  DateTime _focusedDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  final _textEditingController = TextEditingController();

  void _loadPrescriptions() async {
    _isLoadingPrescriptions = true;
    await Future.delayed(Duration(milliseconds: 200));
    final retrievedPrescriptions =
        await _patientService.getPrescriptionByPatientAndSelectdTime(
            widget.patient.bhtNumber!,
            DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day));
    setState(() {
      this._prescriptionsList = retrievedPrescriptions;
      _isLoadingPrescriptions = false;
    });
  }

  void _loadParameters() async {
    _isLoadingParameters = true;
    await Future.delayed(Duration(milliseconds: 200));
    final retrievedParameters =
        await _patientService.getParametersByPatientAndMeasuredDate(
            widget.patient.bhtNumber!,
            DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day));
    setState(() {
      this._parametersList = retrievedParameters;
      _isLoadingParameters = false;
    });
  }

  void _saveParameters() {
    final formState = _formStateKey.currentState;

    if (formState!.validate()) {
      formState.save();

      final toBeSaved = _parameterInputMap.entries.map((e) {
        return Parameters(
          bhtNumber: widget.patient.bhtNumber!,
          name: e.key,
          value: e.value,
          slot: _selectedSlot,
          createdDateTime: DateTime.now(),
          measuredDate:
              DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day),
        );
      }).toList();

      _patientService.createParameters(toBeSaved);

      _loadParameters();
      _parameterInputMap = {};
      formState.reset();
      Navigator.pop(context);
    }
  }

  void _showAddPrescriptionModalSheet() {
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
          prescriptionsList: _prescriptionsList,
          onRefresh: _loadPrescriptions,
        ),
      ),
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
                          child: DropdownButtonFormField(
                            validator: (value) {
                              if (value == null || value.toString().isEmpty) {
                                return 'Select';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _selectedSlot = int.parse(value.toString());
                              });
                            },
                            decoration: getInputDecorationTextFormField('Slot'),
                            items: [
                              DropdownMenuItem(
                                child: Text('6 AM'),
                                value: 0,
                              ),
                              DropdownMenuItem(
                                child: Text('12 PM'),
                                value: 1,
                              ),
                              DropdownMenuItem(
                                child: Text('6 PM'),
                                value: 2,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 100,
                          child: TextFormField(
                            validator: (value) {
                              if (value != null &&
                                  value.isNotEmpty &&
                                  value.split('/').length == 2) {
                                //checking for sys/dia
                                return null;
                              }
                              return 'sys.dia';
                            },
                            controller: _textEditingController,
                            onChanged: (input) {
                              setState(() {
                                if (input.contains('.')) {
                                  _textEditingController.text =
                                      input.replaceAll('.', '/');
                                  _textEditingController.selection =
                                      TextSelection.collapsed(
                                          offset: _textEditingController
                                              .text.length);
                                }
                              });
                            },
                            onSaved: (input) {
                              if (input != null && input.isNotEmpty)
                                _parameterInputMap.putIfAbsent(
                                    'bp', () => input);
                            },
                            decoration: getInputDecorationTextFormField("BP",
                                hint: 'sys.dia'),
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
                              if (input != null && input.isNotEmpty)
                                _parameterInputMap.putIfAbsent(
                                    'cbs', () => input);
                            },
                            decoration: getInputDecorationTextFormField("CBS"),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Container(
                          width: 100,
                          child: TextFormField(
                            onSaved: (input) {
                              if (input != null && input.isNotEmpty)
                                _parameterInputMap.putIfAbsent(
                                    'spo2', () => input);
                            },
                            decoration: getInputDecorationTextFormField("SPO2"),
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
                              if (input != null && input.isNotEmpty)
                                _parameterInputMap.putIfAbsent(
                                    'pr', () => input);
                            },
                            decoration: getInputDecorationTextFormField("PR"),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Container(
                          width: 100,
                          child: TextFormField(
                            onSaved: (input) {
                              if (input != null && input.isNotEmpty)
                                _parameterInputMap.putIfAbsent(
                                    'rr', () => input);
                            },
                            decoration: getInputDecorationTextFormField("RR"),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                      ],
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
                  _saveParameters();
                },
                child: Text('Add'))
          ],
        );
      },
    );
  }

  void _showManagementInputDialog(DateTime date) {
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
                      _showAddPrescriptionModalSheet();
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
  void dispose() {
    super.dispose();
    _formStateKey.currentState!.dispose();
  }

  @override
  void initState() {
    super.initState();
    _patientService = PatientService();
    _loadParameters();
    _loadPrescriptions();
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

              _loadParameters();
              _loadPrescriptions();
            },
            calendarFormat: CalendarFormat.week,
            onPageChanged: (focusedDay) {
              this._focusedDay = focusedDay;
            },
            onDayLongPressed: (selectedDay, focussedDay) {
              _showManagementInputDialog(selectedDay);
              setState(() {
                this._selectedDay = selectedDay;
              });
              print(selectedDay);

              print('long pressed');
            },
          ),
          _isLoadingPrescriptions || _isLoadingParameters
              ? circularProgress()
              : ManagementDetailsContainer(
                  patient: widget.patient,
                  selectedDay: _selectedDay,
                  prescriptionsList: _prescriptionsList,
                  parametersList: _parametersList,
                ),
        ],
      ),
    );
  }
}
