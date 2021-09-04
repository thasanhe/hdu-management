import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/models/gender.dart';
import 'package:hdu_management/models/patient.dart';
import 'package:hdu_management/screens/patient_profile.dart';

class PatientsTile extends StatelessWidget {
  final Patient patient;
  final bool isSearch;

  PatientsTile({required this.patient, required this.isSearch});

  @override
  Widget build(BuildContext context) {
    final bedNumber = patient.bedNumber != null
        ? (patient.bedNumber! < 10
                ? '0${patient.bedNumber}'
                : patient.bedNumber)!
            .toString()
        : 'N/A';
    final name = patient.name;
    final gender = Gender.male == patient.gender ? 'MALE' : 'FEMALE';
    final age = patient.age.toString();
    final status = patient.currentStatus.toUpperCase();

    final daysfromSymptoms =
        DateTime.now().difference(patient.symptomsDate).inDays;
    final daysFromRAT = DateTime.now().difference(patient.pcrRatDate).inDays;

    buildTileForSearch() {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PatientProfile(
                patient: patient,
              ),
            ),
          );
        },
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Color(0xffFFEEE0),
                  borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                          "$status",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "SYMPTOMS: ${daysfromSymptoms}D   PCR/RAT: ${daysFromRAT}D",
                          style: TextStyle(
                            fontSize: 12,
                          ),
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

    buildTileForProfile() {
      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color(0xffFFEEE0),
                borderRadius: BorderRadius.circular(20)),
            padding: EdgeInsets.only(left: 0, right: 15, top: 15, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(CupertinoIcons.back)),
                // SizedBox(
                //   width: 5,
                // ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // IconButton(
                      //     onPressed: () {}, icon: Icon(CupertinoIcons.back)),
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
                        "$status",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "SYMPTOMS: ${daysfromSymptoms}D   PCR/RAT: ${daysFromRAT}D",
                        style: TextStyle(
                          fontSize: 12,
                        ),
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
      );
    }

    return isSearch ? buildTileForSearch() : buildTileForProfile();
  }
}
