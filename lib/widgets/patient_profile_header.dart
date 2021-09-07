import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/models/gender.dart';
import 'package:hdu_management/models/patient.dart';
import 'package:hdu_management/services/patient_service.dart';

class PatientsProfileHeader extends StatefulWidget {
  final Patient patient;
  final bool isSearch;
  final VoidCallback showUpdateDialog;

  PatientsProfileHeader({
    required this.patient,
    required this.isSearch,
    required this.showUpdateDialog,
  });

  @override
  _PatientsProfileHeaderState createState() => _PatientsProfileHeaderState();
}

class _PatientsProfileHeaderState extends State<PatientsProfileHeader> {
  late PatientService patientService;

  @override
  initState() {
    super.initState();

    patientService = PatientService();
  }

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
    final status =
        "${widget.patient.currentStatus.toUpperCase()} (${widget.patient.currentStatusValue1 != null ? widget.patient.currentStatusValue1 : ''} ${widget.patient.currentStatusValue2 != null ? '+ ${widget.patient.currentStatusValue2}' : ''} ${widget.patient.currentStatusUnit != null ? widget.patient.currentStatusUnit : ''})";

    final daysfromSymptoms =
        DateTime.now().difference(widget.patient.symptomsDate).inDays;
    final daysFromRAT =
        DateTime.now().difference(widget.patient.pcrRatDate).inDays;

    return GestureDetector(
      onTap: widget.showUpdateDialog,
      child: Column(
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
      ),
    );
  }
}
