import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/models/drawer_item.dart';

// List<Patient> getPatients() {
//   Patient p1 = Patient(name: 'Dhammika', gender: Gender.male, bhtNumber: 1);
//   Patient p2 = Patient(name: 'Chinthaka', gender: Gender.male, bhtNumber: 2);
//   Patient p3 = Patient(name: 'Prasanna', gender: Gender.male, bhtNumber: 3);
//   Patient p4 = Patient(name: 'Isuru', gender: Gender.male, bhtNumber: 4);
//   Patient p5 = Patient(name: 'Harsha', gender: Gender.male, bhtNumber: 5);
//   Patient p6 = Patient(name: 'Parami', gender: Gender.female, bhtNumber: 6);

//   List<Patient> patients = [];
//   patients.add(p1);
//   patients.add(p2);
//   patients.add(p3);
//   patients.add(p4);
//   patients.add(p5);
//   patients.add(p6);
//   patients.add(p1);
//   patients.add(p2);
//   patients.add(p3);
//   patients.add(p4);
//   patients.add(p5);
//   patients.add(p6);
//   patients.add(p1);
//   patients.add(p2);
//   patients.add(p3);
//   patients.add(p4);
//   patients.add(p5);
//   patients.add(p6);
//   patients.add(p1);
//   patients.add(p2);
//   patients.add(p3);
//   patients.add(p4);
//   patients.add(p5);
//   patients.add(p6);

//   return patients;
// }
List<String> getDailyManagementToday() {
  return [
    'Simple Face mask - 5 l/m<<!!>>yes',
    'IV Cefitriazon 2g - Daily<<!!>>yes',
    'IV Dexamethasone 6mg - TDS<<!!>>yes',
    'SC Enoxapharin 40mg - Daily<<!!>>no',
    'Paracitamol 1g - PRN<<!!>>yes',
    'Omeprazol 20mg - BD<<!!>>yes',
    'Theophyllin 125mg - BD<<!!>>yes',
    'Vit-D 2000IU - Daily<<!!>>yes',
  ];
}

List<String> getDailyManagementYesterday() {
  return [
    'IV Cefitriazon 2g - Daily<<!!>>yes',
    'IV Dexamethasone 6mg - TDS<<!!>>yes',
    'SC Enoxapharin 40mg - Daily<<!!>>yes',
    'Paracitamol 1g - PRN<<!!>>yes',
    'Omeprazol 20mg - BD<<!!>>yes',
    'Theophyllin 125mg - BD<<!!>>yes',
    'Vit-D 2000IU - Daily<<!!>>yes',
  ];
}

List<DrawerItem> getMainDrawerItems() {
  List<DrawerItem> items = [];
  items.add(DrawerItem('Patient Search', CupertinoIcons.person_3_fill));
  // items.add(DrawerItem('Admission', Icons.create));
  // items.add(DrawerItem('Ward Round', Icons.wheelchair_pickup));
  items.add(DrawerItem('Patient Management', Icons.manage_accounts));
  items.add(DrawerItem('Duty Roster', Icons.work));

  return items;
}
