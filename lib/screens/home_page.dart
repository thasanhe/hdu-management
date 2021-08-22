import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hdu_management/widgets/drawer_home.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSearchField(),
      drawer: AppDrawer(),
    );
  }
}
