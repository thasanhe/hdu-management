import 'package:flutter/material.dart';

final colorBrightYellow = Color(0xffFBB97C);
final blue = Colors.blue[400];
final red = Colors.red[400];

getInputDecorationTextFormField(String label, {String? hint}) {
  return InputDecoration(
    isDense: true,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    labelText: label,
    labelStyle: TextStyle(fontSize: 15.0),
    hintText: hint,
  );
}
