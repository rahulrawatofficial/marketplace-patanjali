import 'package:flutter/material.dart';

class ErrorHandling {
  void showErrorDailog(BuildContext context, String title, String message) {
//flutter define function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        //return object of type dialoge
        return AlertDialog(
          title: new Text("$title \n"),
          content: new Text(message ?? "Empty"),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
