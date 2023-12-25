import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:marketplace_patanjali/Functions/error_handling.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';
import 'package:marketplace_patanjali/LanguageSetup/localizations.dart';
import 'package:marketplace_patanjali/Models/add_bid_model.dart';
import 'package:marketplace_patanjali/Models/category_model.dart';
import 'package:marketplace_patanjali/Models/primary_category_model.dart';
import 'package:marketplace_patanjali/Models/variety_model.dart';
import 'package:marketplace_patanjali/resources/http_requests.dart';
import 'package:marketplace_patanjali/ui/Screens/cart_screen.dart';
import 'package:marketplace_patanjali/ui/Widgets/comment_alert.dart';
import 'package:marketplace_patanjali/ui/Widgets/photo_view.dart';
import 'package:marketplace_patanjali/ui/Widgets/title_app_bar.dart';
import 'package:marketplace_patanjali/ui/Widgets/user_drawer.dart';
import 'package:marketplace_patanjali/ui/Widgets/widget_methods.dart';

class AddBidScreen extends StatefulWidget {
  final String userToken;
  final String userId;
  final String custRequestId;
  final bool addBidOp;
  final String inventoryItemId;
  final String fixedProduct;

  final String userName;
  final String userPhoneNum;
  const AddBidScreen({
    Key key,
    this.userToken,
    this.userId,
    this.custRequestId,
    this.addBidOp,
    this.userName,
    this.userPhoneNum,
    this.inventoryItemId,
    this.fixedProduct,
  }) : super(key: key);
  @override
  _AddBidScreenState createState() => _AddBidScreenState();
}

class _AddBidScreenState extends State<AddBidScreen> {
  String title = "Annadata MarketPlace";
  Color titleColor = Color(0xFF009D37);
  Color textColor = Color(0xFF009D37);
  Color barColor = Colors.white;

  PrimaryCategoryModel primaryCategoryData;
  List primaryCategoryList = [];
  String currentPrimaryCategory;
  int primaryIndex = 0;

  CategoryModel categoryData;
  List categoryList = [];
  String currentCategory;
  int categoryIndex = 0;

  CategoryModel cropData;
  List cropList = [];
  String currentCrop;
  int cropIndex = 0;

  VarietyModel varietyData;
  List varietyList = [];
  String currentVariety;
  int varietyIndex = 0;
  String locationName;

  TextEditingController quantityController = TextEditingController();
  TextEditingController bidController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();

