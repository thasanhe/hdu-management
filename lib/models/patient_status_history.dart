import 'package:hdu_management/models/patient_status.dart';

class PatientStatusHistory {
  String id; // bht
  PatientStatus patientStatus;
  DateTime date;
  PatientStatusHistory({
    required this.id,
    required this.patientStatus,
    required this.date,
  });
}
