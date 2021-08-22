import 'package:hdu_management/models/gender.dart';

class Patient {
  String? nic;
  String name;
  int? age;
  DateTime? dateOfBirth;
  String? contactNumber;
  Gender gender;

  int bhtNumber;

  Patient(
      {this.nic,
      required this.name,
      this.age,
      this.dateOfBirth,
      this.contactNumber,
      required this.bhtNumber,
      required this.gender});
}
