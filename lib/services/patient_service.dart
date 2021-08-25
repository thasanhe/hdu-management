import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hdu_management/models/gender.dart';
import 'package:hdu_management/models/patient.dart';

class PatientService {
  final patientsRef = FirebaseFirestore.instance.collection('patients');

  Future<List<Patient>> getAllPatients() async {
    List<Patient> patientList = [];
    final querySnapshot = await patientsRef.get();
    querySnapshot.docs.forEach((doc) {
      patientList.add(Patient.fromDocument(doc));
    });
    print('Retrieved patients');
    return patientList;
  }

  Future<String> createPatient(Patient patient) async {
    DocumentSnapshot pt = await patientsRef.doc(patient.id).get();
    if (!pt.exists) {
      patientsRef.doc(patient.bhtNumber.toString()).set({
        "name": patient.name,
        "gender": patient.gender == Gender.male ? 'male' : 'female',
        "id": patient.bhtNumber,
        "age": patient.age,
        "nic": patient.nic,
        "dateOfAdmission": patient.dateOfAdmission,
        "contactNumber": patient.contactNumber,
        "bht": patient.bhtNumber,
      });
      print('Created patient');

      pt = await patientsRef.doc(patient.id).get();
      Patient savedPt = Patient.fromDocument(pt);
      return Future.value(savedPt.name);
    }
    return Future.error('Patient already admitted!');
  }
}
