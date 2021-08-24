import 'package:flutter/cupertino.dart';

class PatientManagement extends StatefulWidget {
  const PatientManagement({Key? key}) : super(key: key);

  @override
  _PatientManagementState createState() => _PatientManagementState();
}

class _PatientManagementState extends State<PatientManagement> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Patient management'),
    );
  }
}
