import 'package:flutter/cupertino.dart';

class DrawerItem {
  late Text title;
  late Icon icon;

  DrawerItem(
    String titleText,
    IconData iconData,
  ) {
    title = Text(titleText);
    icon = Icon(iconData);
  }
}
