import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/models/gender.dart';
import 'package:hdu_management/models/patient.dart';
import 'package:hdu_management/screens/patient_management.dart';

class PatientsTile extends StatefulWidget {
  final Patient patient;
  final bool isSearch;
  final VoidCallback onRefresh;

  PatientsTile({
    required this.patient,
    required this.isSearch,
    required this.onRefresh,
  });

  @override
  _PatientsTileState createState() => _PatientsTileState();
}

class _PatientsTileState extends State<PatientsTile> {
  @override
  Widget build(BuildContext context) {
    final bedNumber = widget.patient.bedNumber != null
        ? (widget.patient.bedNumber! < 10
                ? '0${widget.patient.bedNumber}'
                : widget.patient.bedNumber)!
            .toString()
        : 'N/A';
    final name = widget.patient.name;
    final gender = Gender.male == widget.patient.gender ? 'MALE' : 'FEMALE';
    final age = widget.patient.age.toString();
    final status = widget.patient.currentStatus == 'Transferred' ||
            widget.patient.currentStatus == 'On Air' ||
            widget.patient.currentStatus == 'Death' ||
            widget.patient.currentStatus == 'Discharged' ||
            widget.patient.currentStatus == 'Intubated' ||
            widget.patient.currentStatus == 'On Intermittent O2' ||
            widget.patient.currentStatus == 'inward'
        ? "${widget.patient.currentStatus.toUpperCase()}"
        : "${widget.patient.currentStatus.toUpperCase()} (${widget.patient.currentStatusValue1 != null ? widget.patient.currentStatusValue1 : ''} ${widget.patient.currentStatusValue2 != null ? '+ ${widget.patient.currentStatusValue2}' : ''} ${widget.patient.currentStatusUnit != null ? widget.patient.currentStatusUnit : ''})";

    final daysfromSymptoms =
        DateTime.now().difference(widget.patient.symptomsDate).inDays;
    final daysFromRAT =
        DateTime.now().difference(widget.patient.pcrRatDate).inDays;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientManagement(
              bhtNumber: widget.patient.bhtNumber!,
              onRefresh: widget.onRefresh,
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
}
