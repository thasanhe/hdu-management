import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowManagement extends StatefulWidget {
  final String title;
  final List<String> expandedItemsList;
  final IconData? trailingIcon;

  ShowManagement({
    required this.title,
    required this.expandedItemsList,
    this.trailingIcon,
  });

  @override
  ShowManagementState createState() => ShowManagementState();
}

class ShowManagementState extends State<ShowManagement> {
  static const String dateDelemiter = '<<DD>>';

  buildExpandedItems() {
    return widget.expandedItemsList.map((e) {
      bool isContinued = e.split('<<!!>>').last == 'yes';
      bool isNew = e.split('<<!!>>').last == 'new';

      final managementWithDate = e.split('<<!!>>').first;
      final managment = managementWithDate.split(dateDelemiter).first;
      int offsetDays = 0;

      if (managementWithDate.split(dateDelemiter).length > 1) {
        print("okokokokok");
        final epocMillis =
            int.parse(managementWithDate.split(dateDelemiter)[1]);

        offsetDays = DateTime.now()
            .difference(DateTime.fromMillisecondsSinceEpoch(epocMillis))
            .inDays;
      }

      getManagementStatus() {
        return isContinued || isNew
            ? Container(
                child: Text(
                'DAY ${offsetDays + 1}',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ))
            : Container(
                child: Text(
                  'OMITTED',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              );
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
                child: Text(managment),
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
            title: buildTitle(),
            trailing: buildSubTitle(),
            children: buildExpandedItems(),
          ),
        ),
      ),
    );
  }

  Widget buildSubTitle() {
    return Text(
      widget.title.split('@').last,
      style: TextStyle(fontSize: 12),
    );
  }

  Widget buildTitle() {
    return Text(widget.title.split('@').first);
  }
}
