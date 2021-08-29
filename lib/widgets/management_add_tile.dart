import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ManagementAddTile extends StatefulWidget {
  final String title;
  final List<String> expandedItemsList;
  final IconData? trailingIcon;

  ManagementAddTile({
    required this.title,
    required this.expandedItemsList,
    this.trailingIcon,
  });

  @override
  ManagementAddTileState createState() => ManagementAddTileState();
}

class ManagementAddTileState extends State<ManagementAddTile> {
  Map<String, bool> itemStatus = {};
  buildExpandedItems() {
    return widget.expandedItemsList
        .where((e) => e.split('<<!!>>').last == 'yes')
        .map((e) {
      String title = e.split('<<!!>>').first;
      itemStatus.putIfAbsent(title, () => true);

      return Padding(
        padding: const EdgeInsets.only(
            right: 16.0, left: 16.0, top: 8.0, bottom: 8.0),
        child: Row(
          children: <Widget>[
            Text(title),
            Spacer(),
            Checkbox(
                value: itemStatus[title],
                onChanged: (val) {
                  setState(() {
                    itemStatus[title] = !itemStatus[title]!;
                  });
                })
          ],
        ),
      );
    }).toList();
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
