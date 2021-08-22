import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/models/drawer_item.dart';

class AppDrawer extends StatelessWidget {
  List<Widget> buildDrawer(List<DrawerItem> items) {
    List<Widget> widgetList = [];

    final button = Container(
      color: Colors.blue,
      height: 55,
      alignment: Alignment.center,
      child: Text(
        'HDU Management',
        style: TextStyle(
          fontWeight: FontWeight.w200,
          color: Colors.white,
          fontSize: 22,
        ),
      ),
    );

    widgetList.add(button);

    items.forEach((item) {
      final button = TextButton(
        onPressed: item.onPressed,
        child: ListTile(
          title: item.title,
          leading: item.icon,
        ),
        style: ButtonStyle(),
      );

      widgetList.add(button);
      widgetList.add(Divider());
    });

    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    List<DrawerItem> items = [];
    items.add(DrawerItem(
        titleText: 'Admission',
        iconData: Icons.create,
        onPressed: () {
          print("Clicked Admission");
        }));
    items.add(DrawerItem(
        titleText: 'Ward Round',
        iconData: Icons.wheelchair_pickup,
        onPressed: () => print('Clicked Ward Round')));
    items.add(DrawerItem(
        titleText: 'Patient Management',
        iconData: Icons.person,
        onPressed: () => print('Clicked Patient Management')));
    items.add(DrawerItem(
        titleText: 'Duty Roster',
        iconData: Icons.work,
        onPressed: () => print('Clicked Daily roster')));

    return Container(
      child: Drawer(
        semanticLabel: 'HDU',
        child: ListView(
          children: buildDrawer(items),
        ),
      ),
    );
  }
}
