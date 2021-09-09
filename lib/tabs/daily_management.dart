import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/common/common_style.dart';
import 'package:hdu_management/models/investigations.dart';
import 'package:hdu_management/models/parameters.dart';
import 'package:hdu_management/models/patient.dart';
import 'package:hdu_management/models/prescription.dart';
import 'package:hdu_management/services/patient_service.dart';
import 'package:hdu_management/widgets/management_details_container.dart';
import 'package:hdu_management/widgets/prescription/add_prescription.dart';
import 'package:hdu_management/widgets/progress.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class DailyManagement extends StatefulWidget {
  final Patient patient;
  const DailyManagement({Key? key, required this.patient}) : super(key: key);
  @override
  _DailyManagementState createState() => _DailyManagementState();
}

class _DailyManagementState extends State<DailyManagement> {
  final _parameterFormStateKey = GlobalKey<FormState>();
  final _investigationFormStateKey = GlobalKey<FormState>();
  final _investigationDateController = TextEditingController();
  final _investigationTimeController = TextEditingController();

  late PatientService _patientService;

  late List<Parameters> _parametersList = [];
  late List<Prescription> _prescriptionsList = [];
  late List<Investigations> _investigationsList = [];

  Map<String, String> _parameterInputMap = {};
  int _selectedSlot = -1;

  bool _isLoadingPrescriptions = true;
  bool _isLoadingParameters = true;
  bool _isLoadingInvestigations = true;

  DateTime _selectedDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  DateTime _focusedDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  final _textEditingController = TextEditingController();

  final _investigationsListItems = [
    'WBC (10^9/l)',
    'Hb (g/dl)',
    'PLT (10^9/l)',
    'CRP (mg/l)',
    'S.Cr (mg/dl)',
    'B.U (mg/dl)',
    'Na+ (mEq/dl)',
    'K+ (mEq/l)',
    'Procalcitonin (hg/ml)',
    'AST (u/l)',
    'ALT (u/l)',
    'PT (sec)',
    'INR',
    'LDH (u/l)',
    'Albumin'
  ];

  int _selectedInvestigation = -1;
  double? _investigationValue;
  DateTime? _investigationSampleDTM = DateTime.now();

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

  List<Investigations> filterLatestInvestigations(
      List<Investigations> investigations) {
    Map<String, Investigations> testWiseInvestigations = {};

    for (int i = 0; i < investigations.length; ++i) {
      // testWiseInvestigations.putIfAbsent(
      //     investigations.elementAt(i).test, () => investigations.elementAt(i));

      testWiseInvestigations[investigations.elementAt(i).test] =
          investigations.elementAt(i);
    }

    return testWiseInvestigations.values.toList();
  }

  void _loadInvestigations() async {
    _isLoadingInvestigations = true;
    await Future.delayed(Duration(milliseconds: 200));
    final retrievedInvestigations =
        await _patientService.getInvestigationsByPatientAndSelectedDate(
      widget.patient.bhtNumber!,
      DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day).add(
          Duration(hours: DateTime.now().hour, minutes: DateTime.now().minute)),
    );

