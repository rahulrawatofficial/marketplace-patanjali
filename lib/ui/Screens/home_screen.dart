import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:marketplace_patanjali/Functions/error_handling.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';
import 'package:marketplace_patanjali/LanguageSetup/localizations.dart';
import 'package:marketplace_patanjali/Models/AuctionModel/auction_model.dart';
import 'package:marketplace_patanjali/resources/http_requests.dart';
import 'package:marketplace_patanjali/ui/Screens/BidScreens/add_bid_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/BidScreens/payment_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/filter_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  final String userToken;
  final String userName;
  final String userPhoneNum;
  final String fixedPrice;

  final String primaryId;

  const HomeScreen({
    Key key,
    this.userToken,
    this.userId,
    this.userName,
    this.userPhoneNum,
    this.fixedPrice,
    this.primaryId,
  }) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String title = "Annadata MarketPlace";
  Color titleColor = Color(0xFF79CE1E);
  Color textColor = Color(0xFF0047C4);
  Color barColor = Colors.white;

  String location = "location";

  String pId;
  String catId;
  String varId;
  String adType;
  Coordinates coordinates;

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

  Future addToWishlist(
      String productId, String custRequestId, String inventoryItemId) async {
    var body = {
      "reqData": {
        "partyId": widget.userId,
        "productId": productId,
        "custRequestId": custRequestId,
        "inventoryItemId": inventoryItemId,
      }
    };
    final response = await ApiBase()
        .post(context, "/api/addItemToWishList", null, body, widget.userToken);
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {});
    }
  }

  Future removeFromlist(String wishlistId, String wishListItemSeqId,
      String inventoryItemId) async {
    var param = {
      "wishlistId": wishlistId,
      "wishListItemSeqId": wishListItemSeqId,
      "inventoryItemId": inventoryItemId,
    };
    final response = await ApiBase().get(
        context, "/api/deleteWishListByWishListId", param, widget.userToken);
    print("WW${response.body}WW");
    if (response.statusCode == 200) {
      setState(() {});
    }
  }

  Future<UserAuctionModel> getAllAuctions() async {
    var param = widget.fixedPrice == null
        ? {"partyId": widget.userId}
        : widget.fixedPrice == "Y"
            ? {"partyId": widget.userId, "fixedProduct": "Y"}
            : {"partyId": widget.userId, "fixedProduct": "N"};
    final response = await ApiBase()
        .get(context, "/api/getRequestList", param, widget.userToken);
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

  Future<UserAuctionModel> getFilterAuctions(
      String pIdR, String catIdR, String varIdR) async {
    var param;
    if (varId == null && catId == null && pId == null) {
      param = widget.fixedPrice == null
          ? {
              "partyId": widget.userId,
              "primaryParentCategoryId": widget.primaryId
            }
          : widget.fixedPrice == "Y"
              ? {
                  "partyId": widget.userId,
                  "primaryParentCategoryId": widget.primaryId,
                  "fixedProduct": "Y"
                }
              : {
                  "partyId": widget.userId,
                  "primaryParentCategoryId": widget.primaryId,
                  "fixedProduct": "N"
                };
    } else {
      param = varIdR != null
          ? {"partyId": widget.userId, "productId": varIdR}
          : varIdR == null && catIdR != null
              ? {"partyId": widget.userId, "productCategoryId": catIdR}
              : varIdR == null && catIdR == null
                  ? {"partyId": widget.userId, "primaryParentCategoryId": pIdR}
                  : {"partyId": widget.userId};
    }
    print(param);
    final response =
        await ApiBase().get(context, "/api/searchApi", param, widget.userToken);
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

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));

    setState(() {});

    return null;
  }

  applyFilter(String pIdR, String catIdR, String varIdR, Coordinates coord) {
    setState(() {
      pId = pIdR;
      catId = catIdR;
      varId = varIdR;
      coordinates = coord;
    });
    print(pId);

    print(catId);

    print(varId);
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    // return new Scaffold(
    // drawer: UserDrawer(
    //   userId: widget.userId,
    //   userName: widget.userName,
    //   userPhoneNum: widget.userPhoneNum,
    //   userToken: widget.userToken,
    // ),
    // appBar: AppBar(
    //   elevation: 1,
    //   backgroundColor: Colors.white,
    //   title: Text(
    //     MyLocalizations.of(context)
    //         .word("annadataMarketplace", "Annadata MarketPlace"),
    //     textAlign: TextAlign.start,
    //     style: TextStyle(color: titleColor, fontSize: 18),
    //   ),
    //   centerTitle: false,
    //   actions: <Widget>[
    //     Padding(
    //       padding: EdgeInsets.only(right: 10),
    //       child: Row(
    //         children: <Widget>[
    //           Icon(
    //             Icons.location_on,
    //             color: Colors.black,
    //             size: 18,
    //           ),
    //           Text(
    //             MyLocalizations.of(context).word("$location", "$location"),
    //             style: TextStyle(color: Colors.black, fontSize: 12),
    //           ),
    //         ],
    //       ),
    //     )
    //   ],
    // ),
    // backgroundColor: Colors.white,
    return RefreshIndicator(
      onRefresh: refreshList,
      child: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              // width: cWidth,
              // height: cHeight * 0.735,
              // color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    height: cHeight * 0.09,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: cHeight * 0.01,
                        bottom: cHeight * 0.01,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: cWidth * 0.8,
                            child: TextField(
                              style: TextStyle(fontSize: 15),
                              decoration: new InputDecoration(
                                contentPadding: EdgeInsets.all(2),
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(25.0),
                                  ),
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: 18,
                                ),
                                hintText: MyLocalizations.of(context)
                                    .word("search", "Search"),
                              ),
                            ),
                          ),
                          Container(
                            child:
                                //<Widget>[
                                IconButton(
                              icon: Icon(Icons.format_list_bulleted),
                              onPressed: () {
                                pId = null;
                                catId = null;
                                varId = null;

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => FilterScreen(
                                      applyFilter: applyFilter,
                                    ),
                                  ),
                                );
                              },
                            ),
                            // Text("Filter")
                            //],
                          ),
                          // IconButton(
                          //   icon: Icon(Icons.search),
                          //   onPressed: () {},
                          // ),
                        ],
                      ),
                    ),
                  ),
                  FutureBuilder(
                      future: varId == null &&
                              catId == null &&
                              pId == null &&
                              widget.primaryId == null
                          ? getAllAuctions()
                          : getFilterAuctions(pId, catId, varId),
                      builder:
                          (context, AsyncSnapshot<UserAuctionModel> snapshot) {
                        if (snapshot.hasData == true) {
                          if (!snapshot.hasError) {
                            if (snapshot.data.requestList.length != 0) {
                              return Expanded(
                                child: ListView.builder(
                                  itemCount: snapshot.data.requestList.length,
                                  itemBuilder: (context, index) {
                                    print(snapshot
                                        .data.requestList[index].images.length);
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: cHeight * 0.01,
                                        // left: cWidth * 0.05,
                                        // right: cWidth * 0.05,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          snapshot
                                                      .data
                                                      .requestList[index]
                                                      .custRequestDetail
                                                      .fixedProduct ==
                                                  "N"
                                              ? Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddBidScreen(
                                                            userId:
                                                                widget.userId,
                                                            userToken: widget
                                                                .userToken,
                                                            custRequestId: snapshot
                                                                .data
                                                                .requestList[
                                                                    index]
                                                                .custRequestDetail
                                                                .custRequestId,
                                                            addBidOp: true,
                                                            userName:
                                                                widget.userName,
                                                            userPhoneNum: widget
                                                                .userPhoneNum,
                                                            fixedProduct: snapshot
                                                                .data
                                                                .requestList[
                                                                    index]
                                                                .custRequestDetail
                                                                .fixedProduct,
                                                            inventoryItemId: snapshot
                                                                .data
                                                                .requestList[
                                                                    index]
                                                                .custRequestDetail
                                                                .inventoryItemId,
                                                          )),
                                                )
                                              : Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PaymentScreen(
                                                            userId:
                                                                widget.userId,
                                                            userToken: widget
                                                                .userToken,
                                                            custRequestId: snapshot
                                                                .data
                                                                .requestList[
                                                                    index]
                                                                .custRequestDetail
                                                                .custRequestId,
                                                            bidAmount: snapshot
                                                                .data
                                                                .requestList[
                                                                    index]
                                                                .custRequestDetail
                                                                .maximumAmount,
                                                            bidQuantity: snapshot
                                                                .data
                                                                .requestList[
                                                                    index]
                                                                .custRequestDetail
                                                                .quantity,
                                                            payNow:
                                                                "QUO_APPROVED",
                                                            userName:
                                                                widget.userName,
                                                            userPhoneNum: widget
                                                                .userPhoneNum,
                                                            fixedProduct: snapshot
                                                                .data
                                                                .requestList[
                                                                    index]
                                                                .custRequestDetail
                                                                .fixedProduct,
                                                            inventoryItemId: snapshot
                                                                .data
                                                                .requestList[
                                                                    index]
                                                                .custRequestDetail
                                                                .inventoryItemId,

                                                            // quoteId: snapshot
                                                            //     .data
                                                            //     .requestList[index]
                                                            //     .,
                                                          )),
                                                );
                                        },
                                        child: Card(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              // bottom: cHeight * 0.01,
                                              left: cWidth * 0.02,
                                              right: cWidth * 0.02,
                                              top: cHeight * 0.005,
                                              bottom: cHeight * 0.005,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    snapshot
                                                                .data
                                                                .requestList[
                                                                    index]
                                                                .images
                                                                .length >
                                                            0
                                                        ? CachedNetworkImage(
                                                            imageUrl: snapshot
                                                                .data
                                                                .requestList[
                                                                    index]
                                                                .images[0]
                                                                .imageUrl,
                                                            height:
                                                                cHeight * 0.18,
                                                            width:
                                                                cWidth * 0.37,
                                                            fit: BoxFit.cover,
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Image.asset(
                                                              "assets/images/imageplaceholder.png",
                                                              height: cHeight *
                                                                  0.18,
                                                              width:
                                                                  cWidth * 0.37,
                                                              fit: BoxFit.cover,
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Image.asset(
                                                              "assets/images/imageplaceholder.png",
                                                              height: cHeight *
                                                                  0.18,
                                                              width:
                                                                  cWidth * 0.37,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          )
                                                        : Image.asset(
                                                            "assets/images/imageplaceholder.png",
                                                            height:
                                                                cHeight * 0.18,
                                                            width:
                                                                cWidth * 0.37,
                                                            fit: BoxFit.cover,
                                                          ),
                                                    // : Image.asset(
                                                    //     "assets/images/test_image.jpg"),

                                                    // Divider(),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    left: cWidth * 0.01,
                                                    right: cHeight * 0.005,
                                                  ),
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          width: cWidth * 0.54,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: <Widget>[
                                                              GestureDetector(
                                                                onTap: () {
                                                                  snapshot.data.requestList[index].wishListId !=
                                                                          null
                                                                      ? removeFromlist(
                                                                          snapshot
                                                                              .data
                                                                              .requestList[
                                                                                  index]
                                                                              .wishListId,
                                                                          snapshot
                                                                              .data
                                                                              .requestList[
                                                                                  index]
                                                                              .wishListItemSeqId,
                                                                          snapshot
                                                                              .data
                                                                              .requestList[
                                                                                  index]
                                                                              .custRequestDetail
                                                                              .inventoryItemId)
                                                                      : addToWishlist(
                                                                          snapshot
                                                                              .data
                                                                              .requestList[
                                                                                  index]
                                                                              .custRequestDetail
                                                                              .productId,
                                                                          snapshot
                                                                              .data
                                                                              .requestList[
                                                                                  index]
                                                                              .custRequestDetail
                                                                              .custRequestId,
                                                                          snapshot
                                                                              .data
                                                                              .requestList[index]
                                                                              .custRequestDetail
                                                                              .inventoryItemId);
                                                                },
                                                                child: snapshot
                                                                            .data
                                                                            .requestList[index]
                                                                            .wishListId !=
                                                                        null
                                                                    ? Icon(
                                                                        Icons
                                                                            .favorite,
                                                                        color: Colors
                                                                            .red,
                                                                        size:
                                                                            15,
                                                                      )
                                                                    : Icon(
                                                                        Icons
                                                                            .favorite_border,
                                                                        size:
                                                                            15,
                                                                      ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            snapshot
                                                                        .data
                                                                        .requestList[
                                                                            index]
                                                                        .sellerName !=
                                                                    null
                                                                ? Text(
                                                                    "Posted by ${snapshot.data.requestList[index].sellerName.split(" ")[0]}",
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          titleColor,
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  )
                                                                : Text(
                                                                    MyLocalizations.of(
                                                                            context)
                                                                        .word(
                                                                            "postBySeller",
                                                                            "Posted by seller"),
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          titleColor,
                                                                      fontSize:
                                                                          11,
                                                                    ),
                                                                  ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: cWidth *
                                                                          0.02),
                                                              child: Text(
                                                                "(${snapshot.data.requestList[index].productUploadTime} ago)",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 9,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Text(
                                                              MyLocalizations.of(
                                                                      context)
                                                                  .word(
                                                                      "category",
                                                                      "Category"),
                                                              style: TextStyle(
                                                                fontSize: 11,
                                                                color:
                                                                    titleColor,
                                                              ),
                                                            ),
                                                            Text(
                                                              " ${snapshot.data.requestList[index].categoryName} ",
                                                              style: TextStyle(
                                                                fontSize: 11,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            Text(
                                                              MyLocalizations.of(
                                                                          context)
                                                                      .word(
                                                                          "variety",
                                                                          "Variety") +
                                                                  ":",
                                                              style: TextStyle(
                                                                fontSize: 11,
                                                                color:
                                                                    titleColor,
                                                              ),
                                                            ),
                                                            Text(
                                                              " ${snapshot.data.requestList[index].variety}",
                                                              style: TextStyle(
                                                                fontSize: 11,
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
                                                            ? Padding(
                                                                padding: EdgeInsets.only(
                                                                    top: cHeight *
                                                                        0.01),
                                                                child:
                                                                    Container(
                                                                  width:
                                                                      cWidth *
                                                                          0.53,
                                                                  height:
                                                                      cHeight *
                                                                          0.06,
                                                                  child: Text(
                                                                    "${snapshot.data.requestList[index].custRequestDetail.description}",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          800],
                                                                      fontSize:
                                                                          11,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : Padding(
                                                                padding: EdgeInsets.only(
                                                                    top: cHeight *
                                                                        0.01),
                                                                child:
                                                                    Container(
                                                                  width:
                                                                      cWidth *
                                                                          0.53,
                                                                  height:
                                                                      cHeight *
                                                                          0.06,
                                                                )),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: cHeight *
                                                                      0.01),
                                                          child: Container(
                                                            width:
                                                                cWidth * 0.54,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "${snapshot.data.requestList[index].custRequestDetail.methodOfFarming}    ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color:
                                                                          titleColor),
                                                                ),
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Color(
                                                                        0xFF94BC19),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(4),
                                                                  ),
                                                                  // width:
                                                                  //     cWidth * 0.25,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            4.0),
                                                                    child: snapshot.data.requestList[index].custRequestDetail.fixedProduct ==
                                                                            "N"
                                                                        ? Text(
                                                                            MyLocalizations.of(context).word("bidNow",
                                                                                "Bid Now"),
                                                                            textAlign:
                                                                                TextAlign.end,
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              // color:
                                                                              //     Color(0xFF1144A6),
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 13,
                                                                            ),
                                                                          )
                                                                        : Text(
                                                                            "Buy Now",
                                                                            textAlign:
                                                                                TextAlign.end,
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              // color:
                                                                              //     Color(0xFF1144A6),
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 13,
                                                                            ),
                                                                          ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
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
            ),
          ],
        ),
      ),
    );
    // );
  }
}
