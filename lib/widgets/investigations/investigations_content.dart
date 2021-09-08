import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/models/investigations.dart';
import 'package:hdu_management/models/patient.dart';
import 'package:hdu_management/widgets/investigations/investigations_tile.dart';

class InvestigationsContent extends StatefulWidget {
  final Patient patient;
  final DateTime selectedDay;
  final List<Investigations> investigationsList;
  final VoidCallback onAdd;
  const InvestigationsContent({
    Key? key,
    required this.patient,
    required this.selectedDay,
    required this.investigationsList,
    required this.onAdd,
  }) : super(key: key);

  @override
  _InvestigationsContentState createState() => _InvestigationsContentState();
}

class _InvestigationsContentState extends State<InvestigationsContent> {
  @override
  Widget build(BuildContext context) {
    print('investigations content');
    print(widget.investigationsList.length);
    return InvestigationsTile(
      investigationsList: widget.investigationsList,
      onAdd: widget.onAdd,
    );
  }
}
