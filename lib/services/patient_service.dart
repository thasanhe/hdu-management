import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hdu_management/models/patient.dart';

class PatientService {
  final patientsRef = FirebaseFirestore.instance.collection('patients');

  Future<List<Patient>> getPatients() async {
    QuerySnapshot querySnapshot = await patientsRef.get();

    List<Patient> patients = [];

    querySnapshot.docs.forEach((element) {
      Patient patient = Patient.fromDocument(element);
      patients.add(patient);
    });

    return Future.value(patients);
  }
}
