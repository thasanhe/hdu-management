import 'package:cloud_firestore/cloud_firestore.dart';

class PatientStatus {
  double bhtNumber;
  String status;
  double? value1; //ipap, hfnc
  double? value2; //epap, nrbm
  String? unit;

  DateTime assignedDateTime;

  PatientStatus({
    required this.bhtNumber,
    required this.status,
    this.value1,
    this.value2,
    this.unit,
    required this.assignedDateTime,
  });

  factory PatientStatus.fromDocument(DocumentSnapshot doc) {
    Timestamp assignedDateTime = doc['assignedDateTime'] as Timestamp;
    double? value1;
    double? value2;
    String? unit;

    try {
      value1 = doc['value1'];
    } catch (e) {}

    try {
      value2 = doc['value2'];
    } catch (e) {}

    try {
      unit = doc['unit'];
    } catch (e) {}

    PatientStatus p = PatientStatus(
        bhtNumber: doc['bhtNumber'],
        status: doc['status'],
        value1: value1,
        value2: value2,
        unit: unit,
        assignedDateTime: assignedDateTime.toDate());

    return p;
  }
}
