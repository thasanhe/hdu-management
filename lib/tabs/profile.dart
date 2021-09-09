import 'package:flutter/material.dart';
import 'package:hdu_management/models/on_admission_status.dart';

import 'package:hdu_management/models/patient.dart';
import 'package:hdu_management/widgets/profile_detail_tile.dart';
import 'package:intl/intl.dart';

class Profile extends StatelessWidget {
  final Patient patient;
  final OnAdmissionStatus onAdmissionStatus;

  const Profile({
    Key? key,
    required this.patient,
    required this.onAdmissionStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: LightColors.kLightYellow,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.transparent,
                      // padding: EdgeInsets.symmetric(
                      //     horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 15.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 170,
                                child: ProfileDetailTile(
                                  firstLine: patient.bhtNumber.toString(),
                                  title: 'BHT',
                                ),
                              ),
                              Container(
                                width: 170,
                                child: ProfileDetailTile(
                                  firstLine: patient.contactNumber != null
                                      ? patient.contactNumber
                                      : 'No Data',
                                  title: 'contact',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 170,
                                child: ProfileDetailTile(
                                  firstLine: DateFormat('dd MMMM, yyyy')
                                      .format(patient.dateOfAdmissionHospital!),
                                  title: 'DOA Hospital',
                                ),
                              ),
                              Container(
                                width: 170,
                                child: ProfileDetailTile(
                                  firstLine: DateFormat('dd MMMM, yyyy')
                                      .format(patient.dateOfAdmissionHDU!),
                                  title: 'DOA HDU',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 170,
                                child: ProfileDetailTile(
                                  firstLine: DateFormat('dd MMMM, yyyy')
                                      .format(patient.symptomsDate),
                                  title: 'DATE OF SYMPTOMS',
                                ),
                              ),
                              Container(
                                width: 170,
                                child: ProfileDetailTile(
                                  firstLine: DateFormat('dd MMMM, yyyy')
                                      .format(patient.pcrRatDate),
                                  title: 'DATE OF PCT/RAT',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.0),
                          ProfileDetailTile(
                            firstLine: patient.vaccinatedStatus == null
                                ? 'Not Available'
                                : '${patient.vaccine} - ${patient.vaccinatedStatus}',
                            title: 'Vaccination Status',
                            thirdLine: patient.vaccinatedStatus != null &&
                                    patient.vaccinatedStatus != 'Not Vaccinated'
                                ? patient.dateOFFirstDose != null
                                    ? 'Date of 1st Dose  : ${DateFormat('dd MMMM, yyyy').format(patient.dateOFFirstDose!)}'
                                    : 'Date of 1st Dose  : Not Available'
                                : null,
                            fourthLine: patient.vaccinatedStatus != null &&
                                    patient.vaccinatedStatus == 'Two Doses'
                                ? patient.dateOFSecondDose != null
                                    ? 'Date of 2nd Dose : ${DateFormat('dd MMMM, yyyy').format(patient.dateOFSecondDose!)}'
                                    : 'Date of 2nd Dose : Not Available'
                                : null,
                          ),
                          SizedBox(height: 15.0),
                          ProfileDetailTile(
                            firstLine: onAdmissionStatus.symptoms.join(', '),
                            title: 'Symptoms',
                          ),
                          SizedBox(height: 15.0),
                          ProfileDetailTile(
                            firstLine: onAdmissionStatus.alergies.isNotEmpty
                                ? onAdmissionStatus.alergies.join(", ")
                                : 'None',
                            title: 'Allergies',
                          ),
                          SizedBox(height: 15.0),
                          ProfileDetailTile(
                            firstLine: onAdmissionStatus.alergies.isNotEmpty
                                ? onAdmissionStatus.coMobidities.join(", ")
                                : 'None',
                            title: 'Co-Mobidities',
                          ),
                          SizedBox(height: 15.0),
                          ProfileDetailTile(
                            firstLine: onAdmissionStatus.alergies.isNotEmpty
                                ? onAdmissionStatus.surgicalHistory.join(", ")
                                : 'None',
                            title: 'Surgical History',
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          SizedBox(height: 15.0),
                          SizedBox(height: 15.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
