import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';
import 'package:marketplace_patanjali/LanguageSetup/localizations.dart';
import 'package:marketplace_patanjali/Models/category_model.dart';
import 'package:marketplace_patanjali/Models/post_ad_model.dart';
import 'package:marketplace_patanjali/Models/primary_category_model.dart';
import 'package:marketplace_patanjali/Models/variety_model.dart';
import 'package:marketplace_patanjali/resources/http_requests.dart';
import 'package:marketplace_patanjali/ui/Widgets/location_screen.dart';
import 'package:marketplace_patanjali/ui/Widgets/user_drawer.dart';
import 'package:marketplace_patanjali/ui/Widgets/widget_methods.dart';

class PostAdScreen extends StatefulWidget {
  final Function navigateMyAds;
  final String userToken;
  final String userId;
  final String userName;
  final String userPhoneNum;
  final String primaryCategory;
  final String cropType;
  final String cropName;
  const PostAdScreen({
    Key key,
    this.userToken,
    this.userId,
    this.primaryCategory,
    this.cropType,
    this.cropName,
    this.navigateMyAds,
    this.userName,
    this.userPhoneNum,
  }) : super(key: key);
  @override
  _PostAdScreenState createState() => _PostAdScreenState();
}

class _PostAdScreenState extends State<PostAdScreen> {
  String title = "Annadata MarketPlace";
  Color titleColor = Color(0xFF009D37);
  Color textColor = Color(0xFF009D37);
  Color barColor = Colors.white;

  String adType = "SELL";

  DateTime dateSelected = DateTime.now();

  int stepNum = 1;

  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

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

  List qualityList = [];
  List qualityIdList = [];
  String currentQuality;
  int qualityIndex = 0;

  List unitList = [];
  List unitIdList = [];
  int unitIndex = 0;
  String currentUnit;
  int amountUnitIndex = 0;
  String currentAmountUnit;
  int minimumUnitIndex = 0;
  String currentMinimumUnit;
  int unitForMinimumAmountIndex = 0;
  String unitForMinimumAmount;

  bool fixedPrice = false;

  TextEditingController quantityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  TextEditingController minAmountController = TextEditingController();

  TextEditingController minQuantityController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController certificateController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  ApiBase _apiBase = ApiBase();

  bool uploading = false;

  //Image
  File imageFile;
  List<int> imageBytes;
  String base64Image;
  String imageName;
  String imageFormat;

  List<UploadImage> imagesList = [];
  List<File> imagesFileList = [];

  //Video
  File videoFile;
  List<int> videoBytes;
  String base64Video;
  String videoName;
  String videoFormat;

  List<UploadVideo> videosList = [];
  List<File> videosFileList = [];

  bool deliverGoods = false;
  // List<int> imageBytes = imageFile.readAsBytesSync();
  // String base64Image = base64Encode(imageBytes);
  Coordinates coordinates;

  String latitude;
  String longitude;
  String country;
  String state;
  String district;
  String tehsil;
  String block;
  String village;

