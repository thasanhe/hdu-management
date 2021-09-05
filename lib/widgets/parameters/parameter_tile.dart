import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/models/parameters.dart';

class ParameterTile extends StatefulWidget {
  final List<Parameters> parametersList;
  final IconData? trailingIcon;

  ParameterTile({
    required this.parametersList,
    this.trailingIcon,
  });

  @override
  ParameterTileState createState() => ParameterTileState();
}

class ParameterTileState extends State<ParameterTile> {
  Map<String, List<double>> paramNameWiseValues = {};
  final parameterNames = ['bp', 'cbs', 'pr', 'rr', 'spo2'];
  final slots = [0, 1, 2];

  TableRow getTableHeader() {
    return TableRow(
      children: [
        Text(
          'Parameter',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          '6 AM',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
        Text(
          '12 PM',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
        Text(
          '6 PM',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }

  addVerticalSpace() {
    return TableRow(children: [
      SizedBox(height: 15), //SizeBox Widget
      SizedBox(height: 15),
      SizedBox(height: 15),
      SizedBox(height: 15),
    ]);
  }

  addDivider() {
    return TableRow(children: [
      Divider(
        thickness: 2,
        color: Colors.red,
      ),
      Divider(
        thickness: 2,
        color: Colors.red,
      ),
      Divider(
        thickness: 2,
        color: Colors.red,
      ),
      Divider(
        thickness: 2,
        color: Colors.red,
      ),
    ]);
  }

  List<TableRow> getParameterRows() {
    List<TableRow> tableRowList = [];

    parameterNames.forEach((param) {
      List<Widget> rowItems = [];
      rowItems.add(Container(
        child: Text(param.toUpperCase()),
      ));

      var parameters = widget.parametersList
          .where((element) => element.name == param)
          .toList();

      slots.forEach((slot) {
        var slotItems = parameters.where((element) => element.slot == slot);
        if (slotItems.isNotEmpty) {
          rowItems.add(Text(
            slotItems.first.value.toString(),
            textAlign: TextAlign.right,
          ));
        } else {
          rowItems.add(Text(
            '-',
            textAlign: TextAlign.right,
          ));
        }
      });
      tableRowList.add(
        TableRow(
          children: rowItems,
        ),
      );
      tableRowList.add(addVerticalSpace());
    });

    return tableRowList;
  }

  List<TableRow> getTableRows() {
    List<TableRow> tableRows = [];
    tableRows.add(getTableHeader());
    tableRows.add(addDivider());
    tableRows.addAll(getParameterRows());

    return tableRows;
  }

  getParameterTile() {
    return widget.parametersList.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(
                right: 16.0, left: 16.0, top: 8.0, bottom: 8.0),
            child: Table(
              defaultColumnWidth: FlexColumnWidth(),
              children: getTableRows(),
            ),
          )
        : Text('No data');
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
            title: Text('Parameters'),
            // trailing:
            //     Text(widget.parametersList.first.createdDateTime.toString()),
            children: [
              getParameterTile(),
            ],
          ),
        ),
      ),
    );
  }
}
