import 'package:cloud_firestore/cloud_firestore.dart';

class Investigations {
  double bhtNumber;
  String test;
  String value;

  DateTime sampleDateTime;
  DateTime createdDateTime;

  Investigations({
    required this.bhtNumber,
    required this.test,
    required this.value,
    required this.sampleDateTime,
    required this.createdDateTime,
  });

  factory Investigations.fromDocument(DocumentSnapshot doc) {
    Timestamp createdTimestamp = doc['createdDateTime'] as Timestamp;
    Timestamp sampleDateTime = doc['sampleDateTime'] as Timestamp;

    Investigations temp = Investigations(
      bhtNumber: doc['bhtNumber'],
      createdDateTime: createdTimestamp.toDate(),
      sampleDateTime: sampleDateTime.toDate(),
      test: doc['test'],
      value: doc['value'],
    );

    return temp;
  }
}
