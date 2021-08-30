import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/common/common_style.dart';
import 'package:hdu_management/models/daily_management.dart';
import 'package:hdu_management/services/patient_service.dart';

class ManagementAddTile extends StatefulWidget {
  final double bhtNumber;
  final String title;
  final List<String> expandedItemsList;
  final IconData? trailingIcon;
  final VoidCallback onRefresh;

  ManagementAddTile({
    required this.bhtNumber,
    required this.title,
    required this.expandedItemsList,
    this.trailingIcon,
    required this.onRefresh,
  });

  @override
  ManagementAddTileState createState() => ManagementAddTileState();
}

class ManagementAddTileState extends State<ManagementAddTile> {
  late TextEditingController textEditingController;
  late PatientService patientService;
  static const String stringDelemiter = '<<!!>>';

  Map<String, bool> managementStatusMap = {};

  @override
  initState() {
    widget.expandedItemsList
        .where((e) => 'yesnew'.contains(e.split(stringDelemiter).last))
        .forEach((e) {
      if ('new' == e.split(stringDelemiter).last) {
        e = e.split(stringDelemiter).first + '${stringDelemiter}yes';
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
      return e.key.split(stringDelemiter).first + '${stringDelemiter}no';
    }).toList();
  }

  saveDailyManagement() {
    DailyManagement dailyManagement = DailyManagement(
        bhtNumber: widget.bhtNumber,
        management: prepareFinalManagementList(),
        createdDateTime: DateTime.now());

    patientService.createPatientManagement(dailyManagement);
    setState(() {});
    widget.onRefresh();
  }

  addNewManagement(String input) {
    setState(() {
      managementStatusMap.putIfAbsent(
          input + '${stringDelemiter}new', () => true);
      textEditingController.clear();
    });
  }

  getInputDecoration() {
    return InputDecoration(
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        labelText: 'Add Management',
        labelStyle: TextStyle(fontSize: 15.0),
        suffix: IconButton(
          iconSize: 20,
          padding: EdgeInsets.zero,
          onPressed: () {
            addNewManagement(textEditingController.text);
          },
          icon: Icon(
            Icons.add,
            color: blue,
          ),
        ));
  }

  buildExpandedItems() {
    List<Padding> expandedListItems = [];

    if (managementStatusMap.isNotEmpty) {
      managementStatusMap.entries.forEach((entry) {
        bool isChecked = entry.value;
        bool isNew = 'new' == entry.key.split(stringDelemiter).last;
        String title = isNew
            ? entry.key.split(stringDelemiter).first + ' (Started Today)'
            : entry.key.split(stringDelemiter).first;

        expandedListItems.add(Padding(
          padding: const EdgeInsets.only(
              right: 12.0, left: 16.0, top: 8.0, bottom: 8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                  style: isChecked
                      ? null
                      : TextStyle(decoration: TextDecoration.lineThrough),
                ),
              ),
              Spacer(),
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

    expandedListItems.add(Padding(
      padding: const EdgeInsets.only(
        right: 16.0,
        left: 16.0,
        top: 8.0,
        bottom: 8.0,
      ),
      child: Container(
        alignment: Alignment.bottomRight,
        child: TextButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateColor.resolveWith((states) => colorBrightYellow),
          ),
          child: Text(
            'Save',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          onPressed: () {
            saveDailyManagement();
          },
        ),
      ),
    ));

    return expandedListItems;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      color: Color(0xffFFEEE0),
      elevation: 0,
      margin: EdgeInsets.only(bottom: 10, top: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ExpansionTile(
          onExpansionChanged: (bool) {
            print(bool);
          },
          maintainState: false,
          backgroundColor: Color(0xffFFEEE0),
          title: buildTitle(),
          trailing: Icon(Icons.add),
          children: buildExpandedItems(),
        ),
      ),
    );
  }

  Widget buildTitle() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(widget.title),
            Spacer(),
          ],
        ),
        Row(
          children: <Widget>[
            Spacer(),
          ],
        ),
      ],
    );
  }
}
