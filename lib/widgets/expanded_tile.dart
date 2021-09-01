import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpandedTile extends StatefulWidget {
  final String title;
  final List<String> expandedItemsList;
  final IconData? trailingIcon;

  ExpandedTile({
    required this.title,
    required this.expandedItemsList,
    this.trailingIcon,
  });

  @override
  ExpandedTileState createState() => ExpandedTileState();
}

class ExpandedTileState extends State<ExpandedTile> {
  buildExpandedItems() {
    return widget.expandedItemsList.map((e) {
      bool isContinued = e.split('<<!!>>').last == 'yes';
      bool isNew = e.split('<<!!>>').last == 'new';

      return Padding(
        padding: const EdgeInsets.only(
            right: 16.0, left: 16.0, top: 8.0, bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(e.split('<<!!>>').first),
            ),
            // Spacer(),
            Icon(isContinued
                ? Icons.check
                : isNew
                    ? Icons.play_arrow
                    : Icons.close),
          ],
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
            // trailing: SizedBox(),
            children: buildExpandedItems(),
          ),
        ),
      ),
    );
  }

  Widget buildTitle() {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(widget.title.split('@').first),
            Spacer(),
            Text(
              widget.title.split('@').last,
              style: TextStyle(fontSize: 12),
            ),
            // Spacer(),
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
