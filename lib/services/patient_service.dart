import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hdu_management/models/daily_management.dart';
import 'package:hdu_management/models/gender.dart';
import 'package:hdu_management/models/on_admission_status.dart';
import 'package:hdu_management/models/patient.dart';
import 'package:hdu_management/utils/utils.dart';

class PatientService {
  final patientsRef = FirebaseFirestore.instance.collection('patients');
  final onAdmissionStatusRef =
      FirebaseFirestore.instance.collection('on_admission_status');
  final dailyManagementRef =
      FirebaseFirestore.instance.collection('daily_management');

  Future<List<Patient>> getAllPatients() async {
    List<Patient> patientList = [];
    final querySnapshot = await patientsRef.orderBy('bedNumber').get();
    querySnapshot.docs.forEach((doc) {
      patientList.add(Patient.fromDocument(doc));
    });
    print('Retrieved patients');
    return patientList;
  }

  Future<OnAdmissionStatus?> getOnAdmissionStatusByPatient(
      double bhtNumber) async {
    OnAdmissionStatus? status;
    final querySnapshot =
        await onAdmissionStatusRef.doc(bhtNumber.toString()).get();
    status = OnAdmissionStatus.fromDocument(querySnapshot);
    print('Retrieved on admission status');
    return status;
  }

  Future<List<DailyManagement>>
      getDailyManagementByPatientOrderedByTimeStampDesc(
          double bhtNumber) async {
    List<DailyManagement> dailyManagementList = [];
    final querySnapshot = await dailyManagementRef
        .where('bhtNumber', isEqualTo: bhtNumber)
        .orderBy('createdDateTime', descending: true)
        .get();

    querySnapshot.docs.forEach((doc) {
      dailyManagementList.add(DailyManagement.fromDocument(doc));
    });
    print('Retrieved daily managements');
    return dailyManagementList;
  }

  Future<String> createPatient(Patient patient) async {
    DocumentSnapshot pt = await patientsRef.doc(patient.id).get();
    if (!pt.exists) {
      await patientsRef.doc(patient.bhtNumber.toString()).set({
        "name": patient.name,
        "gender": patient.gender == Gender.male ? 'male' : 'female',
        "id": patient.bhtNumber,
        "age": patient.age,
        "nic": patient.nic,
        "dateOfAdmissionHDU": patient.dateOfAdmissionHDU,
        "contactNumber": patient.contactNumber,
        "symptomsDate": patient.symptomsDate,
        "pcrRatDate": patient.pcrRatDate,
        "currentStatus": patient.currentStatus,
        "dateOfAdmissionHospital": patient.dateOfAdmissionHospital,
        "dateOfDischarge": patient.dateOfDischarge,
        "dateOfTransfer": patient.dateOfTransfer,
        "dateOfLama": patient.dateOfLama,
        "dateOfDeath": patient.dateOfDeath,
        "bhtNumber": patient.bhtNumber,
        "bedNumber": patient.bedNumber != null ? patient.bedNumber : 100000,
      });

      pt = await patientsRef.doc(patient.id).get();
      Patient savedPt = Patient.fromDocument(pt);
      print('Created patient');
      return Future.value(savedPt.name);
    }
    return Future.error('Patient already admitted!');
  }

  Future<String> createPatientOnAdmissionStatus(
      OnAdmissionStatus onAdmissionStatus) async {
    await onAdmissionStatusRef.doc(onAdmissionStatus.bhtNumber.toString()).set({
      "bhtNumber": onAdmissionStatus.bhtNumber,
      "alergies": onAdmissionStatus.alergies,
      "co_mobidities": onAdmissionStatus.coMobidities,
      "surgical_history": onAdmissionStatus.surgicalHistory,
      "symptoms": onAdmissionStatus.symptoms,
    });

    final status = await onAdmissionStatusRef
        .doc(onAdmissionStatus.bhtNumber.toString())
        .get();
    OnAdmissionStatus savedStatus = OnAdmissionStatus.fromDocument(status);
    print('Created on admission status');
    return Future.value(savedStatus.bhtNumber.toString());
  }

  Future<String> createPatientManagement(
      DailyManagement dailyManagement) async {
    final docId = dailyManagement.bhtNumber.toString() +
        '-' +
        dailyManagement.createdDateTime.toIso8601String();
    await dailyManagementRef.doc(docId).set({
      "bhtNumber": dailyManagement.bhtNumber,
      "management": dailyManagement.management,
      "createdDateTime": dailyManagement.createdDateTime,
    });

    final status = await dailyManagementRef.doc(docId).get();
    DailyManagement savedManagement = DailyManagement.fromDocument(status);
    print('Created daily management');
    return Future.value(savedManagement.bhtNumber.toString());
  }
}
