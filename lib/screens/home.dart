import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/screens/duty_roster.dart';
import 'package:hdu_management/tabs/patient_management.dart';
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
      backgroundColor: Colors.white,
      elevation: 0.0,
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Colors.black87),
      bottom: PreferredSize(
        child: Container(),
        preferredSize: Size.square(10),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.add),
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
      appBar: _pageNumber == 0 ? null : buildAppBar(_pageTitles[_pageNumber]),
      drawer: AppDrawer(pageController: _pageController),
      body: Container(
        child: PageView(
          children: [
            PatientSearch(),
            // PatientManagement(),
            DutyRoster(),
          ],
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: onPageChange,
        ),
      ),
    );
  }
}
