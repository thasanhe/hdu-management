import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hdu_management/models/gender.dart';
import 'package:hdu_management/models/investigations.dart';
import 'package:hdu_management/models/on_admission_status.dart';
import 'package:hdu_management/models/parameters.dart';
import 'package:hdu_management/models/patient.dart';
import 'package:hdu_management/models/patient_status.dart';
import 'package:hdu_management/models/prescription.dart';

class PatientService {
  final patientsRef = FirebaseFirestore.instance.collection('patients');
  final onAdmissionStatusRef =
      FirebaseFirestore.instance.collection('on_admission_status');
  final parametersRef = FirebaseFirestore.instance.collection('parameters');
  final investigationsRef =
      FirebaseFirestore.instance.collection('investigations');
  final prescriptionRef = FirebaseFirestore.instance.collection('prescription');
  final patientStatusRef =
      FirebaseFirestore.instance.collection('patient_status');

  String parseDocID(String id) {
    return id.replaceAll('/', '-');
  }

  Future<List<Patient>> getAllPatients() async {
    List<Patient> patientList = [];
    final querySnapshot = await patientsRef.orderBy('bedNumber').get();
    querySnapshot.docs.forEach((doc) {
      patientList.add(Patient.fromDocument(doc));
    });
    print('Retrieved patients');
    return patientList;
  }

  Future<Patient> getPatientByBht(double bhtNumber) async {
    final docSnapshot =
        await patientsRef.doc(parseDocID(bhtNumber.toString())).get();
    return Patient.fromDocument(docSnapshot);
  }

  Future<OnAdmissionStatus?> getOnAdmissionStatusByPatient(
      double bhtNumber) async {
    OnAdmissionStatus? status;
    final querySnapshot =
        await onAdmissionStatusRef.doc(parseDocID(bhtNumber.toString())).get();
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

  Future<List<Parameters>> getParametersByPatientAndMeasuredDate(
      double bhtNumber, DateTime date) async {
    List<Parameters> parametersList = [];
    var start = date;
    var end = start.add(Duration(days: 1));

    print('getting params');
    print(bhtNumber);
    print(date.toString());

    final querySnapshot = await parametersRef
        .where('bhtNumber', isEqualTo: bhtNumber)
        .where('measuredDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('measuredDate', isLessThan: Timestamp.fromDate(end))
        .get();

    querySnapshot.docs.forEach((doc) {
      parametersList.add(Parameters.fromDocument(doc));
    });

    print('Retrieved parameters');
    print(parametersList);
    return parametersList;
  }

  Future<List<Investigations>> getInvestigationsByPatientAndSelectedDate(
      double bhtNumber, DateTime selectedDtm) async {
    List<Investigations> investigationsList = [];

    print('getting investigations');
    print(bhtNumber);
    print(selectedDtm.toString());

    final querySnapshot = await investigationsRef
        .where('bhtNumber', isEqualTo: bhtNumber)
        .where('sampleDateTime',
            isLessThanOrEqualTo: Timestamp.fromDate(selectedDtm))
        .orderBy('sampleDateTime')
        .get();

    querySnapshot.docs.forEach((doc) {
      investigationsList.add(Investigations.fromDocument(doc));
    });

    print('Retrieved Investigations');
    print(investigationsList);
    return investigationsList;
  }

  Future<PatientStatus?> getCurrentPatientStatusByBht(double bhtNumber) async {
    PatientStatus? status;
    final querySnapshot = await patientStatusRef
        .where('bhtNumber', isEqualTo: bhtNumber)
        .orderBy('assignedDateTime', descending: true)
        .limit(1)
        .get();

    status = PatientStatus.fromDocument(querySnapshot.docs.first);
    print('Retrieved patient status');
    return status;
  }

  Future<String> createPatient(Patient patient) async {
    DocumentSnapshot pt = await patientsRef.doc(parseDocID(patient.id!)).get();
    if (!pt.exists) {
      await patientsRef.doc(parseDocID(patient.bhtNumber.toString())).set({
        "name": patient.name,
        "gender": patient.gender == Gender.male ? 'male' : 'female',
        "id": patient.bhtNumber,
        "age": patient.age,
        "nic": patient.nic,
        "dateOfAdmissionHDU": patient.dateOfAdmissionHDU,
        "contactNumber": patient.contactNumber,
        "symptomsDate": patient.symptomsDate,
        "pcrRatDate": patient.pcrRatDate,
        "dateOfAdmissionHospital": patient.dateOfAdmissionHospital,
        "dateOfDischarge": patient.dateOfDischarge,
        "dateOfTransfer": patient.dateOfTransfer,
        "dateOfLama": patient.dateOfLama,
        "dateOfDeath": patient.dateOfDeath,
        "bhtNumber": patient.bhtNumber,
        "bedNumber": patient.bedNumber != null ? patient.bedNumber : 100000,
        'currentStatus': patient.currentStatus,
        'currentStatusValue1': patient.currentStatusValue1,
        'currentStatusValue2': patient.currentStatusValue2,
        'currentStatusUnit': patient.currentStatusUnit,
        'currentStatusDate': patient.currentStatusDate,
        'vaccinatedStatus': patient.vaccinatedStatus,
        'vaccine': patient.vaccine,
        'dateOFFirstDose': patient.dateOFFirstDose,
        'dateOFSecondDose': patient.dateOFSecondDose,
      });

      pt = await patientsRef.doc(parseDocID(patient.id!)).get();
      Patient savedPt = Patient.fromDocument(pt);
      print('Created patient');
      return Future.value(savedPt.name);
    }
    return Future.error('Patient already admitted!');
  }

  Future<String> createPatientOnAdmissionStatus(
      OnAdmissionStatus onAdmissionStatus) async {
    await onAdmissionStatusRef
        .doc(parseDocID(onAdmissionStatus.bhtNumber.toString()))
        .set({
      "bhtNumber": onAdmissionStatus.bhtNumber,
      "alergies": onAdmissionStatus.alergies,
      "co_mobidities": onAdmissionStatus.coMobidities,
      "surgical_history": onAdmissionStatus.surgicalHistory,
      "symptoms": onAdmissionStatus.symptoms,
    });

    final status = await onAdmissionStatusRef
        .doc(parseDocID(onAdmissionStatus.bhtNumber.toString()))
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
      batch.set(prescriptionRef.doc(parseDocID(docId)), {
        "bhtNumber": prescription.bhtNumber,
        "drug": prescription.drug,
        "createdDateTime": prescription.createdDateTime,
        "omittedDate": prescription.omittedDate,
        "prescribedDate": prescription.prescribedDate,
      });
    });
    await batch.commit();
    await Future.delayed(Duration(seconds: 2));
    print('created prescriptions');
  }