    setState(() {
      this._investigationsList =
          filterLatestInvestigations(retrievedInvestigations);
      _isLoadingInvestigations = false;
    });
  }

  void _saveParameters() {
    final formState = _parameterFormStateKey.currentState;

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

  void _saveInvestigations() {
    final formState = _investigationFormStateKey.currentState;

    if (formState!.validate()) {
      formState.save();

      var tobeSaved = Investigations(
        bhtNumber: widget.patient.bhtNumber!,
        test: _investigationsListItems.elementAt(_selectedInvestigation),
        value: _investigationValue.toString(),
        sampleDateTime: _investigationSampleDTM!,
        createdDateTime: DateTime.now(),
      );

      _patientService.createInvestigations(tobeSaved);

      _loadInvestigations();
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

  List<DropdownMenuItem> getInvestigationDropDownMenuItems() {
    List<DropdownMenuItem> items = _investigationsListItems.map((e) {
      return DropdownMenuItem(
        child: Text(e),
        value: _investigationsListItems.indexOf(e),
      );
    }).toList();

    return items;
  }

  onTapInvestigationDatePicker() async {
    try {
      this._investigationSampleDTM = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019, 01, 01),
        lastDate: DateTime.now(),
      );

      _investigationDateController.text =
          '${_investigationSampleDTM!.day}/${_investigationSampleDTM!.month}/${_investigationSampleDTM!.year}';
    } catch (e) {
      print(e);
    }
  }

  onTapInvestigationTimePicker() async {
    try {
      var time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      _investigationTimeController.text = time!.format(context);
      _investigationSampleDTM = _investigationSampleDTM!
          .add(Duration(hours: time.hour, minutes: time.minute));

      print(time);

      print(_investigationSampleDTM);
    } catch (e) {
      print(e);
    }
  }

  void _showAddInvestigationsDialog() {
    print('Refreshed!');
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
            child: Text('Enter Investigation'),
          ),
          content: Container(
            // height: 225,
            child: Form(
              key: _investigationFormStateKey,
              autovalidateMode: AutovalidateMode.always,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      // width: 300,
                      child: DropdownButtonFormField(
                        validator: (dynamic value) {
                          if (value == null || value.toString().isEmpty) {
                            return 'Select Test';
                          }
                          return null;
                        },
                        onChanged: (dynamic value) {
                          setState(() {
                            _selectedInvestigation =
                                int.parse(value.toString());
                          });

                          print(_selectedInvestigation);
                        },
                        decoration: getInputDecorationTextFormField('Test'),
                        items: getInvestigationDropDownMenuItems(),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 115,
                          child: TextFormField(
                            validator: (input) {
                              if (input == null || input.isEmpty) {
                                return 'Select Date';
                              }
                              return null;
                            },
                            readOnly: true,
                            controller: _investigationDateController,
                            onTap: onTapInvestigationDatePicker,
                            onChanged: (input) {
                              print(input);
                            },
                            onSaved: (input) {},
                            decoration: getInputDecorationTextFormField(
                              'Sample Date',
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Container(
                          width: 115,
                          child: TextFormField(
                            validator: (input) {
                              if (input == null || input.isEmpty) {
                                return 'Select Time';
                              }
                              return null;
                            },
                            readOnly: true,
                            controller: _investigationTimeController,
                            onTap: onTapInvestigationTimePicker,
                            onChanged: (input) {
                              print(input);
                            },
                            onSaved: (input) {},
                            decoration: getInputDecorationTextFormField(
                              'Sample Time',
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      // width: 100,
                      child: TextFormField(
                        validator: (input) {
                          if (input != null && input.isNotEmpty) {
                            return null;
                          }
                          return 'Please enter value';
                        },
                        onSaved: (input) {
                          if (input != null && input.isNotEmpty)
                            _investigationValue = double.parse(input);
                        },
                        decoration: getInputDecorationTextFormField(
                          'Value',
                        ),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  _investigationFormStateKey.currentState!.reset();
                  Navigator.pop(context);
                },
                child: Text('Cancel')),
            TextButton(
                onPressed: () {
                  _saveInvestigations();
                },
                child: Text('Add'))
          ],
        );
      },
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
              key: _parameterFormStateKey,
              autovalidateMode: AutovalidateMode.always,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              if (value == null || value.isEmpty) {
                                return null;
                              } else if (value.isNotEmpty &&
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
                  _parameterFormStateKey.currentState!.reset();
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

  // @override
  // void dispose() {
  //   super.dispose();
  //   _formStateKey.currentState!.dispose();
  // }

  @override
  void initState() {
    super.initState();
    _patientService = PatientService();
    _loadParameters();
    _loadPrescriptions();
    _loadInvestigations();
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
              _loadInvestigations();
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
          _isLoadingPrescriptions ||
                  _isLoadingParameters ||
                  _isLoadingInvestigations
              ? circularProgress()
              : ManagementDetailsContainer(
                  onAddParameters: _showParameterInputDialog,
                  patient: widget.patient,
                  selectedDay: _selectedDay,
                  prescriptionsList: _prescriptionsList,
                  parametersList: _parametersList,
                  investigationsList: _investigationsList,
                  onAddPrescription: _showAddPrescriptionModalSheet,
                  onAddInvestigations: _showAddInvestigationsDialog,
                ),
        ],
      ),
    );
  }
}
