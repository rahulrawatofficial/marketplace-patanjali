import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';
import 'package:marketplace_patanjali/LanguageSetup/localizations.dart';
import 'package:marketplace_patanjali/resources/http_requests.dart';

class DkdProductsScreen extends StatefulWidget {
  final void Function(String, String, String) postAd;
  final String userToken;
  final String userPhoneNum;
  final String userId;

  const DkdProductsScreen(
      {Key key, this.userToken, this.userId, this.postAd, this.userPhoneNum})
      : super(key: key);
  @override
  _DkdProductsScreenState createState() => _DkdProductsScreenState();
}

class _DkdProductsScreenState extends State<DkdProductsScreen> {
  Future getDkdProducts() async {
    var param = {"phoneNumber": widget.userPhoneNum};
    final response = await ApiBase().get(
        context, "/api/getUserCropListReadyForSale", param, widget.userToken);
    if (response != null) {
      debugPrint("Success");
      var f = json.decode(response.body);
      var data = f["list"];
      // var data = json.decode(f["list"].toString());
      debugPrint(response.body);
      print("###$data###");
      if (data != null) {
        return data;
      } else {
        return [];
      }
      // return userAuctionModelFromJson(response.body);
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return new Center(
      child: Column(
        children: <Widget>[
          FutureBuilder(
              future: getDkdProducts(),
              builder: (context, snapshot) {
                print("^^${widget.userPhoneNum}^^");
                if (snapshot.connectionState == ConnectionState.done) {
                  if (!snapshot.hasError) {
                    if (snapshot.data.length != 0) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                snapshot.data[index]["crop"] != null
                                    ? widget.postAd(
                                        "crop",
                                        snapshot.data[index]["crop"]
                                            ["cropType"],
                                        snapshot.data[index]["crop"]
                                            ["cropName"])
                                    : widget.postAd(
                                        "fruit",
                                        snapshot.data[index]["crop"]
                                            ["cropType"],
                                        snapshot.data[index]["crop"]
                                            ["cropName"]);
                              },
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: cHeight * 0.01,
                                      left: cWidth * 0.03,
                                      right: cWidth * 0.03),
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        // Image.asset(
                                        //     "assets/images/test_image.jpg"),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: cHeight * 0.02,
                                            bottom: cHeight * 0.02,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                width: cWidth * 0.6,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          MyLocalizations.of(
                                                                      context)
                                                                  .word(
                                                                      "cropName",
                                                                      "Crop Name") +
                                                              ":",
                                                          style: TextStyle(
                                                            // color: Colors
                                                            //     .green,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: cWidth *
                                                                      0.02),
                                                          child: Text(
                                                            "${snapshot.data[index]["crop"]["cropName"]}",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                           MyLocalizations.of(
                                                                      context)
                                                                  .word(
                                                                      "category",
                                                                     "Category") +
                                                              ":",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: cWidth *
                                                                      0.02),
                                                          child: Container(
                                                            width: cWidth * 0.4,
                                                            child: Text(
                                                              "${snapshot.data[index]["crop"]["cropType"]}",
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          "Season:",
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                        Container(
                                                          width: cWidth * 0.4,
                                                          child: Text(
                                                            " ${snapshot.data[index]["cropSeason"]}",
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .grey[800],
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: cWidth * 0.3,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      child: Text(
                                                        "Organic",
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      width: cWidth * 0.3,
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
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Center(
                        child: Text("No product found"),
                      );
                    }
                  } else {
                    return Center(
                      child: Text("No internet Connection"),
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })
        ],
      ),
    );
  }
}
