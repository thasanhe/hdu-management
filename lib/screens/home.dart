import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/screens/admission.dart';
import 'package:hdu_management/screens/duty_roster.dart';
import 'package:hdu_management/screens/patient_management.dart';
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
  late int _pageNumber;

  late PageController _pageController;

  @override
  initState() {
    super.initState();
    this._pageNumber = 0;
    this._pageController = PageController(initialPage: _pageNumber);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  onPageChange(int pageNumber) {
    setState(() {
      this._pageNumber = pageNumber;
    });
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

  AppBar buildSearchBar() {
    return AppBar(
      title: Container(
        padding: EdgeInsets.only(
          right: 40,
        ),
        child: TextFormField(
          onTap: onSearchTap,
          onChanged: onChanged,
          style: TextStyle(color: Colors.white),
          controller: searchController,
          decoration: InputDecoration(
            isDense: true,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            hintText: 'Search patient',
            filled: true,
            fillColor: Colors.blue.shade400,
            suffixIcon: isTyping
                ? IconButton(
                    icon: Icon(Icons.clear),
                    color: Colors.white,
                    onPressed: clearSearch,
                    padding: EdgeInsets.only(right: 20),
                  )
                : IconButton(
                    icon: Icon(Icons.search),
                    color: Colors.white,
                    padding: EdgeInsets.only(right: 20),
                    onPressed: () {},
                  ),
            hintStyle: TextStyle(
              color: Colors.white,
            ),
          ),
          textAlign: TextAlign.center,
          onFieldSubmitted: handleSearch,
        ),
      ),
    );
  }

  AppBar buildAppBar(String title) {
    return AppBar(
      title: Text(title),
    );
  }

  final _pageTitles = [
    'Patient Search',
    'Admissions',
    'Ward Round',
    'Patient Management',
    'Duty Roster'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _pageNumber == 0
          ? buildSearchBar()
          : buildAppBar(_pageTitles[_pageNumber]),
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
        onPageChanged: onPageChange,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return Scaffold(body: Admission());
                // return AlertDialog(
                //   title: Text('Admit patient'),
                //   actions: [
                //     TextButton(
                //         onPressed: () {
                //           Navigator.pop(context);
                //         },
                //         child: Text('ok'))
                //   ],
                // );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
