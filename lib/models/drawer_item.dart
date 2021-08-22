import 'package:flutter/cupertino.dart';

class DrawerItem {
  late Text title;
  late Icon icon;
  late VoidCallback onPressed;

  DrawerItem({
    required String titleText,
    required IconData iconData,
    required VoidCallback onPressed,
  }) {
    title = Text(titleText);
    icon = Icon(iconData);
    this.onPressed = onPressed;
  }
}
