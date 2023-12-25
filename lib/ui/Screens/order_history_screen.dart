import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';
import 'package:marketplace_patanjali/LanguageSetup/localizations.dart';
import 'package:marketplace_patanjali/Models/order_history_model.dart';
import 'package:marketplace_patanjali/resources/http_requests.dart';

class OrderHistoryScreen extends StatefulWidget {
  final String userId;
  final String userToken;
  // final String userName;
  // final String userPhoneNum;

  const OrderHistoryScreen({
    Key key,
    this.userToken,
    this.userId,
    // this.userName, this.userPhoneNum,
  }) : super(key: key);
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  String title = "Annadata MarketPlace";
  Color titleColor = Color(0xFF009D37);
  Color textColor = Color(0xFF0047C4);
  Color barColor = Colors.white;

  // List paymentTypes = ["Razor Pay", "Wallet", "Wallet History"];
  // List paymentTypesFinal = ["EXT_RAZORPAY", "EXT_BILLACT", "RAZORPAY_WALLET"];
  // String paymentType = "Razor Pay";
  // int paymentTypeIndex = 0;

  String location = "Location";
  String paymentMethod;
  @override
  void initState() {
    // getAddress().then((val) {
    //   setState(() {
    //     location = val.locality;
    //   });
    // });
    // print("userTokenNew: $userToken");
    super.initState();
  }

