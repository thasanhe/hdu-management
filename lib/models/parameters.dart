import 'package:cloud_firestore/cloud_firestore.dart';

class Parameters {
  double bhtNumber;
  String name;
  double value;
  int slot;

  DateTime createdDateTime;
  DateTime measuredDate;
  Parameters({
    required this.bhtNumber,
    required this.name,
    required this.value,
    required this.slot,
    required this.createdDateTime,
    required this.measuredDate,
  });

  factory Parameters.fromDocument(DocumentSnapshot doc) {
    Timestamp createdTimestamp = doc['createdDateTime'] as Timestamp;
    Timestamp measuredDate = doc['measuredDate'] as Timestamp;

    Parameters temp = Parameters(
      bhtNumber: doc['bhtNumber'],
      createdDateTime: createdTimestamp.toDate(),
      measuredDate: measuredDate.toDate(),
      name: doc['name'],
      value: doc['value'],
      slot: doc['slot'],
    );

    return temp;
  }
}
