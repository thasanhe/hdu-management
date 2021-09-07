import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hdu_management/models/gender.dart';
import 'package:hdu_management/models/on_admission_status.dart';
import 'package:hdu_management/models/patient.dart';
import 'package:hdu_management/services/patient_service.dart';

import 'package:textfield_tags/textfield_tags.dart';

class Admission extends StatefulWidget {
  final List<int?>? occupiedBeds;
  final VoidCallback onRefresh;
  const Admission(
      {Key? key, required this.occupiedBeds, required this.onRefresh})
      : super(key: key);

  @override
  _AdmissionPageState createState() => _AdmissionPageState();
}

class _AdmissionPageState extends State<Admission> {
  final _formStateKey = GlobalKey<FormState>();
  final _symtompsDateController = TextEditingController();
  final _pcrRatDateController = TextEditingController();
  final _bedInputController = TextEditingController();
  final _doaHduController = TextEditingController();
  final _doaHospitalController = TextEditingController();
  final _firstDoseController = TextEditingController();
  final _secondDoseController = TextEditingController();

  String? name;
  String? bht;
  String? gender;
  DateTime? symptomsDate;
  DateTime? pcrRatDate;
  int? bedNumber;
  int? age;
  String? symptoms;
  String? history;
  String? nic;
  DateTime? dateOfAdmissionHospital = DateTime.now();
  DateTime? dateOfAdmissionToHdu = DateTime.now();
  DateTime? dateOfFirstDose;
  DateTime? dateOfSecondDose;
  String? contactNumber;
  late PatientService patientService;

  List<String> symptomsList = [];
  List<String> coMobList = [];
  List<String> surgHistList = [];
  List<String> alergiesList = [];

  String? vaccinationStatus = 'Not Vaccinated';
  String? vaccine;

  @override
  initState() {
    super.initState();
    patientService = PatientService();
  }

