import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/models/gender.dart';
import 'package:hdu_management/models/patient.dart';
import 'package:hdu_management/models/patient_status.dart';
import 'package:hdu_management/services/patient_service.dart';

class Admission extends StatefulWidget {
  const Admission({Key? key}) : super(key: key);

  @override
  _AdmissionPageState createState() => _AdmissionPageState();
}

class _AdmissionPageState extends State<Admission> {
  final _formStateKey = GlobalKey<FormState>();
  final _symtompsDateController = TextEditingController();
  final _pcrRatDateController = TextEditingController();

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
  DateTime? dateOfAdmissionHospital;
  String? contactNumber;
  late PatientService patientService;

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
        dateOfAdmissionHDU: DateTime.now(),
        id: this.bht,
        name: this.name!,
        bhtNumber: double.parse(this.bht!),
        gender: this.gender == 'Male' ? Gender.male : Gender.female,
        currentStatus: PatientStatus.inward,
        symptomsDate: this.symptomsDate!,
        pcrRatDate: this.pcrRatDate!,
        bedNumber: this.bedNumber,
        age: this.age!,
        symptoms: this.symptoms,
        history: this.history,
        nic: this.nic,
        dateOfAdmissionHospital: this.dateOfAdmissionHospital,
        contactNumber: this.contactNumber,
      );
      String alertTitle = 'Patient successfully admitted!';
      try {
        print("Before create");
        await patientService.createPatient(patient);
        formState.reset();
      } catch (error) {
        alertTitle = error.toString();
      }
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(alertTitle),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                      // Navigator.pop(context);
                    },
                    child: Text('ok'))
              ],
            );
          });
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
                        onSaved: (input) => {bedNumber = int.parse(input!)},
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
                        // onSaved: (input) =>
                        //     {symptomsDate = DateTime.parse(input!)},
                        decoration: getInputDecoration("Symptoms stated date"),
                      ),
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
                        decoration: getInputDecoration("PCR/RAT Date"),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 15,
                      ),
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
        )
      ],
    );
  }
}
