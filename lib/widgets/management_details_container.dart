import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/models/parameters.dart';
import 'package:hdu_management/models/patient.dart';
import 'package:hdu_management/models/prescription.dart';
import 'package:hdu_management/widgets/parameters/parameter_content.dart';
import 'package:hdu_management/widgets/prescription/prescription_content.dart';

class ManagementDetailsContainer extends StatefulWidget {
  final Patient patient;
  final DateTime selectedDay;
  final List<Parameters> parametersList;
  final List<Prescription> prescriptionsList;
  final VoidCallback onAddParameters;
  final VoidCallback onAddPrescription;
  const ManagementDetailsContainer({
    Key? key,
    required this.patient,
    required this.selectedDay,
    required this.parametersList,
    required this.prescriptionsList,
    required this.onAddParameters,
    required this.onAddPrescription,
  }) : super(key: key);

  @override
  _ManagementDetailsContainerState createState() =>
      _ManagementDetailsContainerState();
}

class _ManagementDetailsContainerState
    extends State<ManagementDetailsContainer> {
  @override
  Widget build(BuildContext context) {
    print('refreshed managemnet content container');
    return Expanded(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(bottom: 10),
        alignment: Alignment.topCenter,
        child: ListView(children: [
          ParameterContent(
            parametersList: widget.parametersList,
            patient: widget.patient,
            selectedDay: widget.selectedDay,
            onAdd: widget.onAddParameters,
          ),
          PrescriptionContent(
            prescriptionsList: widget.prescriptionsList,
            patient: widget.patient,
            selectedDay: widget.selectedDay,
            onAdd: widget.onAddPrescription,
          ),
        ]),
      ),
    );
  }
}
