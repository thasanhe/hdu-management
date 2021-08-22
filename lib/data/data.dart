import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/models/drawer_item.dart';
import 'package:hdu_management/models/gender.dart';
import 'package:hdu_management/models/patient.dart';

List<Patient> getPatients() {
  Patient p1 = Patient(name: 'Dhammika', gender: Gender.male, bhtNumber: 1);
  Patient p2 = Patient(name: 'Chinthaka', gender: Gender.male, bhtNumber: 2);
  Patient p3 = Patient(name: 'Prasanna', gender: Gender.male, bhtNumber: 3);
  Patient p4 = Patient(name: 'Isuru', gender: Gender.male, bhtNumber: 4);
  Patient p5 = Patient(name: 'Harsha', gender: Gender.male, bhtNumber: 5);
  Patient p6 = Patient(name: 'Parami', gender: Gender.female, bhtNumber: 6);

  List<Patient> patients = [];
  patients.add(p1);
  patients.add(p2);
  patients.add(p3);
  patients.add(p4);
  patients.add(p5);
  patients.add(p6);
  patients.add(p1);
  patients.add(p2);
  patients.add(p3);
  patients.add(p4);
  patients.add(p5);
  patients.add(p6);
  patients.add(p1);
  patients.add(p2);
  patients.add(p3);
  patients.add(p4);
  patients.add(p5);
  patients.add(p6);
  patients.add(p1);
  patients.add(p2);
  patients.add(p3);
  patients.add(p4);
  patients.add(p5);
  patients.add(p6);

  return patients;
}

List<DrawerItem> getMainDrawerItems() {
  List<DrawerItem> items = [];
  items.add(DrawerItem(
      titleText: 'Ward Summary',
      iconData: CupertinoIcons.chart_bar_square,
      onPressed: () {
        print("Clicked Summary");
      }));
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

  return items;
}
