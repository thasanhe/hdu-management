import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hdu_management/models/gender.dart';
import 'package:hdu_management/models/on_admission_status.dart';
import 'package:hdu_management/models/patient.dart';
import 'package:hdu_management/utils/utils.dart';

class PatientService {
  final patientsRef = FirebaseFirestore.instance.collection('patients');
  final onAdmissionStatusRef =
      FirebaseFirestore.instance.collection('on_admission_status');

  Future<List<Patient>> getAllPatients() async {
    List<Patient> patientList = [];
    final querySnapshot = await patientsRef.orderBy('bedNumber').get();
    querySnapshot.docs.forEach((doc) {
      patientList.add(Patient.fromDocument(doc));
    });
    print('Retrieved patients');
    return patientList;
  }

  Future<List<OnAdmissionStatus>> onAdmissionStatusByPatient(
      double bhtNumber) async {
    List<OnAdmissionStatus> statusList = [];
    final querySnapshot =
        await onAdmissionStatusRef.doc(bhtNumber.toString()).get();
    OnAdmissionStatus.fromDocument(querySnapshot);
    print('Retrieved on admission status');
    return statusList;
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
        "dateOfAdmissionHDU": patient.dateOfAdmissionHDU,
        "contactNumber": patient.contactNumber,
        "symptomsDate": patient.symptomsDate,
        "pcrRatDate": patient.pcrRatDate,
        "currentStatus": Utils.patientStatusToString(patient.currentStatus),
        "dateOfAdmissionHospital": patient.dateOfAdmissionHospital,
        "dateOfDischarge": patient.dateOfDischarge,
        "dateOfTransfer": patient.dateOfTransfer,
        "dateOfLama": patient.dateOfLama,
        "dateOfDeath": patient.dateOfDeath,
        "bhtNumber": patient.bhtNumber,
        "bedNumber": patient.bedNumber != null ? patient.bedNumber : 100000,
        "history": patient.history,
        "symptoms": patient.symptoms,
      });
      print('Created patient');

      pt = await patientsRef.doc(patient.id).get();
      Patient savedPt = Patient.fromDocument(pt);
      return Future.value(savedPt.name);
    }
    return Future.error('Patient already admitted!');
  }

  Future<String> createPatientOnAdmissionStatus(
      OnAdmissionStatus onAdmissionStatus) async {
    onAdmissionStatusRef.doc(onAdmissionStatus.bhtNumber.toString()).set({
      "bhtNumber": onAdmissionStatus.bhtNumber,
      "alergies": onAdmissionStatus.alergies,
      "co_mobidities": onAdmissionStatus.coMobidities,
      "surgical_history": onAdmissionStatus.surgicalHistory,
      "symptoms": onAdmissionStatus.symptoms,
    });

    print('Created on admission status');

    final status = await onAdmissionStatusRef
        .doc(onAdmissionStatus.bhtNumber.toString())
        .get();
    OnAdmissionStatus savedStatus = OnAdmissionStatus.fromDocument(status);
    return Future.value(savedStatus.bhtNumber.toString());
  }
}
