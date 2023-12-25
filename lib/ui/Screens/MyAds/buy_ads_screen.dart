import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';
import 'package:marketplace_patanjali/LanguageSetup/localizations.dart';
import 'package:marketplace_patanjali/Models/AuctionModel/auction_model.dart';
import 'package:marketplace_patanjali/resources/http_requests.dart';
import 'package:marketplace_patanjali/ui/Screens/MyAds/ad_detail_screen.dart';

class BuyAdsScreen extends StatefulWidget {
  final String userToken;
  final String userId;

  const BuyAdsScreen({Key key, this.userToken, this.userId}) : super(key: key);
  @override
  _BuyAdsScreenState createState() => _BuyAdsScreenState();
}

class _BuyAdsScreenState extends State<BuyAdsScreen> {
  Future<UserAuctionModel> getMyAuctions() async {
    var param = {"partyId": widget.userId, "adType": "BUY"};
    final response = await ApiBase()
        .get(context, "/api/getRequestListByPartyId", param, widget.userToken);
    if (response != null) {
      debugPrint("Success");
      debugPrint(response.body);
      return userAuctionModelFromJson(response.body);
    } else {
      return UserAuctionModel(
        requestList: [],
      );
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
              future: getMyAuctions(),
              builder: (context, AsyncSnapshot<UserAuctionModel> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (!snapshot.hasError) {
                    if (snapshot.data.requestList.length != 0) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data.requestList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AdDetailScreen(
                                          userId: widget.userId,
                                          userToken: widget.userToken,
                                          requestId: snapshot
                                              .data
                                              .requestList[index]
                                              .custRequestDetail
                                              .custRequestId,
                                        )));
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom: cHeight * 0.01,
                                  // left: cWidth * 0.05,
                                  // right: cWidth * 0.05,
                                ),
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      // bottom: cHeight * 0.01,
                                      left: cWidth * 0.02,
                                      right: cWidth * 0.02,
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        snapshot.data.requestList[index].images
                                                    .length >
                                                0
                                            ? CachedNetworkImage(
                                                imageUrl: snapshot
                                                    .data
                                                    .requestList[index]
                                                    .images[0]
                                                    .imageUrl,
                                                height: cHeight * 0.18,
                                                width: cWidth,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    Image.asset(
                                                  "assets/images/imageplaceholder.png",
                                                  height: cHeight * 0.18,
                                                  width: cWidth,
                                                  fit: BoxFit.cover,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Image.asset(
                                                  "assets/images/imageplaceholder.png",
                                                  height: cHeight * 0.18,
                                                  width: cWidth,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : Image.asset(
                                                "assets/images/imageplaceholder.png",
                                                height: cHeight * 0.18,
                                                width: cWidth,
                                                fit: BoxFit.cover,
                                              ),
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
                                                            "${snapshot.data.requestList[index].variety}",
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
                                                              "${snapshot.data.requestList[index].categoryName}",
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    snapshot
                                                                .data
                                                                .requestList[
                                                                    index]
                                                                .custRequestDetail
                                                                .description !=
                                                            null
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Container(
                                                                width: cWidth *
                                                                    0.6,
                                                                child: Text(
                                                                  "${snapshot.data.requestList[index].custRequestDetail.description}",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        800],
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Offstage(),
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
                                                        "${snapshot.data.requestList[index].custRequestDetail.methodOfFarming}",
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      width: cWidth * 0.3,
                                                    ),
                                                    // Padding(
                                                    //   padding:
                                                    //       EdgeInsets.only(
                                                    //           top: cHeight *
                                                    //               0.02),
                                                    //   child: Container(
                                                    //     width: cWidth * 0.3,
                                                    //     child: Text(
                                                    //       "Bid Now",
                                                    //       textAlign:
                                                    //           TextAlign
                                                    //               .center,
                                                    //       style: TextStyle(
                                                    //         color: Color(
                                                    //             0xFF0047C4),
                                                    //         fontWeight:
                                                    //             FontWeight
                                                    //                 .bold,
                                                    //         fontSize: 16,
                                                    //       ),
                                                    //     ),
                                                    //   ),
                                                    // ),
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
                        child: Text("No ad found"),
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
