import 'package:cloud_firestore/cloud_firestore.dart';

class DrugChart {
  double bhtNumber;
  List<String> durg;
  DateTime createdDateTime;
  DateTime prescribedDateTime;

  DrugChart({
    required this.bhtNumber,
    required this.durg,
    required this.createdDateTime,
    required this.prescribedDateTime,
  });

  factory DrugChart.fromDocument(DocumentSnapshot doc) {
    Timestamp createdTimestamp = doc['createdDateTime'] as Timestamp;
    Timestamp prescirbedDateTime = doc['prescribedDateTime'] as Timestamp;

    DrugChart temp = DrugChart(
      bhtNumber: doc['bhtNumber'],
      durg: List<String>.from(doc['drug']),
      createdDateTime: createdTimestamp.toDate(),
      prescribedDateTime: prescirbedDateTime.toDate(),
    );

    return temp;
  }
}
