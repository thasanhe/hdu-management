import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hdu_management/models/gender.dart';
import 'package:hdu_management/models/patient_status.dart';
import 'package:hdu_management/utils/utils.dart';

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

  double? bhtNumber;
  int? bedNumber;

  Patient({
    required this.name,
    required this.age,
    required this.gender,
    required this.symptomsDate,
    required this.pcrRatDate,
    required this.currentStatus,
    this.id,
    this.nic,
    this.contactNumber,
    this.dateOfAdmissionHospital,
    this.dateOfAdmissionHDU,
    this.dateOfDischarge,
    this.dateOfTransfer,
    this.dateOfLama,
    this.dateOfDeath,
    this.bhtNumber,
    this.bedNumber,
  });

  //rotine data
  //medical managment
  //monitoring params

  // List<Object>  status; // admitted/date, discharged/date, death/date, transferred/date, lama/date etc

  factory Patient.fromDocument(DocumentSnapshot doc) {
    Timestamp pcrRatDate = doc['pcrRatDate'] as Timestamp;
    Timestamp symptomsDate = doc['symptomsDate'] as Timestamp;
    Timestamp dateOfAdmissionHDU = doc['dateOfAdmissionHDU'] as Timestamp;

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
    );

    return p;
  }
}
