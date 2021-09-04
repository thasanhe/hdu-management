import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/common/common_style.dart';
import 'package:hdu_management/models/drug_chart.dart';
import 'package:hdu_management/services/patient_service.dart';

class AddDrugChart extends StatefulWidget {
  final double bhtNumber;
  final String title;
  final List<String> expandedItemsList;
  final IconData? trailingIcon;
  final VoidCallback onRefresh;

  AddDrugChart({
    required this.bhtNumber,
    required this.title,
    required this.expandedItemsList,
    this.trailingIcon,
    required this.onRefresh,
  });

  @override
  AddDrugChartState createState() => AddDrugChartState();
}

class AddDrugChartState extends State<AddDrugChart> {
  late TextEditingController textEditingController;
  late PatientService patientService;
  static const String statusDelemiter = '<<!!>>';
  static const String dateDelemiter = '<<DD>>';

  Map<String, bool> managementStatusMap = {};

  @override
  initState() {
    widget.expandedItemsList
        .where((e) => 'yesnew'.contains(e.split(statusDelemiter).last))
        .forEach((e) {
      if ('new' == e.split(statusDelemiter).last) {
        e = e.split(statusDelemiter).first + '${statusDelemiter}yes';
      }
      managementStatusMap.putIfAbsent(e, () => true);
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

  List<String> prepareFinalManagementList() {
    return managementStatusMap.entries.map((e) {
      if (e.value) {
        return e.key;
      }
      return e.key.split(statusDelemiter).first + '${statusDelemiter}no';
    }).toList();
  }

  // saveDailyManagement() {
  //   final list = prepareFinalManagementList();
  //   if (list.isNotEmpty) {
  //     DrugChart dailyManagement = DrugChart(
  //       bhtNumber: widget.bhtNumber,
  //       durg: list,
  //       createdDateTime: DateTime.now(),
  //       prescribedDateTime: widget.
  //     );
  //     try {
  //       final SnackBar snackBar =
  //           SnackBar(content: Text('Drug Chart Added Successfully!'));

  //       patientService.createDrugChart(dailyManagement);
  //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //       widget.onRefresh();
  //     } catch (error) {
  //       final SnackBar snackBar =
  //           SnackBar(content: Text('Something Went Wrong! Please Try Again'));
  //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //     }
  //   }
  // }

  addNewManagement(String input) {
    setState(() {
      if (input.isNotEmpty) {
        final epochTime = DateTime.now().millisecondsSinceEpoch;
        managementStatusMap.putIfAbsent(
            input +
                dateDelemiter +
                epochTime.toString() +
                statusDelemiter +
                'new',
            () => true);
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

    if (managementStatusMap.isNotEmpty) {
      managementStatusMap.entries.forEach((entry) {
        bool isChecked = entry.value;
        bool isNew = 'new' == entry.key.split(statusDelemiter).last;
        String title = isNew
            ? entry.key
                    .split(statusDelemiter)
                    .first
                    .split(dateDelemiter)
                    .first +
                ' (Started Today)'
            : entry.key.split(statusDelemiter).first.split(dateDelemiter).first;

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
                child: isNew
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        splashRadius: 20,
                        onPressed: () {
                          setState(() {
                            managementStatusMap.remove(entry.key);
                          });
                        },
                        icon: Icon(
                          Icons.delete,
                          color: red,
                        ))
                    : Checkbox(
                        value: isChecked,
                        onChanged: (val) {
                          setState(() {
                            managementStatusMap[entry.key] =
                                !managementStatusMap[entry.key]!;
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
        onFieldSubmitted: addNewManagement,
      ),
    ));

    return expandedListItems.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.expandedItemsList);
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
                    // saveDailyManagement();
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
              child: ListView(
                shrinkWrap: true,
                children: buildExpandedItems(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
