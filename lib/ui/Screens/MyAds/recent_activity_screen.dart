import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';
import 'package:marketplace_patanjali/LanguageSetup/localizations.dart';
import 'package:marketplace_patanjali/Models/MyBidModel.dart';
import 'package:marketplace_patanjali/resources/http_requests.dart';
import 'package:marketplace_patanjali/ui/Screens/BidScreens/payment_screen.dart';

class RecentActivityScreen extends StatefulWidget {
  final String userName;
  final String userPhoneNum;
  final String userToken;
  final String userId;

  const RecentActivityScreen({
    Key key,
    this.userToken,
    this.userId,
    this.userName,
    this.userPhoneNum,
  }) : super(key: key);
  @override
  _RecentActivityScreenState createState() => _RecentActivityScreenState();
}

class _RecentActivityScreenState extends State<RecentActivityScreen> {
  Future<MyBidModel> getAllAuctions() async {
    var param = {"partyId": widget.userId};
    final response = await ApiBase()
        .get(context, "/api/getBidListByPartyId", param, widget.userToken);
    if (response != null) {
      debugPrint("Success");
      debugPrint(response.body);
      return myBidModelFromJson(response.body);
    } else {
      return MyBidModel(
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
              future: getAllAuctions(),
              builder: (context, AsyncSnapshot<MyBidModel> snapshot) {
                if (snapshot.hasData == true) {
                  if (!snapshot.hasError) {
                    if (snapshot.data.requestList.length != 0) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data.requestList.length,
                          itemBuilder: (context, index) {
                            print(
                                snapshot.data.requestList[index].images.length);
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: cHeight * 0.01,
                                // left: cWidth * 0.05,
                                // right: cWidth * 0.05,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => PaymentScreen(
                                              userId: widget.userId,
                                              userToken: widget.userToken,
                                              custRequestId: snapshot
                                                  .data
                                                  .requestList[index]
                                                  .custRequestDetail
                                                  .custRequestId,
                                              bidAmount: snapshot
                                                  .data
                                                  .requestList[index]
                                                  .bidDetail
                                                  .totalAmount,
                                              bidQuantity: snapshot
                                                  .data
                                                  .requestList[index]
                                                  .bidDetail
                                                  .quantity,
                                              payNow: snapshot.data
                                                  .requestList[index].status,
                                              quoteId: snapshot
                                                  .data
                                                  .requestList[index]
                                                  .bidDetail
                                                  .quoteId,
                                              userName: widget.userName,
                                              userPhoneNum: widget.userPhoneNum,
                                              fixedProduct: snapshot
                                                  .data
                                                  .requestList[index]
                                                  .custRequestDetail
                                                  .fixedProduct,
                                              inventoryItemId: snapshot
                                                  .data
                                                  .requestList[index]
                                                  .custRequestDetail
                                                  .inventoryItemId,
                                            )),
                                  );
                                },
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
                                        // : Image.asset(
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
                                                width: cWidth * 0.65,
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
                                                                  "postBySeller",
                                                                  "Posted by seller"),
                                                          style: TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        // Padding(
                                                        //   padding: EdgeInsets.only(
                                                        //       left: cWidth *
                                                        //           0.02),
                                                        //   child: Text(
                                                        //     "(${snapshot.data.requestList[index].productUploadTime} ago)",
                                                        //     style:
                                                        //         TextStyle(
                                                        //       color: Colors
                                                        //           .grey,
                                                        //       fontSize:
                                                        //           12,
                                                        //     ),
                                                        //   ),
                                                        // ),
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
                                                            fontSize: 11,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: cWidth *
                                                                      0.01),
                                                          child: Text(
                                                            "${snapshot.data.requestList[index].categoryName}, ",
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          "Variety:",
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: cWidth *
                                                                      0.01),
                                                          child: Text(
                                                            "${snapshot.data.requestList[index].variety}",
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    snapshot
                                                                .data
                                                                .requestList[
                                                                    index]
                                                                .bidDetail
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
                                                                  "${snapshot.data.requestList[index].bidDetail.description}",
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
                                                width: cWidth * 0.25,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: <Widget>[
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                            "${snapshot.data.requestList[index].custRequestDetail.methodOfFarming}",
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                                fontSize: 11),
                                                          ),
                                                          width: cWidth * 0.2,
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: cHeight * 0.02),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        PaymentScreen(
                                                                          userId:
                                                                              widget.userId,
                                                                          userToken:
                                                                              widget.userToken,
                                                                          custRequestId: snapshot
                                                                              .data
                                                                              .requestList[index]
                                                                              .custRequestDetail
                                                                              .custRequestId,
                                                                          bidAmount: snapshot
                                                                              .data
                                                                              .requestList[index]
                                                                              .bidDetail
                                                                              .totalAmount,
                                                                          bidQuantity: snapshot
                                                                              .data
                                                                              .requestList[index]
                                                                              .bidDetail
                                                                              .quantity,
                                                                          payNow: snapshot
                                                                              .data
                                                                              .requestList[index]
                                                                              .status,
                                                                          quoteId: snapshot
                                                                              .data
                                                                              .requestList[index]
                                                                              .bidDetail
                                                                              .quoteId,
                                                                          userName:
                                                                              widget.userName,
                                                                          userPhoneNum:
                                                                              widget.userPhoneNum,
                                                                        )),
                                                          );
                                                        },
                                                        child: snapshot
                                                                        .data
                                                                        .requestList[
                                                                            index]
                                                                        .status ==
                                                                    "QUO_APPROVED" ||
                                                                snapshot
                                                                        .data
                                                                        .requestList[
                                                                            index]
                                                                        .status ==
                                                                    "QUO_ORDERED"
                                                            ? Text(
                                                                "Pay Now",
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16,
                                                                ),
                                                              )
                                                            : snapshot
                                                                        .data
                                                                        .requestList[
                                                                            index]
                                                                        .status ==
                                                                    "QUO_REJECTED"
                                                                ? Text(
                                                                    "Rejected",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  )
                                                                : snapshot
                                                                            .data
                                                                            .requestList[index]
                                                                            .status ==
                                                                        "COMPLETED"
                                                                    ? Text(
                                                                        "Paid",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.green,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                      )
                                                                    : Text(
                                                                        "Pending",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.yellow,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                      ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Divider(),
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
                        child: Text("No Ad found"),
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
