import 'package:cloud_firestore/cloud_firestore.dart';

class Parameters {
  double bhtNumber;

  double? bp;
  double? cbs;
  double? pr;
  double? rr;
  double? spo2;
  int slot;

  DateTime createdDateTime;
  Parameters({
    required this.bhtNumber,
    this.bp,
    this.cbs,
    this.pr,
    this.rr,
    this.spo2,
    required this.slot,
    required this.createdDateTime,
  });

  factory Parameters.fromDocument(DocumentSnapshot doc) {
    Timestamp createdTimestamp = doc['createdDateTime'] as Timestamp;

    Parameters temp = Parameters(
      bhtNumber: doc['bhtNumber'],
      createdDateTime: createdTimestamp.toDate(),
      bp: doc['bp'],
      cbs: doc['cbs'],
      pr: doc['pr'],
      rr: doc['rr'],
      spo2: doc['spo2'],
      slot: doc['slot'],
    );

    return temp;
  }
}