  //Get Location Name
  Future onLoationChange(LatLng loc) async {
    print("object");
    coordinates = new Coordinates(loc.latitude, loc.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    Address first = addresses.first;
    setState(() {
      locationController.text = first.addressLine;
      latitude = loc.latitude.toString();
      longitude = loc.longitude.toString();
      country = first.countryName;
      state = first.adminArea;
      district = first.subAdminArea;
      tehsil = first.subLocality;
      block = first.thoroughfare;
      village = first.subThoroughfare;
    });
    // print("${first.featureName} : ${first.addressLine}");
    // return first;
  }

  //Change Dropdowns
  void changedDropDownPrimaryCat(String selectedPrimaryCategory) {
    primaryIndex = primaryCategoryList.indexOf(selectedPrimaryCategory);
    categoryIndex = 0;
    varietyIndex = 0;
    categoryList.clear();
    varietyList.clear();
    currentCategory = null;
    currentVariety = null;
    setState(() {
      uploading = true;
      currentPrimaryCategory = selectedPrimaryCategory;
    });
    var param = {
      "primaryParentCategoryId": primaryCategoryData
          .prodCatalogCategoryList[primaryIndex].productCategoryId
    };
    _apiBase
        .get(context, "/api/getRelatedCategoryList", param, widget.userToken)
        .then((val) {
      if (val.statusCode == 200) {
        setState(() {
          uploading = false;
        });
        setState(() {
          categoryData = categoryModelFromJson(val.body);
          for (int i = 0; i < categoryData.categories.length; i++) {
            categoryList.add(categoryData.categories[i].categoryName);
          }
        });
        print(categoryList);
      }
    });
  }

  void changedDropDownCat(String selectedCategory) {
    categoryIndex = categoryList.indexOf(selectedCategory);
    varietyIndex = 0;
    cropList.clear();
    currentCrop = null;
    varietyList.clear();
    currentVariety = null;
    setState(() {
      uploading = true;
      currentCategory = selectedCategory;
    });
    if (categoryData.categories[categoryIndex].showChildCategory == "Y") {
      var param = {
        "primaryParentCategoryId":
            categoryData.categories[categoryIndex].productCategoryId
      };
      _apiBase
          .get(context, "/api/getRelatedCategoryList", param, widget.userToken)
          .then((val) {
        setState(() {
          uploading = false;
        });
        if (val.statusCode == 200) {
          setState(() {
            cropData = categoryModelFromJson(val.body);
            for (int i = 0; i < cropData.categories.length; i++) {
              cropList.add(cropData.categories[i].categoryName);
            }
          });
          print(varietyList);
        }
      });
    } else {
      var param = {
        "productCategoryId":
            categoryData.categories[categoryIndex].productCategoryId
      };
      _apiBase
          .get(context, "/api/getProductCategoryMembers", param,
              widget.userToken)
          .then((val) {
        setState(() {
          uploading = false;
        });
        if (val.statusCode == 200) {
          setState(() {
            varietyData = varietyModelFromJson(val.body);
            for (int i = 0; i < varietyData.productMembersList.length; i++) {
              varietyList.add(varietyData.productMembersList[i].productName);
            }
          });
          print(varietyList);
        }
      });
    }
  }

  void changedDropDownCrop(String selectedCrop) {
    cropIndex = cropList.indexOf(selectedCrop);
    setState(() {
      uploading = true;
      currentCrop = selectedCrop;
    });
    var param = {"productCategoryId": currentCrop};
    _apiBase
        .get(context, "/api/getProductCategoryMembers", param, widget.userToken)
        .then((val) {
      setState(() {
        uploading = false;
      });
      if (val.statusCode == 200) {
        setState(() {
          varietyData = varietyModelFromJson(val.body);
          for (int i = 0; i < varietyData.productMembersList.length; i++) {
            varietyList.add(varietyData.productMembersList[i].productName);
          }
        });
        print(varietyList);
      }
    });
  }

  void changedDropDownVariety(String selectedVariety) {
    varietyIndex = varietyList.indexOf(selectedVariety);
    print(varietyIndex);
    setState(() {
      currentVariety = selectedVariety;
    });
    // var param = {"productCategoryId": currentCategory};
    // _apiBase
    //     .get(context, "/api/getProductCategoryMembers", param, widget.userToken)
    //     .then((val) {
    //   if (val.statusCode == 200) {
    //     setState(() {
    //       varietyData = varietyModelFromJson(val.body);
    //       for (int i = 0; i < varietyData.productMembersList.length; i++) {
    //         varietyList.add(varietyData.productMembersList[i].productName);
    //       }
    //     });
    //     print(varietyList);
    //   }
    // });
  }

  void changedDropDownQuality(String selectedQuality) {
    qualityIndex = qualityList.indexOf(selectedQuality);
    setState(() {
      currentQuality = selectedQuality;
    });
  }

  void changedDropDownUnit(String selectedUnit) {
    unitIndex = unitList.indexOf(selectedUnit);
    // qualityIndex = qualityList.indexOf(selectedUnit);
    setState(() {
      currentUnit = selectedUnit;
    });
  }

  void changedDropDownAmountUnit(String selectedAmountUnit) {
    amountUnitIndex = unitList.indexOf(selectedAmountUnit);
    // qualityIndex = qualityList.indexOf(selectedUnit);
    setState(() {
      currentAmountUnit = selectedAmountUnit;
    });
  }

  void changedDropDownMinimumUnit(String selectedMinimumUnit) {
    minimumUnitIndex = unitList.indexOf(selectedMinimumUnit);
    // qualityIndex = qualityList.indexOf(selectedUnit);
    setState(() {
      currentMinimumUnit = selectedMinimumUnit;
    });
  }

  void changedDropDownUnitForMinimumAmount(
      String selectedUnitForMinimumAmount) {
    unitForMinimumAmountIndex = unitList.indexOf(selectedUnitForMinimumAmount);
    // qualityIndex = qualityList.indexOf(selectedUnit);
    setState(() {
      unitForMinimumAmount = selectedUnitForMinimumAmount;
    });
  }

  @override
  void initState() {
    print(widget.primaryCategory);
    print("!!${widget.cropType}");
    print(widget.cropName);
    _apiBase
        .get(context, "/api/getParentCategoryList", null, widget.userToken)
        .then((val) {
      if (val.statusCode == 200) {
        setState(() {
          primaryCategoryData = primaryCategoryModelFromJson(val.body);
          for (int i = 0;
              i < primaryCategoryData.prodCatalogCategoryList.length;
              i++) {
            primaryCategoryList.add(
                primaryCategoryData.prodCatalogCategoryList[i].categoryName);
          }
          if (widget.primaryCategory != null) {
            if (primaryCategoryList.contains(widget.primaryCategory)) {
              currentPrimaryCategory = widget.primaryCategory;
              primaryIndex =
                  primaryCategoryList.indexOf(widget.primaryCategory);
              var param = {
                "primaryParentCategoryId": primaryCategoryData
                    .prodCatalogCategoryList[primaryIndex].productCategoryId
              };
              _apiBase
                  .get(context, "/api/getRelatedCategoryList", param,
                      widget.userToken)
                  .then((val) {
                if (val.statusCode == 200) {
                  setState(() {
                    categoryData = categoryModelFromJson(val.body);
                    for (int i = 0; i < categoryData.categories.length; i++) {
                      categoryList.add(categoryData.categories[i].categoryName);
                    }
                    //
                    if (categoryList.contains(widget.cropType)) {
                      currentCategory = widget.cropType;
                      categoryIndex = categoryList.indexOf(widget.cropType);
                      var param = {"productCategoryId": currentCategory};
                      _apiBase
                          .get(context, "/api/getProductCategoryMembers", param,
                              widget.userToken)
                          .then((val) {
                        if (val.statusCode == 200) {
                          setState(() {
                            varietyData = varietyModelFromJson(val.body);
                            for (int i = 0;
                                i < varietyData.productMembersList.length;
                                i++) {
                              varietyList.add(varietyData
                                  .productMembersList[i].productName);
                            }
                            if (varietyList.contains(widget.cropName)) {
                              currentVariety = widget.cropName;

                              varietyIndex =
                                  varietyList.indexOf(widget.cropName);
                            }
                          });
                        }
                      });
                    }
                  });
                }
              });
            }
          }
        });
        _apiBase
            .get(context, "/api/getQualityList", null, widget.userToken)
            .then((val) {
          if (val.statusCode == 200) {
            setState(() {
              var qualityData = json.decode(val.body);
              for (int i = 0; i < qualityData["qualityList"].length; i++) {
                qualityList.add(qualityData["qualityList"][i]["description"]);
                qualityIdList.add(qualityData["qualityList"][i]["enumId"]);
              }
            });
          }
        });
        _apiBase
            .get(context, "/api/getUnitList", null, widget.userToken)
            .then((qlval) {
          var qlData = json.decode(qlval.body);
          setState(() {
            for (int i = 0; i < qlData["unitList"].length; i++) {
              unitList.add(qlData["unitList"][i]["description"]);
              unitIdList.add(qlData["unitList"][i]["enumId"]);
            }
            currentUnit = unitList[0];
            currentAmountUnit = unitList[0];
            currentMinimumUnit = unitList[0];
            unitForMinimumAmount = unitList[0];
          });
        });
      }
    });
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  EdgeInsetsGeometry dropdownPadding =
      EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 10);

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;

    return new Scaffold(
      drawer: UserDrawer(
        userId: widget.userId,
        userToken: widget.userToken,
        userName: widget.userName,
        userPhoneNum: widget.userPhoneNum,
      ),
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
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.navigate_before,
              color: Colors.white,
              size: 17,
            ),
            onPressed: () {
              setState(() {
                if (stepNum != 1) {
                  stepNum--;
                }
              });
            },
          )
        ],
      ),
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          uploading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Offstage(),
          new Padding(
            padding: EdgeInsets.only(top: cHeight * 0.01),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Padding(
                //   padding: EdgeInsets.only(top: cHeight * 0.05),
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: <Widget>[
                //       IconButton(
                //         icon: Icon(
                //           Icons.menu,
                //           color: Color(0xFF0047C4),
                //         ),
                //         onPressed: () {
                //           Scaffold.of(context).openDrawer();
                //         },
                //       ),
                //       Padding(
                //         padding: EdgeInsets.only(top: cHeight * 0.015),
                //         child: Text(
                //           MyLocalizations.of(context)
                //               .word("annadataMarketplace", title),
                //           style:
                //               TextStyle(color: Color(0xFF009D37), fontSize: 20),
                //         ),
                //       ),
                //       IconButton(
                //         icon: Icon(
                //           Icons.navigate_before,
                //           color: Color(0xFF0047C4),
                //         ),
                //         onPressed: () {
                //           setState(() {
                //             if (stepNum != 1) {
                //               stepNum--;
                //             }
                //           });
                //         },
                //       ),
                //     ],
                //   ),
                // ),
                Expanded(
                  // width: cWidth,
                  // height: cHeight * 0.735,
                  // color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: cHeight * 0.07,
                        child: Column(
                          children: <Widget>[
                            Text(
                              MyLocalizations.of(context).word(
                                  "step${stepNum}Of3", "Step ${stepNum} of 3"),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.grey[700],
                              ),
                            ),
                            stepNum != 3
                                ? Text(
                                    "Seller",
                                    style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: textColor,
                                    ),
                                  )
                                : Text(
                                    MyLocalizations.of(context)
                                        .word("adPreview", "Ad Preview"),
                                    style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: textColor,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      stepNum == 1
                          ? stepOne()
                          : stepNum == 2 ? stepTwo() : stepThree(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded stepOne() {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.only(
        left: cWidth * 0.05,
        right: cWidth * 0.05,
      ),
      child: ListView(
        children: <Widget>[
          Form(
            key: _formKey1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Text(
                //   "   Ad Type",
                //   style: TextStyle(
                //     // fontWeight: FontWeight.bold,
                //     fontSize: 19,
                //     color: textColor,
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(
                //     bottom: cHeight * 0.01,
                //     left: cWidth * 0.01,
                //     right: cWidth * 0.01,
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: <Widget>[
                //       RaisedButton(
                //         child: Text(
                //           "SELL",
                //           style: TextStyle(
                //             color:
                //                 adType == "SELL" ? Colors.white : Colors.black,
                //           ),
                //         ),
                //         color:
                //             adType == "SELL" ? Color(0xFF0047C4) : Colors.grey,
                //         onPressed: () {
                //           setState(() {
                //             adType = "SELL";
                //           });
                //         },
                //       ),
                //       RaisedButton(
                //         child: Text(
                //           "BUY",
                //           style: TextStyle(
                //             color:
                //                 adType == "BUY" ? Colors.white : Colors.black,
                //           ),
                //         ),
                //         color:
                //             adType == "BUY" ? Color(0xFF0047C4) : Colors.grey,
                //         onPressed: () {
                //           setState(() {
                //             adType = "BUY";
                //           });
                //         },
                //       )
                //     ],
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(bottom: cHeight * 0.01),
                  child: Text(
                    MyLocalizations.of(context).word("location", "   Location"),
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: textColor,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SelectLocation(
                              onLocationChange: onLoationChange,
                            )));
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      style: TextStyle(fontSize: 9),
                      controller: locationController,
                      decoration: InputDecoration(
                        contentPadding: dropdownPadding,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: "Location",
                        suffixIcon: Icon(Icons.gps_fixed),
                      ),
                      validator: (value) {
                        if (locationController.text == "") {
                          return ('Enter Location');
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: cHeight * 0.03, bottom: cHeight * 0.01),
                  child: Text(
                    MyLocalizations.of(context)
                        .word("primaryCategories", "   Primary Categories"),
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: textColor,
                    ),
                  ),
                ),
                DropdownButtonFormField(
                  // isExpanded: true,
                  hint: Text(
                    MyLocalizations.of(context).word(
                        "selectPrimaryCategory", "Select primary category"),
                  ),
                  decoration: InputDecoration(
                    contentPadding: dropdownPadding,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  items: getDropDownMenuItems(null, primaryCategoryList),
                  value: currentPrimaryCategory,
                  onChanged: changedDropDownPrimaryCat,
                  validator: (value) {
                    if (currentPrimaryCategory == null) {
                      return ('Select Primary Category');
                    } else {
                      return null;
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: cHeight * 0.03, bottom: cHeight * 0.01),
                  child: Text(
                    MyLocalizations.of(context)
                        .word("categories", "   Categories"),
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: textColor,
                    ),
                  ),
                ),
                DropdownButtonFormField(
                  hint: Text("Select category"),
                  // isExpanded: true,
                  decoration: InputDecoration(
                    contentPadding: dropdownPadding,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  items: getDropDownMenuItems(null, categoryList),
                  value: currentCategory,
                  onChanged: changedDropDownCat,
                  validator: (value) {
                    if (currentCategory == null) {
                      return ('Select Category');
                    } else {
                      return null;
                    }
                  },
                ),
                currentCategory != null &&
                        categoryData != null &&
                        categoryData
                                .categories[categoryIndex].showChildCategory ==
                            "Y"
                    ? Padding(
                        padding: EdgeInsets.only(
                            top: cHeight * 0.03, bottom: cHeight * 0.01),
                        child: Text(
                          MyLocalizations.of(context)
                              .word("cropName", "   Crop Name"),
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: textColor,
                          ),
                        ),
                      )
                    : Offstage(),
                currentCategory != null &&
                        categoryData != null &&
                        categoryData
                                .categories[categoryIndex].showChildCategory ==
                            "Y"
                    ? DropdownButtonFormField(
                        hint: Text("Select crop name"),
                        // isExpanded: true,
                        decoration: InputDecoration(
                          contentPadding: dropdownPadding,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        items: getDropDownMenuItems(null, cropList),
                        value: currentCrop,
                        onChanged: changedDropDownCrop,
                        validator: (value) {
                          if (categoryData.categories[categoryIndex]
                                      .showChildCategory ==
                                  "Y" &&
                              currentCrop == null) {
                            return ('Select Crop');
                          } else {
                            return null;
                          }
                        },
                      )
                    : Offstage(),
                Padding(
                  padding: EdgeInsets.only(
                      top: cHeight * 0.03, bottom: cHeight * 0.01),
                  child: Text(
                    MyLocalizations.of(context).word("variety", "   Variety"),
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: textColor,
                    ),
                  ),
                ),
                DropdownButtonFormField(
                  hint: Text("Select variety"),
                  // isExpanded: true,
                  decoration: InputDecoration(
                    contentPadding: dropdownPadding,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  items: getDropDownMenuItems(null, varietyList),
                  value: currentVariety,
                  onChanged: changedDropDownVariety,
                  validator: (value) {
                    if (currentVariety == null) {
                      return ('Select Variety');
                    } else {
                      return null;
                    }
                  },
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: cHeight * 0.02, bottom: cHeight * 0.01),
                    child: RaisedButton(
                      child: Text(
                        MyLocalizations.of(context).word("next", "Next"),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: titleColor,
                      onPressed: () {
                        _validate1();
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Expanded stepTwo() {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.only(
        left: cWidth * 0.05,
        right: cWidth * 0.05,
      ),
      child: ListView(
        children: <Widget>[
          Form(
            key: _formKey2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  MyLocalizations.of(context).word("quality", "   Quality"),
                  style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: textColor,
                  ),
                ),
                DropdownButtonFormField(
                  // isExpanded: true,
                  decoration: InputDecoration(
                    contentPadding: dropdownPadding,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  items: getDropDownMenuItems(null, qualityList),
                  value: currentQuality,
                  onChanged: changedDropDownQuality,
                  validator: (value) {
                    if (currentQuality == null) {
                      return ('Select Quality');
                    } else {
                      return null;
                    }
                  },
                ),
                currentQuality == "Certified Organic"
                    ? Padding(
                        padding: EdgeInsets.only(top: cHeight * 0.03),
                        child: Text(
                          "   Certificate Number",
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: textColor,
                          ),
                        ),
                      )
                    : Offstage(),
                currentQuality == "Certified Organic"
                    ? TextFormField(
                        controller: certificateController,
                        decoration: InputDecoration(
                          contentPadding: dropdownPadding,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) {
                          if (value.length == 0 &&
                              currentQuality == "Certified Organic") {
                            return ('Enter certificate number');
                          } else {
                            return null;
                          }
                        },
                      )
                    : Offstage(),
                Padding(
                  padding: EdgeInsets.only(top: cHeight * 0.03),
                  child: Text(
                    MyLocalizations.of(context).word("quantity", "   Quantity"),
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: textColor,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: cWidth * 0.5,
                      child: TextFormField(
                        // isExpanded: true,
                        keyboardType: TextInputType.number,
                        controller: quantityController,
                        decoration: InputDecoration(
                          contentPadding: dropdownPadding,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (value) {
                          if (value.length == 0) {
                            return ('Enter quantity');
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Container(
                      width: cWidth * 0.35,
                      child: DropdownButtonFormField(
                        // isExpanded: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 13, right: 13),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        items: getDropDownMenuItems(null, unitList),
                        value: currentUnit,
                        onChanged: changedDropDownUnit,
                        validator: (value) {
                          if (currentQuality == null) {
                            return ('Select Unit');
                          } else {
                            return null;
                          }
                        },
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: cHeight * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        MyLocalizations.of(context)
                                .word("fixedPrice", "   Fixed Price") +
                            "?",
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: textColor,
                        ),
                      ),
                      Switch(
                          value: fixedPrice,
                          onChanged: (change) {
                            setState(() {
                              fixedPrice = change;
                            });
                          })
                    ],
                  ),
                ),
                fixedPrice
                    ? Padding(
                        padding: EdgeInsets.only(top: cHeight * 0.03),
                        child: Text(
                          "   Amount",
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: textColor,
                          ),
                        ),
                      )
                    : Offstage(),
                fixedPrice
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: cWidth * 0.45,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: amountController,
                              decoration: InputDecoration(
                                prefixText: "Rs. ",
                                contentPadding: dropdownPadding,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (value) {
                                if (value.length == 0 && fixedPrice) {
                                  return ('Enter amount');
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Container(
                            width: cWidth * 0.4,
                            child: DropdownButtonFormField(
                              // isExpanded: true,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(left: 13, right: 13),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              items: getDropDownMenuItems("per ", unitList),
                              value: currentAmountUnit,
                              onChanged: changedDropDownAmountUnit,
                              validator: (value) {
                                if (currentAmountUnit == null) {
                                  return ('Select Unit');
                                } else {
                                  return null;
                                }
                              },
                            ),
                          )
                        ],
                      )
                    : Offstage(),
                !fixedPrice
                    ? Padding(
                        padding: EdgeInsets.only(top: cHeight * 0.03),
                        child: Text(
                          MyLocalizations.of(context)
                              .word("minQuantity", "   Minimum Quantity"),
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: textColor,
                          ),
                        ),
                      )
                    : Offstage(),
                !fixedPrice
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: cWidth * 0.5,
                            child: TextFormField(
                              // isExpanded: true,
                              keyboardType: TextInputType.number,
                              controller: minQuantityController,
                              decoration: InputDecoration(
                                contentPadding: dropdownPadding,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (value) {
                                if (!fixedPrice && value.length == 0) {
                                  return ('Enter Min Qunatity');
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Container(
                            width: cWidth * 0.35,
                            child: DropdownButtonFormField(
                              // isExpanded: true,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(left: 13, right: 13),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              items: getDropDownMenuItems(null, unitList),
                              value: currentMinimumUnit,
                              onChanged: changedDropDownMinimumUnit,
                              validator: (value) {
                                if (currentQuality == null) {
                                  return ('Select Unit');
                                } else {
                                  return null;
                                }
                              },
                            ),
                          )
                        ],
                      )
                    : Offstage(),
                !fixedPrice
                    ? Padding(
                        padding: EdgeInsets.only(top: cHeight * 0.03),
                        child: Text(
                          MyLocalizations.of(context)
                              .word("minimumAmount", "   Minimum Amount"),
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: textColor,
                          ),
                        ),
                      )
                    : Offstage(),
                !fixedPrice
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: cWidth * 0.5,
                            child: TextFormField(
                              // isExpanded: true,
                              keyboardType: TextInputType.number,
                              controller: minAmountController,
                              decoration: InputDecoration(
                                prefixText: "Rs. ",
                                contentPadding: dropdownPadding,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (value) {
                                if (!fixedPrice && value.length == 0) {
                                  return ('Enter Min Amount');
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Container(
                            width: cWidth * 0.35,
                            child: DropdownButtonFormField(
                              // isExpanded: true,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(left: 13, right: 13),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              items: getDropDownMenuItems(null, unitList),
                              value: unitForMinimumAmount,
                              onChanged: changedDropDownUnitForMinimumAmount,
                              validator: (value) {
                                if (unitForMinimumAmount == null) {
                                  return ('Select Unit');
                                } else {
                                  return null;
                                }
                              },
                            ),
                          )
                        ],
                      )
                    : Offstage(),
                Padding(
                  padding: EdgeInsets.only(top: cHeight * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              // getMultipleImagesGallery();
                              getImageGallery().then((val) {
                                if (val != null) {
                                  setState(() {
                                    imageFile = val["imageFile"];
                                    imageName = val["imageName"];
                                    imageFormat = val["imageFormat"];
                                    imageBytes = imageFile.readAsBytesSync();
                                    base64Image = base64Encode(imageBytes);
                                    imagesList.add(UploadImage(
                                      image: base64Image,
                                      mimeTypeId: "image/$imageFormat",
                                      fileName: imageName,
                                    ));
                                    imagesFileList.add(imageFile);
                                  });
                                }
                              });
                            },
                            child: CircleAvatar(
                              // backgroundImage: imageFile != null
                              //     ? FileImage(imageFile)
                              //     : null,
                              child: Icon(Icons.add_a_photo),
                            ),
                          ),
                          Text(
                            MyLocalizations.of(context)
                                .word("addImage", "Add Image"),
                            style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      // Column(
                      //   children: <Widget>[
                      //     GestureDetector(
                      //       onTap: () {
                      //         // getVideoGallery();
                      //         // getVideoGallery().then((val) {
                      //         //   if (val != null) {
                      //         //     setState(() {s
                      //         //       videoFile = val["videoFile"];
                      //         //       videoName = val["videoName"];
                      //         //       videoFormat = val["videoFormat"];
                      //         //       videoBytes = videoFile.readAsBytesSync();
                      //         //       base64Video = base64Encode(videoBytes);
                      //         //       print(base64Video);
                      //         //       videosList.add(UploadVideo(
                      //         //         video: base64Video,
                      //         //         mimeTypeId: "video/$videoFormat",
                      //         //         fileName: videoName,
                      //         //       ));
                      //         //       videosFileList.add(videoFile);
                      //         //     });
                      //         //   }
                      //         // });
                      //       },
                      //       child: CircleAvatar(
                      //         child: Icon(Icons.ondemand_video),
                      //       ),
                      //     ),
                      //     Text(
                      //       "Add Video",
                      //       style: TextStyle(
                      //         // fontWeight: FontWeight.bold,
                      //         fontSize: 12,
                      //         color: textColor,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // Column(
                      //   children: <Widget>[
                      //     CircleAvatar(
                      //       child: Icon(Icons.settings_voice),
                      //     ),
                      //     Text(
                      //       "Add Voice Note",
                      //       style: TextStyle(
                      //         // fontWeight: FontWeight.bold,
                      //         fontSize: 12,
                      //         color: textColor,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: cHeight * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:
                          List.generate(imagesFileList.length, (int index) {
                        return Stack(
                          children: <Widget>[
                            Padding(
                              padding: index == 0
                                  ? EdgeInsets.all(0)
                                  : EdgeInsets.only(left: 4),
                              child: CircleAvatar(
                                backgroundColor: Colors.black12,
                                radius: 20,
                                backgroundImage:
                                    FileImage(imagesFileList[index]),
                              ),
                            ),
                            Positioned(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    imagesFileList.removeAt(index);
                                    imagesList.removeAt(index);
                                  });
                                },
                                child: Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                              ),
                              top: 0,
                              left: 20,
                            )
                          ],
                        );
                      }),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: cHeight * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:
                          List.generate(videosFileList.length, (int index) {
                        return Stack(
                          children: <Widget>[
                            Padding(
                              padding: index == 0
                                  ? EdgeInsets.all(0)
                                  : EdgeInsets.only(left: 4),
                              child: CircleAvatar(
                                backgroundColor: Colors.black12,
                                radius: 20,
                                // backgroundImage:
                                //     FileImage(videosFileList[index]),
                              ),
                            ),
                            Positioned(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    videosFileList.removeAt(index);
                                    videosList.removeAt(index);
                                  });
                                },
                                child: Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                              ),
                              top: 0,
                              left: 20,
                            )
                          ],
                        );
                      }),
                    )),
                Padding(
                  padding: EdgeInsets.only(top: cHeight * 0.03),
                  child: Text(
                    MyLocalizations.of(context).word(
                        "additionalInformation", "   Additional Information"),
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: textColor,
                    ),
                  ),
                ),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(13),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  // validator: (value) {
                  //   if (value.length == 0) {
                  //     return ('Enter information');
                  //   } else {
                  //     return null;
                  //   }
                  // },
                ),
                Padding(
                  padding: EdgeInsets.only(top: cHeight * 0.03),
                  child: Text(
                    "   Date from which product can be sold",
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: textColor,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    selectDateFromPicker(context, dateSelected).then((val) {
                      print(val);
                      setState(() {
                        dateSelected = val;
                        dateController.text =
                            DateFormat('dd-MM-yyyy').format(dateSelected);
                      });
                    });
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: dateController,
                      decoration: InputDecoration(
                        contentPadding: dropdownPadding,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      validator: (value) {
                        if (value.length == 0) {
                          return ('Enter date');
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ),
                Center(
                  child: RaisedButton(
                    child: Text(
                      MyLocalizations.of(context).word("next", "Next"),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: titleColor,
                    onPressed: () {
                      _validate2();
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Expanded stepThree() {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.only(
        left: cWidth * 0.01,
        right: cWidth * 0.01,
      ),
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: cHeight * 0.13,
                        width: cWidth * 0.3,
                        color: Colors.grey,
                        child: imageFile != null
                            ? Image.file(
                                imageFile,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.image),
                      ),
                      Container(
                        width: cWidth * 0.6,
                        // color: Colors.grey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  MyLocalizations.of(context).word(
                                          "primaryCategories",
                                          "Primary Categories") +
                                      ":",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: textColor,
                                  ),
                                ),
                                Text(
                                  " $currentPrimaryCategory",
                                  style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: cHeight * 0.01),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    MyLocalizations.of(context)
                                            .word("categories", "Category") +
                                        ":",
                                    style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: textColor,
                                    ),
                                  ),
                                  Text(
                                    " $currentCategory",
                                    style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            currentCrop != null
                                ? Padding(
                                    padding:
                                        EdgeInsets.only(top: cHeight * 0.01),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          MyLocalizations.of(context).word(
                                                  "cropName", "Crop Name") +
                                              ":",
                                          style: TextStyle(
                                            // fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: textColor,
                                          ),
                                        ),
                                        Text(
                                          " $currentCrop",
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
                              padding: EdgeInsets.only(top: cHeight * 0.01),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    MyLocalizations.of(context)
                                            .word("variety", "Variety") +
                                        ":",
                                    style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: textColor,
                                    ),
                                  ),
                                  Text(
                                    " $currentVariety",
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
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: cHeight * 0.01),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          MyLocalizations.of(context)
                                  .word("quality", "Quality") +
                              ":",
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: textColor,
                          ),
                        ),
                        Text(
                          " $currentQuality",
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: cHeight * 0.01),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          MyLocalizations.of(context)
                                  .word("quantity", "Quantity") +
                              ":",
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: textColor,
                          ),
                        ),
                        Text(
                          " ${quantityController.text} $currentUnit",
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  !fixedPrice
                      ? Padding(
                          padding: EdgeInsets.only(top: cHeight * 0.01),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Minimum Qunatity :",
                                style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                " ${minQuantityController.text} $currentUnit",
                                style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Offstage(),
                  !fixedPrice
                      ? Padding(
                          padding: EdgeInsets.only(top: cHeight * 0.01),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Minimum Amount :",
                                style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                " Rs. ${minAmountController.text} per $unitForMinimumAmount",
                                style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Offstage(),
                  fixedPrice
                      ? Padding(
                          padding: EdgeInsets.only(top: cHeight * 0.01),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                MyLocalizations.of(context)
                                        .word("fixedPrice", "Fixed Price") +
                                    ":",
                                style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                " Rs.${amountController.text}/ $currentAmountUnit",
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
                    padding: EdgeInsets.only(top: cHeight * 0.01),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
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
                          "${descriptionController.text}",
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: cHeight * 0.01),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          MyLocalizations.of(context)
                                  .word("availableFrom", "Available from") +
                              ":",
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: textColor,
                          ),
                        ),
                        Text(
                          " ${dateController.text}",
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: cHeight * 0.02),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "I will deliver goods directly to the customer",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                        Checkbox(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            value: deliverGoods,
                            onChanged: (change) {
                              setState(() {
                                deliverGoods = change;
                              });
                            })
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: cHeight * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Text(
                    MyLocalizations.of(context).word("edit", "Edit"),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.deepOrange,
                  onPressed: uploading
                      ? null
                      : () {
                          setState(() {
                            stepNum = 2;
                          });
                        },
                ),
                RaisedButton(
                  child: Text(
                    "Post",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: textColor,
                  // onPressed: () {
                  //   // print(cropData.categories[cropIndex].productCategoryId);
                  //   print(categoryData
                  //       .categories[categoryIndex].productCategoryId);
                  // },
                  onPressed: uploading
                      ? null
                      : () {
                          postAd();
                        },
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }

  void _validate1() {
    if (_formKey1.currentState.validate()) {
      _formKey1.currentState.save();
      setState(() {
        stepNum = 2;
      });
    }
  }

  void _validate2() {
    if (_formKey2.currentState.validate()) {
      _formKey2.currentState.save();
      setState(() {
        stepNum = 3;
      });
    }
  }

  void postAd() {
    setState(() {
      uploading = true;
    });
    print("##${DateTime.now().toUtc()}##");
    if (imagesList.length == 0) {
      setState(() {
        imageFile = null;
      });
    }
    if (videosList.length == 0) {
      setState(() {
        videoFile = null;
      });
    }
    PostAdModel adModel1 = PostAdModel(
        uploadImage: imageFile != null ? imagesList : [],
        uploadVideo: videoFile != null ? UploadVideo() : null,
        reqData: ReqData(
            closedDateTime: dateSelected.toUtc(),
            description: descriptionController.text,
            partyId: widget.userId,
            productId: varietyData.productMembersList[varietyIndex].productId,
            quantity: quantityController.text,
            minimumQuantity: minQuantityController.text,
            minimumAmount: minAmountController.text,
            fixedProduct: "N",
            quality: qualityIdList[qualityIndex],
            organicCertificateNumber: certificateController.text,
            adType: "SELL",
            unit: unitIdList[unitIndex],
            unitForFxiedPrice: unitIdList[amountUnitIndex],
            minimumUnit: unitIdList[minimumUnitIndex],
            unitForMinimumAmount: unitIdList[unitForMinimumAmountIndex],
            country: country,
            block: block,
            district: district,
            latitude: latitude,
            longitude: longitude,
            state: state,
            tehsil: tehsil,
            village: village,
            custRequestCategoryId: currentCategory != null &&
                    categoryData != null &&
                    categoryData.categories[categoryIndex].showChildCategory ==
                        "Y"
                ? cropData.categories[cropIndex].productCategoryId
                : categoryData.categories[categoryIndex].productCategoryId));
    PostAdModelFixed adModel2 = PostAdModelFixed(
        uploadImage: imageFile != null ? imagesList : [],
        uploadVideo: videoFile != null ? UploadVideo() : null,
        reqData: ReqDataFixed(
          closedDateTime: dateSelected.toUtc(),
          description: descriptionController.text,
          partyId: widget.userId,
          productId: varietyData.productMembersList[varietyIndex].productId,
          quantity: quantityController.text,
          // minimumQuantity:minQuantityController.text,
          // minimumAmount:minAmountController.text,
          amount: amountController.text,
          fixedProduct: "Y",
          quality: qualityIdList[qualityIndex],
          organicCertificateNumber: certificateController.text,
          adType: "SELL",
          unit: unitIdList[unitIndex],
          unitForFxiedPrice: unitIdList[amountUnitIndex],

          country: country,
          block: block,
          district: district,
          latitude: latitude,
          longitude: longitude,
          state: state,
          tehsil: tehsil,
          village: village,
        ));
    var body = !fixedPrice ? adModel1 : adModel2;
    _apiBase
        .post(context, "/api/addProductToSell", null, body, widget.userToken)
        .then((val) {
      setState(() {
        uploading = false;
      });
      print(json.encode(body));
      if (val.statusCode == 200) {
        print("##${val.body}##");
        // _scaffoldKey.currentState
        //     .showSnackBar(new SnackBar(content: new Text("Ad Posted")));
        widget.navigateMyAds();
        // Fluttertoast.showToast(
        //   msg: "Ad Posted",
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.BOTTOM,
        // );
      }
    });
  }
}
