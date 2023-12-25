import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';
import 'package:marketplace_patanjali/LanguageSetup/localizations.dart';
import 'package:marketplace_patanjali/resources/http_requests.dart';

class MyDialog extends StatefulWidget {
  final String userToken;
  final String quoteId;

  const MyDialog({Key key, this.userToken, this.quoteId}) : super(key: key);
  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  ApiBase _apiBase = ApiBase();
  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return AlertDialog(
      content: Container(
        // color: _c,
        height: cHeight * 0.4,
        width: cWidth * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: cHeight * 0.03),
              child: Text(
                MyLocalizations.of(context)
                                              .word("additionalInformation", "   Additional Information"),
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.blue,
                ),
              ),
            ),
            TextFormField(
              controller: commentController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              validator: (value) {
                if (value.length == 0) {
                  return ('Enter information');
                } else {
                  return null;
                }
              },
            ),
            Center(
              child: RaisedButton(
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.blue,
                onPressed: () {
                  var body = {
                    "quoteId": widget.quoteId,
                    "comment": commentController.text
                  };
                  _apiBase
                      .put(context, "/api/addCommentOnBid", null, body,
                          widget.userToken)
                      .then((val) {
                    print(json.encode(body));
                    if (val.statusCode == 200) {
                      print("##${val.body}##");
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          "/home", ModalRoute.withName('/'));
                      // Navigator.of(context).pop();
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
      // actions: <Widget>[
      //   FlatButton(
      //       child: Text('Switch'),
      //       onPressed: () => setState(() {
      //             _c == Colors.redAccent
      //                 ? _c = Colors.blueAccent
      //                 : _c = Colors.redAccent;
      //           }))
      // ],
    );
  }
}
