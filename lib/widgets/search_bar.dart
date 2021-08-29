import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final void Function(String)? onSearch;
  final void Function() clearSearch;
  final TextEditingController searchController;
  final bool isTyping;
  const SearchBar(
      {required this.onSearch,
      required this.clearSearch,
      required this.searchController,
      required this.isTyping})
      : super();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        height: 50,
        decoration: BoxDecoration(
            color: Color(0xffEFEFEF), borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: <Widget>[
            Icon(Icons.search),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                onChanged: this.onSearch,
                style: TextStyle(color: Colors.grey, fontSize: 19),
                controller: searchController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 0),
                  isDense: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      borderSide: BorderSide.none),
                  hintText: 'Search patients',
                  suffixIcon: isTyping
                      ? IconButton(
                          splashRadius: 20,
                          icon: Icon(Icons.clear),
                          color: Colors.black,
                          onPressed: clearSearch,
                          padding: EdgeInsets.only(right: 20),
                        )
                      : null,
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
