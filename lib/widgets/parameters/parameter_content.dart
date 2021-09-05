import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/models/parameters.dart';
import 'package:hdu_management/models/patient.dart';
import 'package:hdu_management/widgets/parameters/parameter_tile.dart';

class ParameterContent extends StatefulWidget {
  final Patient patient;
  final DateTime selectedDay;
  final List<Parameters> parametersList;
  final VoidCallback onAdd;
  const ParameterContent({
    Key? key,
    required this.patient,
    required this.selectedDay,
    required this.parametersList,
    required this.onAdd,
  }) : super(key: key);

  @override
  _ParameterContentState createState() => _ParameterContentState();
}

class _ParameterContentState extends State<ParameterContent> {
  @override
  Widget build(BuildContext context) {
    print('parameter content');
    print(widget.parametersList.length);
    return ParameterTile(
      parametersList: widget.parametersList,
      onAdd: widget.onAdd,
    );
  }
}
