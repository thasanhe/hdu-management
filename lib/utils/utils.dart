import 'package:hdu_management/models/patient_status.dart';

class Utils {
  static PatientStatus patientStatusFromString(String status) {
    if (status == 'inward')
      return PatientStatus.inward;
    else if (status == 'discharged')
      return PatientStatus.discharged;
    else if (status == 'transferred')
      return PatientStatus.transferred;
    else if (status == 'lama')
      return PatientStatus.lama;
    else if (status == 'death') return PatientStatus.death;
    return PatientStatus.unknown;
  }

  static String patientStatusToString(PatientStatus status) {
    if (status == PatientStatus.inward)
      return 'inward';
    else if (status == PatientStatus.discharged)
      return 'discharged';
    else if (status == PatientStatus.transferred)
      return 'transferred';
    else if (status == PatientStatus.lama)
      return 'lama';
    else if (status == PatientStatus.death) return 'death';
    return 'unknown';
  }
}
