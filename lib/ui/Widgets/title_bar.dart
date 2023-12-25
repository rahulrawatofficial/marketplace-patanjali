import 'package:flutter/material.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';

class TitleBar extends StatelessWidget {
  final String title;
  final Color titleColor;
  final Color textColor;
  final Color barColor;
  final BuildContext sContext;
  const TitleBar({
    Key key,
    this.textColor,
    this.barColor,
    this.title,
    this.titleColor,
    this.sContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(top: cHeight * 0.05),
      child: Container(
        decoration: BoxDecoration(
          color: barColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        height: cHeight * 0.1,
        width: cWidth,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: cHeight * 0.01),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: textColor,
                    ),
                    onPressed: () {
                      Scaffold.of(sContext).openDrawer();
                    },
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(color: titleColor, fontSize: 20),
                      ),
                      Text(
                        "Haridwar",
                        style: TextStyle(color: textColor, fontSize: 20),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: cWidth * 0.03),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Cloudy",
                          style: TextStyle(color: textColor, fontSize: 18),
                        ),
                        Text(
                          "Roorkee",
                          style: TextStyle(color: textColor, fontSize: 10),
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.cloud,
                              color: textColor,
                            ),
                            Text(
                              "12",
                              style: TextStyle(color: textColor, fontSize: 22),
                            ),
                            Text(
                              "°",
                              style: TextStyle(color: textColor, fontSize: 22),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
