import 'package:cloud_firestore/cloud_firestore.dart';

class OnAdmissionStatus {
  double bhtNumber;
  List<dynamic> symptoms;
  List<dynamic> alergies;
  List<dynamic> surgicalHistory;
  List<dynamic> coMobidities;

  OnAdmissionStatus({
    required this.bhtNumber,
    required this.symptoms,
    required this.alergies,
    required this.surgicalHistory,
    required this.coMobidities,
  });

  factory OnAdmissionStatus.fromDocument(DocumentSnapshot doc) {
    OnAdmissionStatus temp = OnAdmissionStatus(
      bhtNumber: doc['bhtNumber'],
      alergies: doc['alergies'] != null ? doc['alergies'] : [],
      coMobidities: doc['co_mobidities'] != null ? doc['co_mobidities'] : [],
      surgicalHistory:
          doc['surgical_history'] != null ? doc['surgical_history'] : [],
      symptoms: doc['symptoms'] != null ? doc['symptoms'] : [],
    );
    print("Temp");
    print(temp);

    return temp;
  }
}
