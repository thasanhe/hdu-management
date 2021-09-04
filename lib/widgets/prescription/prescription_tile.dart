import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/models/prescription.dart';
import 'package:intl/intl.dart';

class PrescriptionTile extends StatefulWidget {
  final String title;
  final IconData? trailingIcon;
  final DateTime selectedDay;
  final List<Prescription> prescriptionsList;

  PrescriptionTile({
    required this.title,
    this.trailingIcon,
    required this.selectedDay,
    required this.prescriptionsList,
  });

  @override
  PrescriptionTileState createState() => PrescriptionTileState();
}

class PrescriptionTileState extends State<PrescriptionTile> {
  static const String dateDelemiter = '<<DD>>';

  List<Container> buildExpandedItems() {
    return widget.prescriptionsList.map((prescription) {
      Text getManagementStatus() {
        if (null != prescription.omittedDate) {
          if (prescription.omittedDate!.isBefore(widget.selectedDay)) {
            return Text(
                'OMITTED ON ${DateFormat('dd-MM-yyyy').format(prescription.omittedDate!)}',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold));
          }
        }
        return Text(
            'DAY ' +
                (widget.selectedDay
                            .difference(prescription.prescribedDate)
                            .inDays +
                        1)
                    .toString(),
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold));
      }

      return Container(
        decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Colors.grey[400]!)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              right: 16.0, left: 16.0, top: 8.0, bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(prescription.drug),
              ),
              // Spacer(),

              Container(
                child: getManagementStatus(),
              ),
              // Spacer(),
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);

    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      color: Color(0xffFFEEE0),
      elevation: 0,
      margin: EdgeInsets.only(bottom: 10, top: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Theme(
          data: theme,
          child: ExpansionTile(
            backgroundColor: Color(0xffFFEEE0),
            title: Text('Drug Chart'),
            children: widget.prescriptionsList.isNotEmpty
                ? buildExpandedItems()
                : [Text('No data')],
          ),
        ),
      ),
    );
  }

  Widget buildSubTitle() {
    return Text(
      widget.title,
      style: TextStyle(fontSize: 12),
    );
  }

  Widget buildTitle() {
    return Text(widget.title.split('@').first);
  }
}
