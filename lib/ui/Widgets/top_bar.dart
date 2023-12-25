import 'package:flutter/material.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';

class TopBar extends StatelessWidget {
  final Color barColor;
  const TopBar({
    Key key,
    this.barColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: cHeight * 0.13,
      width: cWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFF6800),
            Color(0xFFFFBF00),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        color: barColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
    );
  }
}
