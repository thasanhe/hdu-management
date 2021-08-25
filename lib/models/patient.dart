import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hdu_management/models/gender.dart';

class Patient {
  String? id;
  String? nic;
  String name;
  int? age;
  DateTime? dateOfAdmission;
  String? contactNumber;
  Gender gender;

  int bhtNumber;

  Patient(
      {this.id,
      this.nic,
      required this.name,
      this.age,
      this.dateOfAdmission,
      this.contactNumber,
      required this.bhtNumber,
      required this.gender});

  factory Patient.fromDocument(DocumentSnapshot doc) {
    return Patient(
        name: doc['name'],
        bhtNumber: doc['bht'],
        gender: doc['gender'] == 'male' ? Gender.male : Gender.female);
  }
}
