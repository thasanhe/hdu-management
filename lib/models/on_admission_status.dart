import 'package:cloud_firestore/cloud_firestore.dart';

class OnAdmissionStatus {
  double bhtNumber;
  List<dynamic>? symptoms = [];
  List<dynamic>? alergies = [];
  List<dynamic>? surgicalHistory = [];
  List<dynamic>? coMobidities = [];

  OnAdmissionStatus({
    required this.bhtNumber,
    this.symptoms,
    this.alergies,
    this.surgicalHistory,
    this.coMobidities,
  });

  factory OnAdmissionStatus.fromDocument(DocumentSnapshot doc) {
    return OnAdmissionStatus(
      bhtNumber: doc['bhtNumber'],
      alergies: doc['alergies'],
      coMobidities: doc['co_mobidities'],
      surgicalHistory: doc['surgical_history'],
      symptoms: doc['symptoms'],
    );
  }
}
