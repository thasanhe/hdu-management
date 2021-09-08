import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/models/investigations.dart';
import 'package:intl/intl.dart';

class InvestigationsTile extends StatefulWidget {
  final List<Investigations> investigationsList;
  final IconData? trailingIcon;
  final VoidCallback onAdd;

  InvestigationsTile({
    required this.investigationsList,
    this.trailingIcon,
    required this.onAdd,
  });

  @override
  InvestigationsTileState createState() => InvestigationsTileState();
}

class InvestigationsTileState extends State<InvestigationsTile> {
  TableRow getTableHeader() {
    return TableRow(
      children: [
        Text(
          'Test',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
        Text(
          'Result',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
        Text(
          'Sample Time',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
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
        color: Colors.grey,
      ),
      Divider(
        thickness: 2,
        color: Colors.grey,
      ),
      Divider(
        thickness: 2,
        color: Colors.grey,
      ),
    ]);
  }

  List<TableRow> getParameterRows() {
    List<TableRow> tableRowList = [];

    widget.investigationsList.forEach(
      (investigation) {
        List<Widget> rowItems = [];
        rowItems.add(Container(
          child: Text(
            investigation.test,
            textAlign: TextAlign.left,
          ),
        ));

        rowItems.add(Text(
          investigation.value,
          textAlign: TextAlign.left,
        ));

        var test =
            DateFormat('MMM dd, hh:mma').format(investigation.sampleDateTime);

        rowItems.add(Text(
          test,
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 13),
        ));

        tableRowList.add(TableRow(children: rowItems));
      },
    );

    return tableRowList;
  }

  List<TableRow> getTableRows() {
    List<TableRow> tableRows = [];
    tableRows.add(getTableHeader());
    tableRows.add(addDivider());
    tableRows.addAll(getParameterRows());

    return tableRows;
  }

  getInvestigationTile() {
    return widget.investigationsList.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(
                right: 16.0, left: 16.0, top: 8.0, bottom: 8.0),
            child: Table(
              // defaultColumnWidth: FlexColumnWidth(),
              children: getTableRows(),
            ),
          )
        : Text('No data');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    print('is refreshed!!!');

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
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Investigations'),
                  GestureDetector(
                    child: Icon(Icons.add),
                    onTap: widget.onAdd,
                  )
                ]),

            // trailing:
            //     Text(widget.parametersList.first.createdDateTime.toString()),
            children: [getInvestigationTile()],
          ),
        ),
      ),
    );
  }
}
