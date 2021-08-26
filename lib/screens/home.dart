import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/screens/admission.dart';
import 'package:hdu_management/screens/duty_roster.dart';
import 'package:hdu_management/screens/patient_management.dart';
import 'package:hdu_management/screens/patient_search.dart';
import 'package:hdu_management/widgets/main_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  bool isTyping = false;
  late int _pageNumber;
  String? searchQuery;

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

  clearSearch() {
    setState(() {
      this.isTyping = false;
      searchQuery = '';
      searchController.clear();
    });
  }

  onChanged(text) {
    setState(() {
      this.isTyping = searchController.text.isNotEmpty;
      print(isTyping);
    });
  }

  updateSearch(String? searchQuery) {
    setState(() {
      this.searchQuery = searchQuery;
      this.isTyping = searchController.text.isNotEmpty;
    });
  }

  AppBar buildSearchBar(Function(String) searchFunction) {
    return AppBar(
      title: Center(
        child: Container(
          // padding: EdgeInsets.only(
          //   // right: 40,
          //   top: 10,
          // ),
          child: TextFormField(
            onChanged: searchFunction,
            style: TextStyle(color: Colors.white),
            controller: searchController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 0),
              isDense: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide.none),
              hintText: 'Search patients',
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
          ),
        ),
      ),
      bottom: PreferredSize(
        child: Container(),
        preferredSize: Size.square(10),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.filter_list),
          padding: EdgeInsets.only(right: 20, left: 20),
        )
      ],
    );
  }

  AppBar buildAppBar(String title) {
    return AppBar(
      title: Text(title),
    );
  }

  final _pageTitles = [
    'Patient Search',
    'Patient Management',
    'Duty Roster',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _pageNumber == 0
          ? buildSearchBar(updateSearch)
          : buildAppBar(_pageTitles[_pageNumber]),
      drawer: AppDrawer(pageController: _pageController),
      body: Container(
        color: Colors.grey[200],
        child: PageView(
          children: [
            PatientSearch(searchQuery: searchQuery),
            PatientManagement(),
            DutyRoster(),
          ],
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: onPageChange,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return Scaffold(body: Admission());
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
