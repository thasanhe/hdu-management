import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/models/gender.dart';
import 'package:hdu_management/models/patient.dart';
import 'package:hdu_management/services/patient_service.dart';

class Admission extends StatefulWidget {
  const Admission({Key? key}) : super(key: key);

  @override
  _AdmissionPageState createState() => _AdmissionPageState();
}

class _AdmissionPageState extends State<Admission> {
  final _formStateKey = GlobalKey<FormState>();
  String? name;
  String? bht;
  String? gender;
  late PatientService patientService;

  @override
  initState() {
    super.initState();
    patientService = PatientService();
  }

  submit() async {
    FocusScope.of(context).unfocus();
    final formState = _formStateKey.currentState;
    if (formState!.validate()) {
      formState.save();
      Patient patient = Patient(
          dateOfAdmission: DateTime.now(),
          id: this.bht,
          name: this.name!,
          bhtNumber: int.parse(this.bht!),
          gender: this.gender == 'Male' ? Gender.male : Gender.female);
      String alertTitle = 'Patient successfully admitted!';
      try {
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
      border: OutlineInputBorder(),
      labelText: label,
      labelStyle: TextStyle(fontSize: 15.0),
      hintText: hint,
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
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: submit,
              child: Container(
                height: 50,
                width: 350,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(7.0)),
                child: Center(
                  child: Text(
                    "Submit",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 50,
                width: 350,
                decoration: BoxDecoration(
                    color: Colors.red[400],
                    borderRadius: BorderRadius.circular(7.0)),
                child: Center(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ]),
        )
      ],
    );
  }
}
