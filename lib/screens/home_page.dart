import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/data/data.dart';
import 'package:hdu_management/models/gender.dart';
import 'package:hdu_management/screens/patient_profile.dart';
import 'package:hdu_management/widgets/main_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  bool isSearchTapped = false;
  bool isTyping = false;

  onSearchTap() {
    setState(() {
      this.isSearchTapped = true;
      print('search tapped');
    });
  }

  clearSearch() {
    setState(() {
      print('tapped');
      this.isSearchTapped = false;
      this.isTyping = false;
      searchController.clear();
      print(isSearchTapped);
    });
  }

  onChanged(text) {
    setState(() {
      this.isTyping = searchController.text.isNotEmpty;
      print(isTyping);
    });
  }

  handleSearch(String query) {}

  AppBar buildSearchField() {
    return AppBar(
      title: TextFormField(
        onTap: onSearchTap,
        onChanged: onChanged,
        style: TextStyle(color: Colors.white),
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search patient',
          filled: true,
          fillColor: Colors.blue.shade400,
          suffixIcon: isTyping
              ? IconButton(
                  icon: Icon(Icons.clear),
                  color: Colors.white,
                  onPressed: clearSearch,
                )
              : IconButton(
                  icon: Icon(Icons.search),
                  color: Colors.white,
                  onPressed: () {},
                ),
          hintStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        onFieldSubmitted: handleSearch,
      ),
    );
  }

  Widget buildBody() {
    final patients = getPatients();
    List<Widget> listItems = [];

    patients.forEach((patient) {
      ListTile lt = ListTile(
        leading: Icon(Icons.person),
        title: Text(patient.name),
        subtitle: Text(patient.gender == Gender.female ? 'Female' : 'Male'),
      );

      TextButton tb = TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PatientProfile(
                          patient: patient,
                        )));
          },
          child: lt);

      listItems.add(tb);
      listItems.add(Divider());
    });

    return ListView(
      children: listItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSearchField(),
      drawer: AppDrawer(),
      body: buildBody(),
    );
  }
}
