import 'package:cloud_firestore/cloud_firestore.dart';

class DailyManagement {
  double bhtNumber;
  List<String> management;
  DateTime createdDateTime;

  DailyManagement({
    required this.bhtNumber,
    required this.management,
    required this.createdDateTime,
  });

  factory DailyManagement.fromDocument(DocumentSnapshot doc) {
    Timestamp createdTimestamp = doc['createdDateTime'] as Timestamp;

    DailyManagement temp = DailyManagement(
      bhtNumber: doc['bhtNumber'],
      management: List<String>.from(doc['management']),
      createdDateTime: createdTimestamp.toDate(),
    );

    return temp;
  }

  // factory DailyManagement.fromMap(Map<String, bool> managmentMap, double bhtNumber) {

  //   // DailyManagement temp = DailyManagement(
  //   //   bhtNumber: bhtNumber,
  //   //   management:

  //   // );
  //   // return temp;
  // }
}
