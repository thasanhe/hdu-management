import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/models/prescription.dart';
import 'package:hdu_management/services/patient_service.dart';

class AddPrescription extends StatefulWidget {
  final double bhtNumber;
  final String title;
  final List<Prescription> prescriptionsList;
  final IconData? trailingIcon;
  final VoidCallback onRefresh;
  final DateTime selectedDate;

  AddPrescription({
    required this.bhtNumber,
    required this.title,
    required this.prescriptionsList,
    this.trailingIcon,
    required this.onRefresh,
    required this.selectedDate,
  });

  @override
  AddPrescriptionState createState() => AddPrescriptionState();
}

class AddPrescriptionState extends State<AddPrescription> {
  late TextEditingController textEditingController;
  late PatientService patientService;
  static const String statusDelemiter = '<<!!>>';
  static const String dateDelemiter = '<<DD>>';

  Map<String, bool> managementStatusMap = {};

  Map<Prescription, bool> prescriptionStatusMap = {};
  Map<String, Prescription> drugWisePrescriptionsMap = {};

  @override
  initState() {
    widget.prescriptionsList
        .where((presc) =>
            presc.omittedDate == null ||
            presc.omittedDate!.isAfter(widget.selectedDate))
        .forEach((nonOmittedPresc) {
      prescriptionStatusMap.putIfAbsent(nonOmittedPresc, () => true);
      drugWisePrescriptionsMap.putIfAbsent(
          nonOmittedPresc.drug, () => nonOmittedPresc);
    });

    textEditingController = TextEditingController();
    patientService = PatientService();
    super.initState();
  }

  @override
  dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  prepareFinalManagementList() {
    return prescriptionStatusMap.entries.forEach((entry) {
      if (!entry.value) {
        entry.key.omittedDate = widget.selectedDate;
      }
    });
  }

  savePrescriptionsList() {
    prepareFinalManagementList();

    if (prescriptionStatusMap.keys.isNotEmpty) {
      List<Prescription> toBeSaved = prescriptionStatusMap.keys.toList();

      try {
        final SnackBar snackBar =
            SnackBar(content: Text('Prescription Added Successfully!'));

        patientService.createPrescriptions(toBeSaved);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        widget.onRefresh();
      } catch (error) {
        final SnackBar snackBar =
            SnackBar(content: Text('Something Went Wrong! Please Try Again'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  addNewPrescription(String input) {
    setState(() {
      if (input.isNotEmpty) {
        final newPresc = Prescription(
          bhtNumber: widget.bhtNumber,
          drug: input,
          createdDateTime: DateTime.now(),
          prescribedDate: widget.selectedDate,
        );
        prescriptionStatusMap.putIfAbsent(newPresc, () => true);
        drugWisePrescriptionsMap.putIfAbsent(input, () => newPresc);
        textEditingController.clear();
      }
    });
  }

  getInputDecoration() {
    return InputDecoration(
      isDense: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      labelText: 'Add Management',
      labelStyle: TextStyle(fontSize: 15.0),
    );
  }

  buildExpandedItems() {
    List<Padding> expandedListItems = [];

    if (prescriptionStatusMap.isNotEmpty) {
      prescriptionStatusMap.entries.forEach((entry) {
        bool isChecked = entry.value;
        String title = entry.key.drug;

        expandedListItems.add(Padding(
          padding: const EdgeInsets.only(
              right: 12.0, left: 16.0, top: 8.0, bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                  style: isChecked
                      ? null
                      : TextStyle(decoration: TextDecoration.lineThrough),
                ),
              ),
              Container(
                child: Checkbox(
                    value: isChecked,
                    onChanged: (val) {
                      setState(() {
                        prescriptionStatusMap[entry.key] =
                            !prescriptionStatusMap[entry.key]!;
                      });
                    }),
              )
            ],
          ),
        ));
      });
    }

    expandedListItems.add(Padding(
      padding: const EdgeInsets.only(
        right: 16.0,
        left: 16.0,
        top: 8.0,
        bottom: 8.0,
      ),
      child: TextFormField(
        controller: textEditingController,
        decoration: getInputDecoration(),
        onFieldSubmitted: addNewPrescription,
      ),
    ));

    return expandedListItems.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                right: 16.0,
                left: 16.0,
                top: 8.0,
                bottom: 8.0,
              ),
              child: Container(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Spacer(),
            Text(
              widget.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(
                right: 16.0,
                left: 16.0,
                top: 8.0,
                bottom: 8.0,
              ),
              child: Container(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  child: Text(
                    'Done',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    savePrescriptionsList();
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            color: Colors.white,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Scrollbar(
                isAlwaysShown: true,
                child: ListView(
                  shrinkWrap: true,
                  children: buildExpandedItems(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