  Future<void> createParameters(List<Parameters> paramertersList) async {
    var batch = FirebaseFirestore.instance.batch();

    paramertersList.forEach((paramerters) {
      final docId = paramerters.bhtNumber.toString() +
          '-' +
          paramerters.name +
          '-' +
          paramerters.measuredDate.toIso8601String() +
          '-' +
          paramerters.slot.toString();

      batch.set(parametersRef.doc(parseDocID(docId)), {
        "bhtNumber": paramerters.bhtNumber,
        "createdDateTime": paramerters.createdDateTime,
        "measuredDate": paramerters.measuredDate,
        "slot": paramerters.slot,
        "name": paramerters.name,
        "value": paramerters.value,
      });
    });
    await batch.commit();
    print('created parameters');
  }

  Future<void> createInvestigations(Investigations investigations) async {
    final docId = investigations.bhtNumber.toString() +
        '-' +
        investigations.test +
        '-' +
        investigations.sampleDateTime.toIso8601String();

    await investigationsRef.doc(parseDocID(docId)).set({
      "bhtNumber": investigations.bhtNumber,
      "createdDateTime": investigations.createdDateTime,
      "sampleDateTime": investigations.sampleDateTime,
      "test": investigations.test,
      "value": investigations.value,
    });

    print('created investigations');
  }

  Future<void> createPatientStatus(
      PatientStatus status, Patient patient) async {
    final docId = status.bhtNumber.toString() +
        '-' +
        status.status +
        '-' +
        status.assignedDateTime.toIso8601String();

    await patientStatusRef.doc(parseDocID(docId)).set({
      'bhtNumber': status.bhtNumber,
      'status': status.status,
      'value1': status.value1,
      'value2': status.value2,
      'unit': status.unit,
      'assignedDateTime': status.assignedDateTime
    });

    if (patient.currentStatusDate!.isBefore(status.assignedDateTime)) {
      await patientsRef.doc(parseDocID(status.bhtNumber.toString())).update({
        'currentStatus': status.status,
        'currentStatusValue1': status.value1,
        'currentStatusValue2': status.value2,
        'currentStatusUnit': status.unit,
        'currentStatusDate': status.assignedDateTime,
        'bedNumber': status.status == 'Discharged' ||
                status.status == 'Death' ||
                status.status == 'Transferred'
            ? 100000
            : patient.bedNumber,
      });
    }
  }
}
