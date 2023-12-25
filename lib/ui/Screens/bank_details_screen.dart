import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';
import 'package:marketplace_patanjali/LanguageSetup/localizations.dart';
import 'package:marketplace_patanjali/Models/bank_detail_model.dart';
import 'package:marketplace_patanjali/resources/http_requests.dart';

class BankDetailScreen extends StatefulWidget {
  final String userId;
  final String userToken;
  BankDetailScreen(
    this.userId,
    this.userToken,
  );
  @override
  _BankDetailScreenState createState() => _BankDetailScreenState();
}

class _BankDetailScreenState extends State<BankDetailScreen> {
  TextEditingController accNoController = TextEditingController();
  TextEditingController accNameController = TextEditingController();

  TextEditingController bankNameController = TextEditingController();
  TextEditingController ifscCodeController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool connection = true;
  bool update = false;

  Future getBankDetails() async {
    final response = await ApiBase().get(context, "/api/getBankAccountDetail",
        {"partyId": widget.userId}, widget.userToken);
    var d = json.decode(response.body);
    if (d["responseMessage"] == "success") {
      return d;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    getBankDetails().then((val) {
      print(val);
      setState(() {
        connection = false;
      });
      if (val != null) {
        if (val["bankAccountDetail"].length > 0) {
          print("Oooooo");
          setState(() {
            update = true;
            accNameController.text =
                val["bankAccountDetail"][0]["accountHolderName"];
            accNoController.text = val["bankAccountDetail"][3]["accountNumber"];
            bankNameController.text = val["bankAccountDetail"][2]["bankName"];
            ifscCodeController.text = val["bankAccountDetail"][1]["ifscCode"];
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Bank Details"),
      ),
      body: !connection
          ? Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            top: cHeight * 0.03,
                            left: cWidth * 0.03,
                            right: cWidth * 0.03,
                          ),
                          child: Container(
                            height: cHeight * 0.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Account Holder Number",
                                      style: TextStyle(
                                        fontSize: cHeight * 0.022,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    TextFormField(
                                        decoration: InputDecoration(),
                                        controller: accNameController,
                                        validator: (value) {
                                          if (value.length == 0) {
                                            return ('Enter Account Holder Number');
                                          } else
                                            return null;
                                        }),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: cHeight * 0.03),
                                      child: Text(
                                        "Account Number",
                                        style: TextStyle(
                                          fontSize: cHeight * 0.022,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(),
                                        controller: accNoController,
                                        validator: (value) {
                                          if (value.length == 0) {
                                            return ('Enter Account Number');
                                          } else
                                            return null;
                                        }),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: cHeight * 0.03),
                                      child: Text(
                                        "Bank Name",
                                        style: TextStyle(
                                          fontSize: cHeight * 0.022,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                        controller: bankNameController,
                                        validator: (value) {
                                          if (value.length == 0) {
                                            return ('Enter Bank Name');
                                          } else
                                            return null;
                                        }),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: cHeight * 0.03),
                                      child: Text(
                                        "IFSC Code",
                                        style: TextStyle(
                                          fontSize: cHeight * 0.022,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                        maxLength: 11,
                                        controller: ifscCodeController,
                                        validator: (value) {
                                          String p = "[A-Z]{4}0[A-Z0-9]{6}";
                                          RegExp regExp = new RegExp(p);

                                          if (!regExp.hasMatch(value) &&
                                              value.length > 0) {
                                            // So, the email is valid
                                            return 'IFSC code not valid';
                                          } else {
                                            return null;
                                          }
                                        }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  PhysicalModel(
                    color: Color(0xFF79CE1E),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: MaterialButton(
                            child: Text(
                              MyLocalizations.of(context).word("save", "Save"),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              _validate();
                              // widget.onChangeCertificate();
                              // Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void _validate() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      BankDetailModel body = BankDetailModel(
          partyId: widget.userId,
          reqData: ReqData(
            accountNumber: accNoController.text,
            bankName: bankNameController.text,
            ifscCode: ifscCodeController.text,
            accountHolderName: accNameController.text,
          ));
      setState(() {
        connection = true;
      });
      update
          ? ApiBase()
              .put(context, "/api/updateAccountDetail", null, body,
                  widget.userToken)
              .then((value) {
              setState(() {
                connection = false;
              });
              var d = json.decode(value.body);
              print("val$value");
              if (d["responseMessage"] == "success") {
                // Navigator.of(context).pop();
                _scaffoldKey.currentState.showSnackBar(
                  new SnackBar(
                    content: new Text("Bank Details Saved"),
                  ),
                );
              } else {
                _scaffoldKey.currentState.showSnackBar(
                  new SnackBar(
                    content: new Text("Bank Details not added"),
                  ),
                );
              }
            })
          : ApiBase()
              .post(context, "/api/addAccountDetail", null, body,
                  widget.userToken)
              .then((value) {
              setState(() {
                connection = false;
              });
              var d = json.decode(value.body);
              print("val$value");
              if (d["responseMessage"] == "success") {
                // Navigator.of(context).pop();
                _scaffoldKey.currentState.showSnackBar(
                  new SnackBar(
                    content: new Text("Bank Details Saved"),
                  ),
                );
              } else {
                _scaffoldKey.currentState.showSnackBar(
                  new SnackBar(
                    content: new Text("Bank Details not added"),
                  ),
                );
              }
            });
    }
  }
}
