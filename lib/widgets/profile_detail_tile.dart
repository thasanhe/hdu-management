import 'package:flutter/material.dart';

class ProfileDetailTile extends StatelessWidget {
  final String? firstLine;
  final String? title;
  final String? thirdLine;
  final String? fourthLine;
  ProfileDetailTile({
    this.firstLine,
    this.title,
    this.thirdLine,
    this.fourthLine,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(width: 18.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title!.toUpperCase(),
                style: TextStyle(
                    fontSize: 12.0,
                    // fontWeight: FontWeight.bold,
                    color: Color(0xffFC9535)),
              ),
              Text(
                firstLine!,
                style: TextStyle(
                  fontSize: 14.0,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              if (thirdLine != null)
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    thirdLine!,
                    style: TextStyle(
                      fontSize: 12.0,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (fourthLine != null)
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    fourthLine!,
                    style: TextStyle(
                      fontSize: 12.0,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}