  Future addToWishlist(String productId, String custRequestId) async {
    var body = {
      "reqData": {
        "partyId": widget.userId,
        "productId": productId,
        "custRequestId": custRequestId,
      }
    };
    final response = await ApiBase()
        .post(context, "/api/addItemToWishList", null, body, widget.userToken);
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {});
    }
  }

  Future removeFromlist(String wishlistId, String wishListItemSeqId) async {
    var param = {
      "wishlistId": wishlistId,
      "wishListItemSeqId": wishListItemSeqId,
    };
    final response = await ApiBase().get(
        context, "/api/deleteWishListByWishListId", param, widget.userToken);
    print("WW${response.body}WW");
    if (response.statusCode == 200) {
      setState(() {});
    }
  }

  Future<OrderHistoryModel> getAllAuctions() async {
    var param = {
      "partyId": widget.userId,
    };
    final response = await ApiBase()
        .get(context, "/api/getOrderListPartyId", param, widget.userToken);
    if (response != null) {
      debugPrint("Success");
      debugPrint(response.body);
      return orderHistoryModelFromJson(response.body);
    } else {
      return OrderHistoryModel(
        orderList: [],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return new Scaffold(
      appBar: AppBar(
        elevation: 1,
        // backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Image.asset(
                "assets/appbar-logo.png",
                height: 35,
              ),
            ),
            Text(
              MyLocalizations.of(context).word("annadata", "Annadata"),
              textAlign: TextAlign.start,
              // style: TextStyle(color: titleColor, fontSize: 18),
            ),
          ],
        ),
        centerTitle: false,
        // actions: <Widget>[
        //   Padding(
        //     padding: EdgeInsets.only(right: 10),
        //     child: Row(
        //       children: <Widget>[
        //         Icon(
        //           Icons.location_on,
        //           color: Colors.black,
        //           size: 18,
        //         ),
        //         Text(
        //           "$location",
        //           style: TextStyle(color: Colors.black, fontSize: 12),
        //         ),
        //       ],
        //     ),
        //   )
        // ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: <Widget>[
            FutureBuilder(
                future: getAllAuctions(),
                builder: (context, AsyncSnapshot<OrderHistoryModel> snapshot) {
                  if (snapshot.hasData == true) {
                    if (!snapshot.hasError) {
                      if (snapshot.data.orderList.length != 0) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data.orderList.length,
                            itemBuilder: (context, index) {
                              paymentMethod = snapshot.data.orderList[index]
                                          .paymentMethod ==
                                      "EXT_RAZORPAY"
                                  ? "Account"
                                  : snapshot.data.orderList[index]
                                              .paymentMethod ==
                                          "EXT_BILLACT"
                                      ? "Wallet"
                                      : "Cash on Delivery";
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: cHeight * 0.01,
                                  // left: cWidth * 0.05,
                                  // right: cWidth * 0.05,
                                ),
                                child: GestureDetector(
                                  // onTap: () {
                                  //   Navigator.of(context)
                                  //       .push(MaterialPageRoute(
                                  //           builder: (context) => AddBidScreen(
                                  //                 addBidOp: false,
                                  //                 custRequestId: snapshot
                                  //                     .data
                                  //                     .transactionList[index]
                                  //                     .custRequestDetail
                                  //                     .custRequestId,
                                  //                 userId: widget.userId,
                                  //                 userToken: widget.userToken,
                                  //                 userName: widget.userName,
                                  //                 userPhoneNum:
                                  //                     widget.userPhoneNum,

                                  //               )));
                                  // },
                                  child: Card(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        // bottom: cHeight * 0.01,
                                        left: cWidth * 0.02,
                                        right: cWidth * 0.02,
                                      ),
                                      child: Column(
                                        children: <Widget>[
                                          snapshot.data.orderList[index]
                                                      .images !=
                                                  null
                                              ? snapshot.data.orderList[index]
                                                          .images.length >
                                                      0
                                                  ? CachedNetworkImage(
                                                      imageUrl: snapshot
                                                          .data
                                                          .orderList[index]
                                                          .images[0]
                                                          .imageUrl,
                                                      height: cHeight * 0.18,
                                                      width: cWidth,
                                                      fit: BoxFit.cover,
                                                      placeholder:
                                                          (context, url) =>
                                                              Image.asset(
                                                        "assets/images/imageplaceholder.png",
                                                        height: cHeight * 0.18,
                                                        width: cWidth,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
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
                                                    )
                                              : Offstage(),
                                          // : Image.asset(
                                          //     "assets/images/test_image.jpg"),
                                          snapshot.data.orderList[index]
                                                      .quoteResult !=
                                                  null
                                              ? Padding(
                                                  padding: EdgeInsets.only(
                                                    top: cHeight * 0.02,
                                                    bottom: cHeight * 0.02,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Container(
                                                        width: cWidth * 0.92,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            // Row(
                                                            //   mainAxisAlignment:
                                                            //       MainAxisAlignment
                                                            //           .start,
                                                            //   children: <
                                                            //       Widget>[
                                                            //     Text(
                                                            //       "Posted by seller",
                                                            //       style:
                                                            //           TextStyle(
                                                            //         color: Colors
                                                            //             .green,
                                                            //         fontSize:
                                                            //             14,
                                                            //       ),
                                                            //     ),
                                                            //   ],
                                                            // ),
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "Category:",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  " ${snapshot.data.orderList[index].categoryName}, ",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "Variety:",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  " ${snapshot.data.orderList[index].variety}",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 8.0),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    "Order Id: ",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .green,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "${snapshot.data.orderList[index].orderId}",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),

                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 8.0),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    "Amount: ",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .blue,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    " ${snapshot.data.orderList[index].amount} ",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 8.0),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    "Paid via: ",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .green,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    " $paymentMethod ",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // Column(
                                                      //   mainAxisAlignment:
                                                      //       MainAxisAlignment
                                                      //           .spaceBetween,
                                                      //   crossAxisAlignment:
                                                      //       CrossAxisAlignment
                                                      //           .end,
                                                      //   children: <Widget>[
                                                      //     Row(
                                                      //       crossAxisAlignment:
                                                      //           CrossAxisAlignment
                                                      //               .end,
                                                      //       mainAxisAlignment:
                                                      //           MainAxisAlignment
                                                      //               .end,
                                                      //       children: <Widget>[
                                                      //         Text(
                                                      //           "${snapshot.data.orderList[index].orderId}",
                                                      //           textAlign:
                                                      //               TextAlign
                                                      //                   .end,
                                                      //           style: TextStyle(
                                                      //               fontSize:
                                                      //                   11),
                                                      //         ),
                                                      //       ],
                                                      //     ),
                                                      //     Text(
                                                      //       "${snapshot.data.orderList[index].quoteResult.statusId}",
                                                      //       textAlign:
                                                      //           TextAlign.start,
                                                      //       style: TextStyle(
                                                      //         fontSize: 12,
                                                      //         fontWeight:
                                                      //             FontWeight
                                                      //                 .w600,
                                                      //         // color: snapshot
                                                      //         //         .data
                                                      //         //         .orderList[
                                                      //         //             index]
                                                      //         //         .gatewayCode ==
                                                      //         //     "COMPLETED"
                                                      //         // ? Colors.green
                                                      //         // : Colors.red,
                                                      //       ),
                                                      //     ),
                                                      //   ],
                                                      // ),
                                                    ],
                                                  ),
                                                )
                                              : Padding(
                                                  padding: EdgeInsets.only(
                                                    top: cHeight * 0.02,
                                                    bottom: cHeight * 0.02,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Container(
                                                        width: cWidth * 0.6,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "Added to Wallet",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .green,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 8.0),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    "Amount: ",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .blue,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    " ${snapshot.data.orderList[index].amount} ",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: <
                                                                Widget>[],
                                                          ),
                                                          Text(
                                                            "${snapshot.data.orderList[index].quoteResult.statusId}",
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              // color: snapshot
                                                              //             .data
                                                              //             .transactionList[
                                                              //                 index]
                                                              //             .gatewayCode ==
                                                              //         "COMPLETED"
                                                              //     ? Colors.green
                                                              //     : Colors.red,
                                                            ),
                                                          ),
                                                        ],
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
                          child: Text("No transaction found"),
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
      ),
    );
  }
}
