import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/models/patient.dart';
import 'package:hdu_management/models/prescription.dart';
import 'package:hdu_management/widgets/prescription/drug_chart_tile.dart';
import 'package:intl/intl.dart';

class PrescriptionContent extends StatefulWidget {
  final Patient patient;
  final DateTime selectedDay;
  final List<Prescription> prescriptionsList;
  final VoidCallback onAdd;
  const PrescriptionContent({
    Key? key,
    required this.patient,
    required this.selectedDay,
    required this.prescriptionsList,
    required this.onAdd,
  }) : super(key: key);

  @override
  _PrescriptionContentState createState() => _PrescriptionContentState();
}

class _PrescriptionContentState extends State<PrescriptionContent> {
  PrescriptionTile buildHistoricalDrugChartTile() {
    return widget.prescriptionsList.isNotEmpty
        ? PrescriptionTile(
            title: DateFormat('dd-MM-yyyy@hh:mm a')
                .format(widget.prescriptionsList.first.createdDateTime),
            prescriptionsList: widget.prescriptionsList,
            selectedDay: widget.selectedDay,
            onAdd: widget.onAdd,
          )
        : PrescriptionTile(
            title: "",
            selectedDay: widget.selectedDay,
            prescriptionsList: [],
            onAdd: widget.onAdd,
          );
  }

  Widget buildDrugChartListView() {
    return buildHistoricalDrugChartTile();
  }

  @override
  Widget build(BuildContext context) {
    return buildDrugChartListView();
  }
}
