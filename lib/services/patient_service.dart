import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hdu_management/models/gender.dart';
import 'package:hdu_management/models/on_admission_status.dart';
import 'package:hdu_management/models/parameters.dart';
import 'package:hdu_management/models/patient.dart';
import 'package:hdu_management/models/prescription.dart';

class PatientService {
  final patientsRef = FirebaseFirestore.instance.collection('patients');
  final onAdmissionStatusRef =
      FirebaseFirestore.instance.collection('on_admission_status');
  final parametersRef = FirebaseFirestore.instance.collection('parameters');
  final prescriptionRef = FirebaseFirestore.instance.collection('prescription');

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

  Future<List<Prescription>> getPrescriptionByPatientAndSelectdTime(
      double bhtNumber, DateTime date) async {
    List<Prescription> prescriptionsList = [];
    var start = date;
    var end = start.add(Duration(days: 1));

    final querySnapshot = await prescriptionRef
        .where('bhtNumber', isEqualTo: bhtNumber)
        .where('prescribedDate', isLessThan: Timestamp.fromDate(end))
        .orderBy('prescribedDate', descending: true)
        .get();

    querySnapshot.docs.forEach((doc) {
      prescriptionsList.add(Prescription.fromDocument(doc));
    });

    print('Retrieved prescriptions');
    print(prescriptionsList);
    return prescriptionsList;
  }

  Future<List<Parameters>> getParametersByPatientAndTimeStampDesc(
      double bhtNumber, DateTime date) async {
    List<Parameters> parametersList = [];
    var start = date;
    var end = start.add(Duration(days: 1));

    print('getting params');
    print(bhtNumber);
    print(date.toString());

    final querySnapshot = await parametersRef
        .where('bhtNumber', isEqualTo: bhtNumber)
        .where('createdDateTime',
            isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('createdDateTime', isLessThan: Timestamp.fromDate(end))
        .orderBy('createdDateTime', descending: true)
        .get();

    querySnapshot.docs.forEach((doc) {
      parametersList.add(Parameters.fromDocument(doc));
    });

    print('Retrieved parameters');
    print(parametersList);
    return parametersList;
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

  Future<void> createPrescriptions(List<Prescription> prescriptionList) async {
    var batch = FirebaseFirestore.instance.batch();

    prescriptionList.forEach((prescription) {
      final docId = prescription.bhtNumber.toString() +
          '-' +
          prescription.drug +
          '-' +
          prescription.prescribedDate.toIso8601String();
      batch.set(prescriptionRef.doc(docId), {
        "bhtNumber": prescription.bhtNumber,
        "drug": prescription.drug,
        "createdDateTime": prescription.createdDateTime,
        "omittedDate": prescription.omittedDate,
        "prescribedDate": prescription.prescribedDate,
      });
    });
    await batch.commit();
  }

  Future<void> createParameters(List<Parameters> paramertersList) async {
    var batch = FirebaseFirestore.instance.batch();

    paramertersList.forEach((paramerters) {
      final docId = paramerters.bhtNumber.toString() +
          '-' +
          paramerters.slot.toString() +
          '-' +
          paramerters.createdDateTime.toIso8601String();
      batch.set(prescriptionRef.doc(docId), {
        "bhtNumber": paramerters.bhtNumber,
        "createdDateTime": paramerters.createdDateTime,
        "measuredDate": paramerters.measuredDate,
        "slot": paramerters.slot,
        "name": paramerters.name,
        "value": paramerters.value,
      });
    });
    await batch.commit();
  }
}
