import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/models/gender.dart';
import 'package:hdu_management/models/patient.dart';
import 'package:hdu_management/screens/patient_profile.dart';
import 'package:hdu_management/utils/utils.dart';

class PatientsTile extends StatelessWidget {
  final Patient patient;
  final bool isGestureEnabled;

  PatientsTile({required this.patient, required this.isGestureEnabled});

  @override
  Widget build(BuildContext context) {
    final dateOfAdmission =
        '${patient.dateOfAdmissionHDU!.day}/${patient.dateOfAdmissionHDU!.month}/${patient.dateOfAdmissionHDU!.year}';

    final bedNumber = patient.bedNumber != null
        ? (patient.bedNumber! < 10
                ? '0${patient.bedNumber}'
                : patient.bedNumber)!
            .toString()
        : 'N/A';
    final name = patient.name;
    final gender = Gender.male == patient.gender ? 'MALE' : 'FEMALE';
    final age = patient.age.toString();
    final status =
        Utils.patientStatusToString(patient.currentStatus).toUpperCase();

    return GestureDetector(
      onTap: isGestureEnabled
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PatientProfile(
                    patient: patient,
                  ),
                ),
              );
            }
          : null,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color(0xffFFEEE0),
                borderRadius: BorderRadius.circular(20)),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "$name",
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style:
                            TextStyle(color: Color(0xffFC9535), fontSize: 19),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "DOA: $dateOfAdmission   $status",
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "On O2 Concentrator (10 l/min)",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                // Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                  decoration: BoxDecoration(
                      color: Color(0xffFBB97C),
                      borderRadius: BorderRadius.circular(13)),
                  child: Text(
                    "Bed $bedNumber\n$gender\n$age Y",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