  submit() async {
    FocusScope.of(context).unfocus();
    final formState = _formStateKey.currentState;
    print("On submit");
    if (formState!.validate()) {
      print("Form state valid");
      formState.save();
      print("Form state save");
      Patient patient = Patient(
          dateOfAdmissionHDU: this.dateOfAdmissionToHdu,
          id: this.bht,
          name: this.name!,
          bhtNumber: double.parse(this.bht!),
          gender: this.gender == 'Male' ? Gender.male : Gender.female,
          currentStatus: 'inward',
          symptomsDate: this.symptomsDate!,
          pcrRatDate: this.pcrRatDate!,
          bedNumber: this.bedNumber,
          age: this.age!,
          nic: this.nic,
          dateOfAdmissionHospital: this.dateOfAdmissionHospital,
          contactNumber: this.contactNumber,
          currentStatusDate: this.dateOfAdmissionHospital,
          vaccinatedStatus: this.vaccinationStatus,
          dateOFFirstDose: this.dateOfFirstDose,
          dateOFSecondDose: this.dateOfSecondDose,
          vaccine: this.vaccine);

      OnAdmissionStatus status = OnAdmissionStatus(
        bhtNumber: double.parse(this.bht!),
        symptoms: this.symptomsList,
        coMobidities: this.coMobList,
        alergies: this.alergiesList,
        surgicalHistory: this.surgHistList,
      );
      String alertTitle = 'Patient successfully admitted!';
      String alertContent = '';
      try {
        print("Before create");
        await patientService.createPatientOnAdmissionStatus(status);
        await patientService.createPatient(patient);
        formState.reset();
      } catch (error) {
        alertTitle = 'Error!';
        print(error);
        if (error.toString() == 'Patient already admitted!') {
          alertContent =
              'Patient with the same bht already exists in the system. Check the bht and try again';
        }
      }
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(alertTitle),
            content: Text(alertContent),
            actions: [
              TextButton(
                  onPressed: () {
                    if (alertTitle == 'Error!') {
                      Navigator.pop(context);
                    }

                    Navigator.popUntil(context, (route) => route.isFirst);
                    widget.onRefresh();
                  },
                  child: Text('OK'))
            ],
          );
        },
      );
    }
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

  getInputDecorationCalendar(String label, {String? hint}) {
    return InputDecoration(
      isDense: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      labelText: label,
      labelStyle: TextStyle(fontSize: 15.0),
      hintText: hint,
      prefixIcon: Icon(CupertinoIcons.calendar),
    );
  }

  onTapDatePickerSymptoms() async {
    try {
      this.symptomsDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 30)),
        lastDate: DateTime.now(),
      );
      _symtompsDateController.text =
          '${symptomsDate!.day}/${symptomsDate!.month}/${symptomsDate!.year}';
    } catch (e) {
      print(e);
    }
  }

  onTapDatePickerPCR() async {
    try {
      this.pcrRatDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 30)),
        lastDate: DateTime.now(),
      );

      _pcrRatDateController.text =
          '${pcrRatDate!.day}/${pcrRatDate!.month}/${pcrRatDate!.year}';
    } catch (e) {
      print(e);
    }
  }

  onTapDatePickerDOAHdu() async {
    try {
      this.dateOfAdmissionToHdu = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 30)),
        lastDate: DateTime.now(),
      );

      _doaHduController.text =
          '${dateOfAdmissionToHdu!.day}/${dateOfAdmissionToHdu!.month}/${dateOfAdmissionToHdu!.year}';
    } catch (e) {
      print(e);
    }
  }

  onTapDatePickerFirstDose() async {
    try {
      this.dateOfFirstDose = await showDatePicker(
        context: context,
        initialDate:
            dateOfFirstDose != null ? dateOfFirstDose! : DateTime.now(),
        firstDate: DateTime(2019, 01, 01),
        lastDate: dateOfSecondDose != null ? dateOfSecondDose! : DateTime.now(),
      );

      _firstDoseController.text =
          '${dateOfFirstDose!.day}/${dateOfFirstDose!.month}/${dateOfFirstDose!.year}';
    } catch (e) {
      print(e);
    }
  }

  onTapDatePickerSecondDose() async {
    try {
      this.dateOfSecondDose = await showDatePicker(
        context: context,
        initialDate:
            dateOfSecondDose != null ? dateOfSecondDose! : DateTime.now(),
        firstDate:
            dateOfFirstDose != null ? dateOfFirstDose! : DateTime(2019, 01, 01),
        lastDate: DateTime.now(),
      );

      _secondDoseController.text =
          '${dateOfSecondDose!.day}/${dateOfSecondDose!.month}/${dateOfSecondDose!.year}';
    } catch (e) {
      print(e);
    }
  }

  onTapDatePickerDOAHospital() async {
    try {
      this.dateOfAdmissionHospital = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 30)),
        lastDate: DateTime.now(),
      );

      _doaHospitalController.text =
          '${dateOfAdmissionHospital!.day}/${dateOfAdmissionHospital!.month}/${dateOfAdmissionHospital!.year}';
    } catch (e) {
      print(e);
    }
  }

  Container getBedItem(int number, isAvailable) {
    return Container(
      width: 50,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isAvailable ? Colors.blue[400] : Colors.grey,
      ),
      child: TextButton(
        onPressed: isAvailable
            ? () {
                Navigator.pop(context);
                _bedInputController.text = number.toString();
              }
            : null,
        child: Text(
          number.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  List<Row> getBedRows() {
    final bedCount = 20;
    final columnCount = 4;
    List<Row> bedRows = [];

    List<Container> rowElements = [];
    print("Get beds");
    print(widget.occupiedBeds);

    for (var i = 1; i <= bedCount; ++i) {
      rowElements.add(getBedItem(
          i,
          widget.occupiedBeds == null
              ? false
              : !widget.occupiedBeds!.contains(i)));
      if (i % columnCount == 0) {
        bedRows.add(Row(
          children: rowElements,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ));
        rowElements = [];
      }
    }

    return bedRows;
  }

  getBedPicker() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        title: Text('Please select a bed'),
        content: Container(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: getBedRows(),
          ),
        ),
      ),
    );
  }

  getTextFieldwithTags(
      String helperText, String hintText, List<String> tagsCollector) {
    return TextFieldTags(
      textSeparators: [',', '.', ' '],
      tagsStyler: TagsStyler(
        tagTextStyle: TextStyle(color: Colors.white),
        tagDecoration: BoxDecoration(
          color: const Color.fromARGB(255, 171, 81, 81),
          borderRadius: BorderRadius.circular(8.0),
        ),
        tagCancelIcon: Icon(Icons.cancel,
            size: 20.0, color: Color.fromARGB(255, 235, 214, 214)),
        tagPadding: const EdgeInsets.all(5.0),
      ),
      textFieldStyler: TextFieldStyler(
        helperText: helperText,
        // helperText: '',
        hintText: hintText,
        textFieldBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        isDense: true,
      ),
      onTag: (tag) {
        if (tag.trim().isNotEmpty) {
          tagsCollector.add(tag);
          print(tagsCollector);
        }
      },
      onDelete: (tag) {
        tagsCollector.remove(tag);
        print(tagsCollector);
      },
    );
  }

  @override
  Widget build(BuildContext parentContext) {
    return ListView(
      children: [
        Container(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                child: Form(
                  key: _formStateKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (input) {
                          if (input!.isEmpty) {
                            return "Please enter patient's name";
                          }
                          return null;
                        },
                        onSaved: (input) => {name = input},
                        decoration: getInputDecoration("Patient Name"),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      DropdownButtonFormField<String>(
                        validator: (input) {
                          if (input == null || input.isEmpty) {
                            return "Please select Gender";
                          }
                          return null;
                        },
                        decoration: getInputDecoration("Gender"),
                        items: <String>['Male', 'Female'].map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onSaved: (input) => {gender = input},
                        onChanged: (input) => {gender = input},
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (input) {
                          if (input == null || input.isEmpty) {
                            return "Please enter BHT Number";
                          }
                          return null;
                        },
                        onSaved: (input) => {bht = input},
                        decoration: getInputDecoration("BHT Number"),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        readOnly: true,
                        controller: _bedInputController,
                        onTap: getBedPicker,
                        onSaved: (input) => {
                          bedNumber = input != null && input.isNotEmpty
                              ? int.parse(input)
                              : null
                        },
                        decoration: getInputDecoration("Bed Number"),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (input) {
                          if (input == null || input.isEmpty) {
                            return "Please enter Age";
                          }
                          return null;
                        },
                        onSaved: (input) => {age = int.parse(input!)},
                        decoration: getInputDecoration("Age"),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _symtompsDateController,
                        validator: (input) {
                          if (input == null || input.isEmpty) {
                            return "Please select symptoms Started Date";
                          }
                          return null;
                        },
                        onTap: onTapDatePickerSymptoms,
                        decoration:
                            getInputDecorationCalendar("Symptoms stated date"),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      getTextFieldwithTags('Add Symptoms seperated by space',
                          'Add Symptoms', symptomsList),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _pcrRatDateController,
                        validator: (input) {
                          if (input == null || input.isEmpty) {
                            return "Please select PCR/RAT positive date";
                          }
                          return null;
                        },
                        onTap: onTapDatePickerPCR,
                        decoration: getInputDecorationCalendar("PCR/RAT Date"),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      DropdownButtonFormField<String>(
                        validator: (input) {
                          if (input == null || input.isEmpty) {
                            return "Please select the vaccination status";
                          }
                          return null;
                        },
                        decoration: getInputDecoration("Vaccination Status"),
                        items: <String>[
                          'Not Vaccinated',
                          'One Dose',
                          'Two Doses'
                        ].map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onSaved: (input) => {vaccinationStatus = input},
                        onChanged: (input) {
                          print(input);
                          setState(() {
                            vaccinationStatus = input;
                          });
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Visibility(
                        visible: vaccinationStatus == 'One Dose' ||
                            vaccinationStatus == 'Two Doses',
                        child: DropdownButtonFormField<String>(
                          validator: (input) {
                            if (input == null || input.isEmpty) {
                              return "Please select the vaccine ";
                            }
                            return null;
                          },
                          decoration: getInputDecoration("Vaccine"),
                          items: <String>[
                            'CoviShield-AstraZeneca',
                            'Sinopharm',
                            'Pfizer',
                            'Moderna',
                            'Sputnik V',
                          ].map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                          onSaved: (input) => {vaccine = input},
                          onChanged: (input) {
                            print(input);
                            setState(() {
                              vaccine = input;
                            });
                          },
                        ),
                      ),
                      Visibility(
                        visible: vaccinationStatus == 'One Dose' ||
                            vaccinationStatus == 'Two Doses',
                        child: SizedBox(
                          height: 15,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: vaccinationStatus == 'One Dose' ||
                                vaccinationStatus == 'Two Doses',
                            child: Container(
                              width: 150,
                              child: TextFormField(
                                controller: _firstDoseController,
                                onTap: onTapDatePickerFirstDose,
                                decoration:
                                    getInputDecorationCalendar("1st Dose"),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: vaccinationStatus == 'One Dose' ||
                                vaccinationStatus == 'Two Doses',
                            child: SizedBox(
                              width: 15,
                            ),
                          ),
                          Visibility(
                            visible: vaccinationStatus == 'Two Doses',
                            child: Container(
                              width: 150,
                              child: TextFormField(
                                controller: _secondDoseController,
                                onTap: onTapDatePickerSecondDose,
                                decoration:
                                    getInputDecorationCalendar("2nd Dose"),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: vaccinationStatus == 'One Dose' ||
                            vaccinationStatus == 'Two Doses',
                        child: SizedBox(
                          height: 15,
                        ),
                      ),
                      TextFormField(
                        controller: _doaHduController,
                        validator: (input) {
                          if (input == null || input.isEmpty) {
                            return "Please select date of Admission to HDU";
                          }
                          return null;
                        },
                        onTap: onTapDatePickerDOAHdu,
                        decoration: getInputDecorationCalendar(
                            "Date of Admission - HDU"),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _doaHospitalController,
                        validator: (input) {
                          if (input == null || input.isEmpty) {
                            return "Please select date of Admission to Hospital";
                          }
                          return null;
                        },
                        onTap: onTapDatePickerDOAHospital,
                        decoration: getInputDecorationCalendar(
                            "Date of Admission - Hospital"),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      getTextFieldwithTags(
                          'Add co-mobidities seperated by space',
                          'Add Co-Mobidities',
                          coMobList),
                      SizedBox(
                        height: 15,
                      ),
                      getTextFieldwithTags(
                          'Add surgical history seperated by space',
                          'Add Surgical History',
                          surgHistList),
                      SizedBox(
                        height: 15,
                      ),
                      getTextFieldwithTags('Add alergies seperated by space',
                          'Add Alergies', alergiesList),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.red[400],
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                GestureDetector(
                  onTap: submit,
                  child: Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
