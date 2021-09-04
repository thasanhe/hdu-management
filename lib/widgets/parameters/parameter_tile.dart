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
  buildParameterItem(List<Parameters> parametersList) {
    return widget.parametersList.isNotEmpty
        ? Table(
            children: [
              TableRow(
                children: [
                  Text('Parameter'),
                  Text('6 AM'),
                  Text('12 PM'),
                  Text('6 PM'),
                ],
              ),
              TableRow(
                children: [
                  Text('BP'),
                  Text(parametersList.first.bp.toString()),
                  Text(''),
                  Text(''),
                ],
              ),
            ],
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
              buildParameterItem(widget.parametersList),
            ],
          ),
        ),
      ),
    );
  }
}
