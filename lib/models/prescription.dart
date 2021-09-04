import 'package:cloud_firestore/cloud_firestore.dart';

class Prescription {
  double bhtNumber;
  String drug;
  DateTime createdDateTime;
  DateTime prescribedDate;
  DateTime? omittedDate;

  Prescription({
    required this.bhtNumber,
    required this.drug,
    required this.createdDateTime,
    required this.prescribedDate,
    this.omittedDate,
  });

  factory Prescription.fromDocument(DocumentSnapshot doc) {
    Timestamp createdTimestamp = doc['createdDateTime'] as Timestamp;
    Timestamp prescirbedDateTime = doc['prescribedDate'] as Timestamp;
    Timestamp? omittedDate;

    try {
      omittedDate =
          null != doc['omittedDate'] ? doc['omittedDate'] as Timestamp : null;
    } catch (error) {}

    Prescription temp = Prescription(
      bhtNumber: doc['bhtNumber'],
      drug: doc['drug'],
      createdDateTime: createdTimestamp.toDate(),
      prescribedDate: prescirbedDateTime.toDate(),
      omittedDate: null != omittedDate ? omittedDate.toDate() : null,
    );

    return temp;
  }
}
