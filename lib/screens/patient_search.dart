import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/models/patient.dart';
import 'package:hdu_management/screens/admission.dart';
import 'package:hdu_management/screens/duty_roster.dart';
import 'package:hdu_management/services/patient_service.dart';
import 'package:hdu_management/widgets/main_drawer.dart';
import 'package:hdu_management/widgets/patient_tile.dart';
import 'package:hdu_management/widgets/progress.dart';
import 'package:hdu_management/widgets/search_bar.dart';

class PatientSearch extends StatefulWidget {
  @override
  _PatientSearchState createState() => _PatientSearchState();
}

class _PatientSearchState extends State<PatientSearch> {
  late PatientService patientService;
  List<Patient>? patientsList;
  List<Patient>? patientsForList;
  bool isPatientFeched = false;
  List<int?> occupiedBeds = [];

  String? searchQuery;
  bool _isTyping = false;

  final _searchController = TextEditingController();

  late PageController _pageController;
  late int _pageNumber;

  @override
  void initState() {
    super.initState();
    fetchAllPatients();
    this._pageNumber = 0;
    this._pageController = PageController(initialPage: _pageNumber);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _searchController.dispose();
  }

  filterPatients(String? query) {
    if (query != null) {
      patientsForList = patientsList!
          .where((element) =>
              element.name
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              element.bedNumber.toString().contains(query))
          .toList();
    }
  }

  fetchAllPatients() async {
    patientService = PatientService();
    this.isPatientFeched = false;
    this.patientsList = await patientService.getAllPatients();
    this.patientsForList = patientsList;
    occupiedBeds = patientsList!.map((pt) => pt.bedNumber).toList();
    setState(() {
      this.patientsList = patientsList;
      this.patientsForList = patientsList;
      occupiedBeds = patientsList!.map((pt) => pt.bedNumber).toList();
      this.isPatientFeched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> getListItems() {
      List<Widget> listItems = [];

      listItems.add(SizedBox(
        height: 10,
      ));

      this.patientsForList!.forEach((patient) {
        listItems.add(PatientsTile(
          patient: patient,
          isSearch: true,
          onRefresh: fetchAllPatients,
        ));
      });

      return listItems;
    }

    updateSearch(String? searchQuery) {
      setState(() {
        this.searchQuery = searchQuery;
        this._isTyping = _searchController.text.isNotEmpty;
        filterPatients(searchQuery);
      });
    }

    clearSearch() {
      setState(() {
        this._isTyping = false;
        this.searchQuery = '';
        _searchController.clear();
        filterPatients('');
      });
    }

    onPageChange(int pageNumber) {
      setState(() {
        this._pageNumber = pageNumber;
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            splashRadius: 20,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Scaffold(
                        body: Admission(
                            occupiedBeds: occupiedBeds,
                            onRefresh: fetchAllPatients));
                  });
            },
            icon: Icon(
              Icons.add,
              size: 30,
            ),
          )
        ],
      ),
      body: PageView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBar(
                  onSearch: updateSearch,
                  clearSearch: clearSearch,
                  searchController: _searchController,
                  isTyping: _isTyping),
              Expanded(
                child: Container(
                  child: !isPatientFeched
                      ? circularProgress()
                      : RefreshIndicator(
                          child: ListView(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            children: getListItems(),
                          ),
                          onRefresh: () {
                            fetchAllPatients();
                            return Future.value('');
                          },
                        ),
                ),
              ),
            ],
          ),
          // PatientManagement(),
          DutyRoster(),
        ],
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: onPageChange,
      ),
      drawer: AppDrawer(
        pageController: _pageController,
      ),
    );
  }
}
