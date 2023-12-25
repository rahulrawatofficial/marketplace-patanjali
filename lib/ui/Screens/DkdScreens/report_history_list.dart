import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';
import 'package:marketplace_patanjali/resources/http_requests.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportHistoryList extends StatefulWidget {
  final String userId;
  final String userToken;
  final String phoneNumber;
  const ReportHistoryList({
    Key key,
    this.userId,
    this.userToken,
    this.phoneNumber,
  }) : super(key: key);
  @override
  _ReportHistoryListState createState() => _ReportHistoryListState();
}

class _ReportHistoryListState extends State<ReportHistoryList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController landSizeController = TextEditingController();
  String landSizeId;
  String dkdUserId;
  String authToken;

  Future getReportHistoryList() async {
    var param = {"dkdUserId": dkdUserId, "authToken": authToken};
    final response = await ApiBase()
        .get(context, "/api/getUserReportsByUserId", param, widget.userToken);
    if (response != null) {
      if (response != null) {
        debugPrint("Success");
        debugPrint(response.body);
        return json.decode(utf8.decode(response.bodyBytes));
      }
    } else {
      return [];
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    ApiBase()
        .get(context, "/api/getUserByPhoneNumber",
            {"phoneNumber": widget.phoneNumber}, "")
        .then((val) {
      var userData = json.decode(val.body);
      if (userData["responseData"]["id"] != null) {
        // setState(() {
        dkdUserId = userData["responseData"]["id"];
        authToken = userData["responseData"]["authToken"];
        // });
        ApiBase()
            .get(context, "/api/dkdAdminLogin", null, widget.userToken)
            .then((val) {
          var authData = json.decode(val.body);
          if (authData["responseMessage"] == "success") {
            setState(() {
              authToken = authData["authToken"];
            });
          }
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Report List',
          style: TextStyle(),
        ),
      ),
      body: FutureBuilder(
          future: getReportHistoryList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Internet"),
              );
            } else if (snapshot.hasData) {
              print("__${snapshot.data}__");
              if (snapshot.data["list"] != null)
                return ListView.builder(
                  itemCount: snapshot.data["list"].length,
                  itemBuilder: (context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            left: cWidth * 0.03,
                            right: cWidth * 0.03,
                            top: cHeight * 0.01,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Uri url = Uri(
                                host: "api.dhartikadoctor.co.in",
                                scheme: "https",
                                port: null,
                                path: "/api/getReportPdf",
                                queryParameters: {
                                  "reportId": snapshot.data["list"][index]['id']
                                },
                              );
                              _launchURL(url.toString());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Card(
                                elevation: 5,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: cWidth * 0.03,
                                    right: cWidth * 0.03,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: cHeight * 0.01),
                                            child: Text(
                                              "${snapshot.data["list"][index]["npkRecommendation"]['farmingType']}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'SourceSansProSemi',
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Khasra no. ${snapshot.data["list"][index]["npkRecommendation"]['khasraNo']}",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily:
                                                  'SourceSansProSemiBold',
                                            ),
                                          ),

                                          // Container(
                                          //   width: cWidth * 0.5,
                                          //   child: Text(
                                          //     "${snapshot.data["list"][index]["npkRecommendation"]["cropSeason"]}",
                                          //     style: TextStyle(
                                          //       fontSize: cHeight * 0.018,
                                          //       fontFamily: 'SourceSansProSemi',
                                          //     ),
                                          //   ),
                                          // ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: cHeight * 0.02,
                                                top: cHeight * 0.01),
                                            child: Text(
                                              "${snapshot.data["list"][index]["soilReportNumber"]}",
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: 'SourceSansProSemi',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: cHeight * 0.01),
                                            child: Container(
                                              width: cWidth * 0.3,
                                              // child: Text(
                                              //   "${snapshot.data["list"][index]['cropName']} (${snapshot.data[index]['cropType']})",
                                              //   textAlign: TextAlign.end,
                                              //   style: TextStyle(
                                              //     fontSize: cHeight * 0.019,
                                              //     fontFamily:
                                              //         'SourceSansProSemi',
                                              //   ),
                                              // ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: cHeight * 0.01,
                                                top: cHeight * 0.01),
                                            child: Container(
                                              width: cWidth * 0.3,
                                              child: Text(
                                                "${DateFormat('dd-MM-yyyy').format(DateTime.parse(snapshot.data["list"][index]['creationDate']))}",
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily:
                                                      'SourceSansProSemi',
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: cWidth * 0.3,
                                            child: Text(
                                              "${DateFormat('jm').format(DateTime.parse(snapshot.data["list"][index]['creationDate']))}",
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'SourceSansProSemi',
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );

              return Center(child: Text("No Reports Found"));
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
