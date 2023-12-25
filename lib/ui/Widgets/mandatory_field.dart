import 'package:flutter/material.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';

class MandatoryField extends StatelessWidget {
  const MandatoryField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(left: cWidth * 0.05, right: cWidth * 0.01),
      child: Text("*", style: TextStyle(color: Colors.orange, fontSize: 20)),
    );
  }
}

class NotMandatoryField extends StatelessWidget {
  const NotMandatoryField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(left: cWidth * 0.05, right: cWidth * 0.01),
      child: Text(" ", style: TextStyle(color: Colors.orange, fontSize: 20)),
    );
  }
}
