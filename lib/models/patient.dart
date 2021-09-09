import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hdu_management/models/gender.dart';

class Patient {
  //Admission specific data,non growable
  String? id;
  String? nic;
  String name;
  int age;
  Gender gender;
  String? contactNumber;

  DateTime symptomsDate;
  DateTime pcrRatDate;

  DateTime? dateOfAdmissionHospital;

  String currentStatus;

  DateTime? dateOfAdmissionHDU;
  DateTime? dateOfDischarge;
  DateTime? dateOfTransfer;
  DateTime? dateOfLama;
  DateTime? dateOfDeath;

  DateTime? currentStatusDate;

  double? bhtNumber;
  int? bedNumber;

  double? currentStatusValue1;
  double? currentStatusValue2;

  String? currentStatusUnit;

  String? vaccinatedStatus;
  DateTime? dateOFFirstDose;
  DateTime? dateOFSecondDose;
  String? vaccine;

  Patient({
    this.id,
    this.nic,
    required this.name,
    required this.age,
    required this.gender,
    this.contactNumber,
    required this.symptomsDate,
    required this.pcrRatDate,
    this.dateOfAdmissionHospital,
    required this.currentStatus,
    this.dateOfAdmissionHDU,
    this.dateOfDischarge,
    this.dateOfTransfer,
    this.dateOfLama,
    this.dateOfDeath,
    this.bhtNumber,
    this.bedNumber,
    this.currentStatusValue1,
    this.currentStatusValue2,
    this.currentStatusUnit,
    this.currentStatusDate,
    this.vaccinatedStatus,
    this.dateOFFirstDose,
    this.dateOFSecondDose,
    this.vaccine,
  });

  //rotine data
  //medical managment
  //monitoring params

  // List<Object>  status; // admitted/date, discharged/date, death/date, transferred/date, lama/date etc

  factory Patient.fromDocument(DocumentSnapshot doc) {
    Timestamp pcrRatDate = doc['pcrRatDate'] as Timestamp;
    Timestamp symptomsDate = doc['symptomsDate'] as Timestamp;
    Timestamp dateOfAdmissionHDU = doc['dateOfAdmissionHDU'] as Timestamp;
    Timestamp dateOfAdmissionHospital =
        doc['dateOfAdmissionHospital'] as Timestamp;
    Timestamp currentStatusDate = doc['currentStatusDate'] as Timestamp;

    double? currentStatusValue1;
    double? currentStatusValue2;
    String? currentStatusUnit;

    Timestamp? dateOFFirstDose;
    Timestamp? dateOFSecondDose;

    String? vaccinatedStatus;
    String? vaccine;

    try {
      dateOFFirstDose = doc['dateOFFirstDose'];
    } catch (e) {}

    try {
      dateOFSecondDose = doc['dateOFSecondDose'];
    } catch (e) {}

    try {
      vaccinatedStatus = doc['vaccinatedStatus'];
    } catch (e) {}
    try {
      vaccine = doc['vaccine'];
    } catch (e) {}

    try {
      currentStatusValue1 = doc['currentStatusValue1'];
    } catch (e) {}

    try {
      currentStatusValue2 = doc['currentStatusValue2'];
    } catch (e) {}

    try {
      currentStatusUnit = doc['currentStatusUnit'];
    } catch (e) {}

    Patient p = Patient(
      name: doc['name'],
      bhtNumber: doc['bhtNumber'],
      age: doc['age'],
      gender: doc['gender'] == 'male' ? Gender.male : Gender.female,
      symptomsDate: symptomsDate.toDate(),
      pcrRatDate: pcrRatDate.toDate(),
      currentStatus: doc['currentStatus'],
      dateOfAdmissionHDU: dateOfAdmissionHDU.toDate(),
      bedNumber: doc['bedNumber'] != 100000 ? doc['bedNumber'] : null,
      dateOfAdmissionHospital: dateOfAdmissionHospital.toDate(),
      currentStatusValue1: currentStatusValue1,
      currentStatusValue2: currentStatusValue2,
      currentStatusUnit: currentStatusUnit,
      currentStatusDate: currentStatusDate.toDate(),
      vaccinatedStatus: vaccinatedStatus,
      vaccine: vaccine,
      dateOFFirstDose:
          dateOFFirstDose != null ? dateOFFirstDose.toDate() : null,
      dateOFSecondDose:
          dateOFSecondDose != null ? dateOFSecondDose.toDate() : null,
    );

    return p;
  }
}
