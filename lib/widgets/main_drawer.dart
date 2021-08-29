import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/data/data.dart';
import 'package:hdu_management/models/drawer_item.dart';

class AppDrawer extends StatelessWidget {
  final PageController pageController;
  AppDrawer({required this.pageController});

  List<Widget> buildDrawer(List<DrawerItem> items, BuildContext context) {
    List<Widget> widgetList = [];

    final button = Container(
      // color: Colors.blue,
      color: Color(0xffFBB97C),
      height: 55,
      alignment: Alignment.center,
      child: Text(
        'HDU Management',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.white,
          fontSize: 22,
        ),
      ),
    );

    widgetList.add(button);

    items.forEach((item) {
      final button = TextButton(
        onPressed: () {
          pageController.animateToPage(items.indexOf(item),
              duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          Navigator.pop(context);
        },
        child: ListTile(
          title: item.title,
          leading: item.icon,
        ),
        style: ButtonStyle(),
      );

      widgetList.add(button);
      widgetList.add(Divider(
        thickness: 2,
      ));
    });

    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        semanticLabel: 'HDU',
        child: ListView(
          children: buildDrawer(getMainDrawerItems(), context),
        ),
      ),
    );
  }
}
