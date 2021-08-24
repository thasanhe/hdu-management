import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/data/data.dart';
import 'package:hdu_management/models/drawer_item.dart';
import 'package:hdu_management/models/gender.dart';
import 'package:hdu_management/screens/admission.dart';
import 'package:hdu_management/screens/duty_roster.dart';
import 'package:hdu_management/screens/patient_management.dart';
import 'package:hdu_management/screens/patient_profile.dart';
import 'package:hdu_management/screens/patient_search.dart';
import 'package:hdu_management/screens/ward_round.dart';
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

  late PageController _pageController;

  @override
  initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

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

  buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pageController.jumpToPage(0);
              // Navigator.pop(context);
            },
            child: ListTile(
              title: Text('Patient search'),
              leading: Icon(Icons.note),
            ),
            style: ButtonStyle(),
          ),
          Divider(
            thickness: 2,
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pageController.jumpToPage(1);
            },
            child: ListTile(
              title: Text('Addmission'),
              leading: Icon(Icons.note),
            ),
            style: ButtonStyle(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildSearchField(),
        drawer: AppDrawer(pageController: _pageController),
        body: PageView(
          children: [
            PatientSearch(),
            Admission(),
            WardRound(),
            PatientManagement(),
            DutyRoster(),
          ],
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
        ));
  }
}
