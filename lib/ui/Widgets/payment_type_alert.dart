import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';
import 'package:marketplace_patanjali/LanguageSetup/localizations.dart';
import 'package:marketplace_patanjali/resources/http_requests.dart';

class PaymentTypeAlert extends StatefulWidget {
  final String userToken;
  final Function(String) codOrder;

  const PaymentTypeAlert({
    Key key,
    this.userToken,
    this.codOrder,
  }) : super(key: key);
  @override
  _PaymentTypeAlertState createState() => new _PaymentTypeAlertState();
}

class _PaymentTypeAlertState extends State<PaymentTypeAlert> {
  ApiBase _apiBase = ApiBase();
  TextEditingController commentController = TextEditingController();
  bool cashBool = false;
  bool chequeBool = false;
  bool ddBool = false;

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return AlertDialog(
      content: Container(
        // color: _c,
        height: cHeight * 0.3,
        width: cWidth * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Center(
              // padding: EdgeInsets.only(top: cHeight * 0.03),
              child: Text(
                MyLocalizations.of(context)
                    .word("paymentType", "   Payment Type"),
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.blue,
                ),
              ),
            ),
            ListTile(
              title: Text("Cash"),
              onTap: () {
                Navigator.of(context).pop();
                widget.codOrder("CASH");
              },
            ),
            Divider(),
            ListTile(
              title: Text("Cheque"),
              onTap: () {
                Navigator.of(context).pop();
                widget.codOrder("CHEQUE");
              },
            ),
            Divider(),
            ListTile(
              title: Text("DD"),
              onTap: () {
                Navigator.of(context).pop();
                widget.codOrder("DEMAND_DRAFT");
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
