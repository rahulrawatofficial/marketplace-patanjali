import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';
import 'package:marketplace_patanjali/LanguageSetup/localizations.dart';
import 'package:marketplace_patanjali/Models/add_detail_model.dart';
import 'package:marketplace_patanjali/resources/http_requests.dart';
import 'package:marketplace_patanjali/ui/Widgets/photo_view.dart';
import 'package:marketplace_patanjali/ui/Widgets/widget_methods.dart';

class AdDetailScreen extends StatefulWidget {
  final String userToken;
  final String userId;
  final String requestId;
  final String inventoryItemId;
  final String fixedProduct;
  const AdDetailScreen(
      {Key key,
      this.userToken,
      this.userId,
      this.requestId,
      this.inventoryItemId,
      this.fixedProduct})
      : super(key: key);
  @override
  _AdDetailScreenState createState() => _AdDetailScreenState();
}

class _AdDetailScreenState extends State<AdDetailScreen> {
  String title = "Annadata MarketPlace";
  Color titleColor = Color(0xFF009D37);
  Color textColor = Color(0xFF009D37);
  Color buttonColor = Color(0xFF0047C4);
  Color barColor = Colors.white;
  ApiBase _apiBase = ApiBase();
  var adData;
  String sellerName = "Seller";
  String locationName;
  bool connetion = false;

  Future<AdDetailModel> getAdDetail() async {
    var param = {"requestId": widget.requestId};
    final response = await _apiBase.get(
        context, "/api/getBidListByRequestId", param, widget.userToken);
    if (response != null) {
      debugPrint("Success");
      debugPrint(response.body);
      return adDetailModelFromJson(response.body);
    } else {
      return AdDetailModel(
        responseMessage: "false",
        bidList: [],
      );
    }
  }

  @override
  void initState() {
    var param = widget.fixedProduct == "N"
        ? {
            "custRequestId": widget.requestId,
            "inventoryItemId": widget.inventoryItemId
          }
        : {"inventoryItemId": widget.inventoryItemId};
    // var param = {
    //   "custRequestId": widget.requestId,
    // };
    _apiBase
        .get(context, "/api/getRequestDetailById", param, widget.userToken)
        .then((val) {
      var data = json.decode(val.body);
      setState(() {
        adData = data;
        sellerName = adData["custRequestResult"][0]["sellerName"];
        connetion = true;
      });
      if (adData["custRequestResult"][0]["locationDetail"]["latitude"] !=
              null &&
          adData["custRequestResult"][0]["locationDetail"]["longitude"] !=
              null) {
        setState(() {
          locationName =
              "${adData["custRequestResult"][0]["locationDetail"]["district"]}, ${adData["custRequestResult"][0]["locationDetail"]["state"]}";
        });
        // getAddressName(
        //         adData["custRequestResult"][0]["locationDetail"]["latitude"],
        //         adData["custRequestResult"][0]["locationDetail"]["longitude"])
        //     .then((locVal) {
        //   setState(() {
        //     locationName = locVal;
        //   });
        // });
      }
    });
    super.initState();
  }

