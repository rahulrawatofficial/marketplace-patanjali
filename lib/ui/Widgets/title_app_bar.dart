import 'package:flutter/material.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';

class TitleAppBar extends StatelessWidget {
  final String title;
  final BuildContext sContext;
  const TitleAppBar({
    Key key,
    this.title,
    this.sContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(top: cHeight * 0.05),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xFF0047C4),
            ),
            onPressed: () {
              Navigator.of(sContext).pop();
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: cHeight * 0.015),
            child: Text(
              title,
              style: TextStyle(color: Color(0xFF009D37), fontSize: 20),
            ),
          ),
          Text(
            "           ",
            style: TextStyle(color: Color(0xFF009D37), fontSize: 20),
          )
        ],
      ),
    );
  }
}