  ApiBase _apiBase = ApiBase();
  var adData;
  bool connetion = false;
  String bidId;
  String sellerName = "Seller";
  bool loading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    print("^^^^^${widget.custRequestId}");
    // var param = {
    //   "custRequestId": widget.custRequestId,
    //   "partyId": widget.userId
    // };
    var param = widget.fixedProduct == "N"
        ? {
            "custRequestId": widget.custRequestId,
            "inventoryItemId": widget.inventoryItemId,
            "partyId": widget.userId
          }
        : {"inventoryItemId": widget.inventoryItemId, "partyId": widget.userId};
    _apiBase
        .get(context, "/api/getRequestDetailById", param, widget.userToken)
        .then((val) {
      print("##${val.body}##");
      var data = json.decode(val.body);
      setState(() {
        adData = data;
        bidId = adData["custRequestResult"][0]["bidId"];
        sellerName = adData["custRequestResult"][0]["sellerName"];
        connetion = true;
        // locationName =
        //     "${adData["custRequestResult"][0]["locationDetail"]["district"]}, ${adData["custRequestResult"][0]["locationDetail"]["state"]}";
      });
      if (adData["custRequestResult"][0]["locationDetail"]["latitude"] !=
              null &&
          adData["custRequestResult"][0]["locationDetail"]["longitude"] !=
              null) {
        setState(() {
          locationName =
              "${adData["custRequestResult"][0]["locationDetail"]["district"]}, ${adData["custRequestResult"][0]["locationDetail"]["state"]}";
        });
        // getLocationName(
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
        actions: <Widget>[
          Stack(
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CartScreen(
                              userToken: widget.userToken,
                              userId: widget.userId,
                              // userName: widget.userName,
                              // userPhoneNum: widget.userPhoneNum,
                            )));
                  }),
              Positioned(
                  left: 25,
                  child: CircleAvatar(
                    child: Text(
                      "$finalCartCount",
                      style: TextStyle(fontSize: 12),
                    ),
                    radius: 9,
                    backgroundColor: Colors.red,
                  )),
            ],
          )
        ],
      ),
      drawer: UserDrawer(
        userId: widget.userId,
        userName: widget.userName,
        userPhoneNum: widget.userPhoneNum,
        userToken: widget.userToken,
      ),
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          new Center(
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
                                key: _formKey,
                                child: ListView(
                                  children: <Widget>[
                                    Card(
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                                  builder:
                                                                      (context) =>
                                                                          PhotoViewScreen(
                                                                            imageUrl:
                                                                                adData["custRequestResult"][0]["images"][0]["imageUrl"],
                                                                          )));
                                                        },
                                                        child: FadeInImage
                                                            .assetNetwork(
                                                          placeholder:
                                                              "assets/images/imageplaceholder.png",
                                                          image: adData[
                                                                      "custRequestResult"]
                                                                  [0]["images"]
                                                              [0]["imageUrl"],
                                                          height:
                                                              cHeight * 0.13,
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
                                                                        "primaryCategories",
                                                                        "Primary Categories") +
                                                                ":",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                                                          "category",
                                                                          "Category") +
                                                                  ":",
                                                              style: TextStyle(
                                                                // fontWeight: FontWeight.bold,
                                                                fontSize: 14,
                                                                color:
                                                                    textColor,
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
                                                      adData["custRequestResult"]
                                                                      [0][
                                                                  "cropName"] !=
                                                              null
                                                          ? Padding(
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
                                                                            "cropName",
                                                                            "Crop Name") +
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
                                                                    " ${adData["custRequestResult"][0]["cropName"]}",
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
                                                                          "variety",
                                                                          "Variety") +
                                                                  ":",
                                                              style: TextStyle(
                                                                // fontWeight: FontWeight.bold,
                                                                fontSize: 14,
                                                                color:
                                                                    textColor,
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
                                                                          "quality",
                                                                          "Quality") +
                                                                  ":",
                                                              style: TextStyle(
                                                                // fontWeight: FontWeight.bold,
                                                                fontSize: 14,
                                                                color:
                                                                    textColor,
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
                                            adData["custRequestResult"][0][
                                                            "custRequestResult"]
                                                        ["fixedProduct"] ==
                                                    "N"
                                                ? Padding(
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
                                            adData["custRequestResult"][0][
                                                            "custRequestResult"]
                                                        ["fixedProduct"] ==
                                                    "N"
                                                ? Padding(
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
                                            adData["custRequestResult"][0][
                                                            "custRequestResult"]
                                                        ["fixedProduct"] ==
                                                    "Y"
                                                ? Padding(
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
                                            adData["custRequestResult"][0][
                                                            "custRequestResult"]
                                                        ["amount"] !=
                                                    null
                                                ? Padding(
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
                                                            .word(
                                                                "availableFrom",
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
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          MyLocalizations.of(
                                                                      context)
                                                                  .word(
                                                                      "location",
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
                                            adData["custRequestResult"][0][
                                                                "custRequestResult"]
                                                            ["fixedProduct"] !=
                                                        "Y" &&
                                                    bidId == null
                                                ? Padding(
                                                    padding: EdgeInsets.only(
                                                        top: cHeight * 0.01),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Text(
                                                          "Bid Amount:",
                                                          style: TextStyle(
                                                            // fontWeight: FontWeight.bold,
                                                            fontSize: 14,
                                                            color: textColor,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: cWidth * 0.55,
                                                          child: TextFormField(
                                                            controller:
                                                                bidController,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            decoration:
                                                                InputDecoration(
                                                              prefixText:
                                                                  "Rs. ",
                                                              suffixText:
                                                                  "per ${adData["custRequestResult"][0]["custRequestResult"]["unit"]}",
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .all(4),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                            ),
                                                            onChanged: (val) {
                                                              totalAmountController
                                                                  .text = (double.parse(
                                                                          quantityController
                                                                              .text) *
                                                                      double.parse(
                                                                          bidController
                                                                              .text))
                                                                  .toString();
                                                            },
                                                            validator: (value) {
                                                              if (value
                                                                      .length ==
                                                                  0) {
                                                                return ('Enter bid amount');
                                                              } else {
                                                                return null;
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Offstage(),
                                            adData["custRequestResult"][0][
                                                                "custRequestResult"]
                                                            ["fixedProduct"] !=
                                                        "Y" &&
                                                    bidId == null
                                                ? Padding(
                                                    padding: EdgeInsets.only(
                                                        top: cHeight * 0.01),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Text(
                                                          MyLocalizations.of(
                                                                      context)
                                                                  .word(
                                                                      "quantity",
                                                                      "Quantity") +
                                                              ":",
                                                          style: TextStyle(
                                                            // fontWeight: FontWeight.bold,
                                                            fontSize: 14,
                                                            color: textColor,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: cWidth * 0.55,
                                                          child: TextFormField(
                                                            controller:
                                                                quantityController,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            decoration:
                                                                InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .all(4),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                            ),
                                                            onChanged: (val) {
                                                              totalAmountController
                                                                  .text = (double.parse(
                                                                          quantityController
                                                                              .text) *
                                                                      double.parse(
                                                                          bidController
                                                                              .text))
                                                                  .toString();
                                                            },
                                                            validator: (value) {
                                                              if (value
                                                                      .length ==
                                                                  0) {
                                                                return ('Enter quantity');
                                                              } else if (int
                                                                      .parse(
                                                                          value) >
                                                                  adData["custRequestResult"][0]
                                                                              [
                                                                              "custRequestResult"]
                                                                          [
                                                                          "quantity"]
                                                                      .toInt()) {
                                                                return "Quantity can be upto ${adData["custRequestResult"][0]["custRequestResult"]["quantity"].toInt()}";
                                                              } else {
                                                                return null;
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Offstage(),
                                            adData["custRequestResult"][0][
                                                                "custRequestResult"]
                                                            ["fixedProduct"] !=
                                                        "Y" &&
                                                    bidId == null
                                                ? Padding(
                                                    padding: EdgeInsets.only(
                                                        top: cHeight * 0.01),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Text(
                                                          "Total Amount:",
                                                          style: TextStyle(
                                                            // fontWeight: FontWeight.bold,
                                                            fontSize: 14,
                                                            color: textColor,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: cWidth * 0.55,
                                                          child: TextFormField(
                                                            controller:
                                                                totalAmountController,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            decoration:
                                                                InputDecoration(
                                                              prefixText:
                                                                  "Rs. ",
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .all(4),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                            ),
                                                            validator: (value) {
                                                              if (value
                                                                      .length ==
                                                                  0) {
                                                                return ('Enter total amount');
                                                              } else {
                                                                return null;
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Offstage(),
                                            bidId == null && widget.addBidOp
                                                ? Padding(
                                                    padding: EdgeInsets.only(
                                                        top: cHeight * 0.05),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        RaisedButton(
                                                          child: adData["custRequestResult"]
                                                                              [
                                                                              0]
                                                                          [
                                                                          "custRequestResult"]
                                                                      [
                                                                      "fixedProduct"] ==
                                                                  "N"
                                                              ? Text(
                                                                  "Bid Now",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                )
                                                              : Text(
                                                                  "Buy Now",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                          color:
                                                              Color(0xFF0047C4),
                                                          disabledColor:
                                                              Colors.grey,
                                                          onPressed: loading
                                                              ? null
                                                              : () {
                                                                  _validate();
                                                                },
                                                        ),
                                                        // RaisedButton(
                                                        //   child: Text(
                                                        //     "OK",
                                                        //     style: TextStyle(
                                                        //       color: Colors.white,
                                                        //     ),
                                                        //   ),
                                                        //   color: textColor,
                                                        //   onPressed: () {
                                                        //     postAd();
                                                        //   },
                                                        // ),
                                                      ],
                                                    ),
                                                  )
                                                : !widget.addBidOp
                                                    ? Offstage()
                                                    : Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: cHeight *
                                                                    0.05),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              Text(
                                                                "Bid Added",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 14,
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
          loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Offstage()
        ],
      ),
    );
  }

  void _validate() {
    if (_formKey.currentState.validate()) {
      print(
          adData["custRequestResult"][0]["custRequestResult"]["fixedProduct"]);
      _formKey.currentState.save();
      setState(() {
        loading = true;
      });
      ReqData reqData1 = ReqData(
          custRequestId: adData["custRequestResult"][0]["custRequestResult"]
              ["custRequestId"],
          partyId: widget.userId,
          quantity: quantityController.text,
          quoteUnitPrice: bidController.text,
          totalAmount: adData["custRequestResult"][0]["custRequestResult"]
                      ["fixedProduct"] !=
                  "Y"
              ? double.parse(totalAmountController.text)
              : 0,
          fixedProduct: "N",
          custRequestItemSeqId: adData["custRequestResult"][0]
              ["custRequestResult"]["custRequestItemSeqId"],
          unit: adData["custRequestResult"][0]["custRequestResult"]["unit"]);

      AddBidModel addBid1 = AddBidModel(reqData: reqData1);

      ReqDataFixed reqData2 = ReqDataFixed(
        custRequestId: adData["custRequestResult"][0]["custRequestResult"]
            ["custRequestId"],
        custRequestItemSeqId: adData["custRequestResult"][0]
            ["custRequestResult"]["custRequestItemSeqId"],
        partyId: widget.userId,
        // fixedProduct: "Y",
        // unit: adData["custRequestResult"][0]["custRequestResult"]["unit"]
      );
      AddBidModelFixed addBid2 = AddBidModelFixed(reqData: reqData2);

      var body = adData["custRequestResult"][0]["custRequestResult"]
                  ["fixedProduct"] !=
              "Y"
          ? addBid1
          : addBid2;

      _apiBase
          .post(context, "/api/createQuoteFromRequest", null, body,
              widget.userToken)
          .then((val) {
        setState(() {
          loading = false;
        });
        print(json.encode(body));
        if (val.statusCode == 200) {
          var d = json.decode(val.body);
          if (d["errorMessage"] == null) {
            print("##${val.body}##");
            var d = json.decode(val.body);
            setState(() {
              bidId = d["quoteId"];
            });
            showDialog(
                context: context,
                builder: (_) {
                  return MyDialog(
                    quoteId: d["quoteId"],
                    userToken: widget.userToken,
                  );
                });
          } else {
            ErrorHandling()
                .showErrorDailog(context, "Error", d["errorMessage"]);
          }
        }
      });
    }
  }
}