  deleteAd() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text("Do you want to delete the Ad?"),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () {
                    var body = {
                      "custRequestId": adData["custRequestResult"][0]
                          ["custRequestResult"]["custRequestId"],
                    };
                    _apiBase
                        .put(context, "/api/deleteProductToSell", null, body,
                            widget.userToken)
                        .then((val) {
                      if (val.statusCode == 200) {
                        // Navigator.of(context).pop();
                        var responseJson = val.body;
                        var d = json.decode(responseJson);
                        if (d["responseMessage"] != "error")
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              "/home", ModalRoute.withName('/'));
                        print("##${val.statusCode}##");
                      } else {
                        Navigator.of(context).pop();
                      }
                    });
                  },
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;

    respondBid(String status, String quoteId) {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Text("Do you want to $status the bid?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: connetion
                        ? () {
                            Navigator.of(context).pop();
                          }
                        : () {},
                  ),
                  FlatButton(
                    child: Text("Yes"),
                    onPressed: connetion
                        ? () {
                            setState(() {
                              connetion = false;
                            });

                            Navigator.of(context).pop();
                            var body = {
                              "quoteId": quoteId,
                              "bidStatus": status,
                              "productId": adData["custRequestResult"][0]
                                  ["custRequestResult"]["productId"],
                              "custRequestItemSeqId":
                                  adData["custRequestResult"][0]
                                          ["custRequestResult"]
                                      ["custRequestItemSeqId"],
                              "inventoryItemId": widget.inventoryItemId
                            };
                            _apiBase
                                .put(context, "/api/acceptRejectBid", null,
                                    body, widget.userToken)
                                .then((val) {
                              print(json.encode(body));
                              if (val.statusCode == 200) {
                                print("##${val.body}##");
                                setState(() {
                                  connetion = true;
                                });
                              } else {
                                Navigator.of(context).pop();
                              }
                            });
                          }
                        : () {},
                  ),
                ],
              ));
    }

    return new Scaffold(
      appBar: AppBar(
        elevation: 1,
        // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                deleteAd();
              }),
        ],
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            connetion
                ? Expanded(
                    // width: cWidth,
                    // height: cHeight * 0.735,
                    // color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: cHeight * 0.12,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Ad by $sellerName",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                "Published on ${DateFormat("dd-MM-yyyy").format(DateTime.parse(adData["custRequestResult"][0]["custRequestDate"]))}",
                                style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.only(
                            left: cWidth * 0.01,
                            right: cWidth * 0.01,
                          ),
                          child: Form(
                            // key: _formKey,
                            child: ListView(
                              children: <Widget>[
                                Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: cHeight * 0.03,
                                      left: cWidth * 0.02,
                                      bottom: cHeight * 0.03,
                                      right: cWidth * 0.02,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            adData["custRequestResult"][0]
                                                            ["images"]
                                                        .length >
                                                    0
                                                ? GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  PhotoViewScreen(
                                                                    imageUrl: adData["custRequestResult"][0]
                                                                            [
                                                                            "images"][0]
                                                                        [
                                                                        "imageUrl"],
                                                                  )));
                                                    },
                                                    child: FadeInImage
                                                        .assetNetwork(
                                                      placeholder:
                                                          "assets/images/imageplaceholder.png",
                                                      image:
                                                          adData["custRequestResult"]
                                                                  [0]["images"]
                                                              [0]["imageUrl"],
                                                      height: cHeight * 0.13,
                                                      width: cWidth * 0.3,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                : Image.asset(
                                                    "assets/images/imageplaceholder.png",
                                                    height: cHeight * 0.13,
                                                    width: cWidth * 0.3,
                                                    fit: BoxFit.cover,
                                                  ),
                                            Container(
                                              // color: Colors.grey,
                                              width: cWidth * 0.6,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        MyLocalizations.of(
                                                                    context)
                                                                .word(
                                                                    "primaryCategories",
                                                                    "Primary Categories") +
                                                            ":",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          color: textColor,
                                                        ),
                                                      ),
                                                      Text(
                                                        " ${adData["custRequestResult"][0]["primaryCategoryName"]}",
                                                        style: TextStyle(
                                                          // fontWeight: FontWeight.bold,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: cHeight * 0.01),
                                                    child: Row(
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
                                                                      "Category") +
                                                              ":",
                                                          style: TextStyle(
                                                            // fontWeight: FontWeight.bold,
                                                            fontSize: 14,
                                                            color: textColor,
                                                          ),
                                                        ),
                                                        Text(
                                                          " ${adData["custRequestResult"][0]["childCategoy"]}",
                                                          style: TextStyle(
                                                            // fontWeight: FontWeight.bold,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  adData["custRequestResult"][0]
                                                              ["cropName"] !=
                                                          null
                                                      ? Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: cHeight *
                                                                      0.01),
                                                          child: Row(
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
                                                                            "cropName",
                                                                            "Crop Name") +
                                                                    ":",
                                                                style:
                                                                    TextStyle(
                                                                  // fontWeight: FontWeight.bold,
                                                                  fontSize: 14,
                                                                  color:
                                                                      textColor,
                                                                ),
                                                              ),
                                                              Text(
                                                                " ${adData["custRequestResult"][0]["cropName"]}",
                                                                style:
                                                                    TextStyle(
                                                                  // fontWeight: FontWeight.bold,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Offstage(),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: cHeight * 0.01),
                                                    child: Row(
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
                                                                      "variety",
                                                                      "Variety") +
                                                              ":",
                                                          style: TextStyle(
                                                            // fontWeight: FontWeight.bold,
                                                            fontSize: 14,
                                                            color: textColor,
                                                          ),
                                                        ),
                                                        Text(
                                                          " ${adData["custRequestResult"][0]["variety"]}",
                                                          style: TextStyle(
                                                            // fontWeight: FontWeight.bold,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: cHeight * 0.01),
                                                    child: Row(
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
                                                                      "quality",
                                                                      "Quality") +
                                                              ":",
                                                          style: TextStyle(
                                                            // fontWeight: FontWeight.bold,
                                                            fontSize: 14,
                                                            color: textColor,
                                                          ),
                                                        ),
                                                        Text(
                                                          " ${adData["custRequestResult"][0]["custRequestResult"]["methodOfFarming"]}",
                                                          style: TextStyle(
                                                            // fontWeight: FontWeight.bold,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: cHeight * 0.01),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                MyLocalizations.of(context)
                                                        .word("quantity",
                                                            "Quantity") +
                                                    ":",
                                                style: TextStyle(
                                                  // fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: textColor,
                                                ),
                                              ),
                                              Text(
                                                " ${adData["custRequestResult"][0]["custRequestResult"]["quantity"]} ${adData["custRequestResult"][0]["custRequestResult"]["unit"]}",
                                                style: TextStyle(
                                                  // fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        adData["custRequestResult"][0]
                                                        ["custRequestResult"]
                                                    ["fixedProduct"] ==
                                                "N"
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    top: cHeight * 0.01),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      MyLocalizations.of(context).word(
                                                              "minimumQuantity",
                                                              "Minimum Quantity") +
                                                          ":",
                                                      style: TextStyle(
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                    Text(
                                                      " ${adData["custRequestResult"][0]["custRequestResult"]["minimumQuantity"]} ${adData["custRequestResult"][0]["custRequestResult"]["minimumUnit"]} ",
                                                      style: TextStyle(
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Offstage(),
                                        adData["custRequestResult"][0]
                                                        ["custRequestResult"]
                                                    ["fixedProduct"] ==
                                                "N"
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    top: cHeight * 0.01),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      MyLocalizations.of(
                                                                  context)
                                                              .word(
                                                                  "minimumAmount",
                                                                  "Minimum Amount") +
                                                          ":",
                                                      style: TextStyle(
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                    Text(
                                                      " Rs. ${adData["custRequestResult"][0]["custRequestResult"]["minimumAmount"]}",
                                                      style: TextStyle(
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Offstage(),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: cHeight * 0.01),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                MyLocalizations.of(context).word(
                                                        "additionalInformation",
                                                        "Additional Information") +
                                                    ":",
                                                style: TextStyle(
                                                  // fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: textColor,
                                                ),
                                              ),
                                              Text(
                                                "${adData["custRequestResult"][0]["custRequestResult"]["description"]}",
                                                style: TextStyle(
                                                  // fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        adData["custRequestResult"][0]
                                                        ["custRequestResult"]
                                                    ["fixedProduct"] ==
                                                "Y"
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    top: cHeight * 0.01),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      MyLocalizations.of(
                                                                  context)
                                                              .word(
                                                                  "fixedPrice",
                                                                  "Fixed Price") +
                                                          ":",
                                                      style: TextStyle(
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                    Text(
                                                      " Rs.${adData["custRequestResult"][0]["custRequestResult"]["maximumAmount"]} / ${adData["custRequestResult"][0]["custRequestResult"]["unitForFxiedPrice"]} ",
                                                      style: TextStyle(
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Offstage(),
                                        adData["custRequestResult"][0]
                                                        ["custRequestResult"]
                                                    ["amount"] !=
                                                null
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    top: cHeight * 0.01),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      "Amount:",
                                                      style: TextStyle(
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                    Text(
                                                      " Rs. ${adData["custRequestResult"][0]["custRequestResult"]["amount"].toInt()}",
                                                      style: TextStyle(
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Offstage(),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: cHeight * 0.01),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                MyLocalizations.of(context)
                                                        .word("availableFrom",
                                                            "Available from") +
                                                    ":",
                                                style: TextStyle(
                                                  // fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: textColor,
                                                ),
                                              ),
                                              Text(
                                                " ${DateFormat('dd-MM-yyyy').format(DateTime.parse(adData["custRequestResult"][0]["closedDateTime"]))}",
                                                style: TextStyle(
                                                  // fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        locationName != null
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    top: cHeight * 0.01),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      MyLocalizations.of(
                                                                  context)
                                                              .word("location",
                                                                  "Location") +
                                                          ": ",
                                                      style: TextStyle(
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: cWidth * 0.6,
                                                      child: Text(
                                                        "$locationName",
                                                        style: TextStyle(
                                                          // fontWeight: FontWeight.bold,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Offstage(),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: cHeight * 0.02, left: cWidth * 0.04),
                                  child: Text(
                                    "Bidder's Detail",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                FutureBuilder(
                                    future: getAdDetail(),
                                    builder: (context,
                                        AsyncSnapshot<AdDetailModel> snapshot) {
                                      if (snapshot.hasData) {
                                        return Column(
                                            children: new List.generate(
                                                snapshot.data.bidList.length,
                                                (index) => Card(
                                                      elevation: 1,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          top: cHeight * 0.01,
                                                          left: cWidth * 0.02,
                                                          right: cWidth * 0.02,
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: cHeight *
                                                                          0.01),
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
                                                                    "Name:",
                                                                    style:
                                                                        TextStyle(
                                                                      // fontWeight: FontWeight.bold,
                                                                      fontSize:
                                                                          14,
                                                                      color:
                                                                          textColor,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    " ${snapshot.data.bidList[index].name}",
                                                                    style:
                                                                        TextStyle(
                                                                      // fontWeight: FontWeight.bold,
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: cHeight *
                                                                          0.01),
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
                                                                    "Bid Amount:",
                                                                    style:
                                                                        TextStyle(
                                                                      // fontWeight: FontWeight.bold,
                                                                      fontSize:
                                                                          14,
                                                                      color:
                                                                          textColor,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    " Rs. ${snapshot.data.bidList[index].bidDetail.totalAmount}",
                                                                    style:
                                                                        TextStyle(
                                                                      // fontWeight: FontWeight.bold,
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: cHeight *
                                                                          0.01),
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
                                                                    MyLocalizations.of(context).word(
                                                                            "quantity",
                                                                            "Quantity") +
                                                                        ":",
                                                                    style:
                                                                        TextStyle(
                                                                      // fontWeight: FontWeight.bold,
                                                                      fontSize:
                                                                          14,
                                                                      color:
                                                                          textColor,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    " ${snapshot.data.bidList[index].bidDetail.quantity.toInt()}",
                                                                    style:
                                                                        TextStyle(
                                                                      // fontWeight: FontWeight.bold,
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            snapshot
                                                                        .data
                                                                        .bidList[
                                                                            index]
                                                                        .bidDetail
                                                                        .comments !=
                                                                    null
                                                                ? Padding(
                                                                    padding: EdgeInsets.only(
                                                                        top: cHeight *
                                                                            0.01),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        Text(
                                                                          "Comment:",
                                                                          style:
                                                                              TextStyle(
                                                                            // fontWeight: FontWeight.bold,
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                textColor,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          "${snapshot.data.bidList[index].bidDetail.comments}",
                                                                          style:
                                                                              TextStyle(
                                                                            // fontWeight: FontWeight.bold,
                                                                            fontSize:
                                                                                12,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                : Offstage(),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: cHeight *
                                                                          0.01),
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
                                                                    MyLocalizations.of(context).word(
                                                                            "contactNumber",
                                                                            "Contact Number") +
                                                                        ":",
                                                                    style:
                                                                        TextStyle(
                                                                      // fontWeight: FontWeight.bold,
                                                                      fontSize:
                                                                          14,
                                                                      color:
                                                                          textColor,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    " ${snapshot.data.bidList[index].bidderPhoneNumber}",
                                                                    style:
                                                                        TextStyle(
                                                                      // fontWeight: FontWeight.bold,
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                top: cHeight *
                                                                    0.01,
                                                                bottom:
                                                                    cHeight *
                                                                        0.01,
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: <
                                                                    Widget>[
                                                                  // snapshot.data.bidList[index].status ==
                                                                  //             "QUO_REJECTED" ||
                                                                  snapshot.data.bidList[index].status ==
                                                                          "QUO_CREATED"
                                                                      ? RaisedButton(
                                                                          color:
                                                                              buttonColor,
                                                                          child:
                                                                              Text(
                                                                            "Accept",
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            respondBid("Accept",
                                                                                snapshot.data.bidList[index].bidDetail.quoteId);
                                                                          },
                                                                        )
                                                                      : snapshot.data.bidList[index].status ==
                                                                              "QUO_APPROVED"
                                                                          ? Text(
                                                                              "Accepted",
                                                                              style: TextStyle(
                                                                                // fontWeight: FontWeight.bold,
                                                                                fontSize: 12,
                                                                                color: Colors.green,
                                                                              ),
                                                                            )
                                                                          : Offstage(),
                                                                  // RaisedButton(
                                                                  //   color:
                                                                  //       buttonColor,
                                                                  //   child: Text(
                                                                  //     "Chat",
                                                                  //     style: TextStyle(
                                                                  //         color: Colors
                                                                  //             .white),
                                                                  //   ),
                                                                  //   // color: buttonColor,
                                                                  //   onPressed: () {},
                                                                  // ),
                                                                  // snapshot.data.bidList[index].status ==
                                                                  //             "QUO_APPROVED" ||
                                                                  snapshot.data.bidList[index].status ==
                                                                          "QUO_CREATED"
                                                                      ? RaisedButton(
                                                                          color:
                                                                              buttonColor,
                                                                          child:
                                                                              Text(
                                                                            "Reject",
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          ),
                                                                          // color: buttonColor,
                                                                          onPressed:
                                                                              () {
                                                                            respondBid("Reject",
                                                                                snapshot.data.bidList[index].bidDetail.quoteId);
                                                                          },
                                                                        )
                                                                      : snapshot.data.bidList[index].status ==
                                                                              "QUO_REJECTED"
                                                                          ? Text(
                                                                              "Rejected",
                                                                              style: TextStyle(
                                                                                // fontWeight: FontWeight.bold,
                                                                                fontSize: 12,
                                                                                color: Colors.red,
                                                                              ),
                                                                            )
                                                                          : Offstage(),
                                                                ],
                                                              ),
                                                            ),
                                                            // Container(
                                                            //   width: cWidth,
                                                            //   height: cHeight *
                                                            //       0.002,
                                                            //   color:
                                                            //       Colors.grey,
                                                            // ),
                                                          ],
                                                        ),
                                                      ),
                                                    )));
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    }),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ],
        ),
      ),
    );
  }
}
