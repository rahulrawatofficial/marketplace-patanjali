import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';
import 'package:marketplace_patanjali/LanguageSetup/localizations.dart';
import 'package:marketplace_patanjali/Models/category_model.dart';
import 'package:marketplace_patanjali/Models/primary_category_model.dart';
import 'package:marketplace_patanjali/Models/variety_model.dart';
import 'package:marketplace_patanjali/resources/http_requests.dart';
import 'package:marketplace_patanjali/ui/Widgets/location_screen.dart';

class FilterScreen extends StatefulWidget {
  final void Function(String, String, String, Coordinates) applyFilter;
  final String userId;
  final String userToken;
  final String userName;
  final String userPhoneNum;

  const FilterScreen(
      {Key key,
      this.userId,
      this.userToken,
      this.userName,
      this.userPhoneNum,
      this.applyFilter})
      : super(key: key);
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String title = "Annadata MarketPlace";
  Color titleColor = Color(0xFF009D37);
  Color textColor = Color(0xFF0047C4);
  Color barColor = Colors.white;

  String location = "Location";

  ApiBase _apiBase = ApiBase();

  PrimaryCategoryModel primaryCategoryData;
  List primaryCategoryList = [];

  List<bool> primaryCategoryCheckList = [];
  String currentPrimaryCategory;
  int primaryIndex = 0;

  CategoryModel categoryData;
  List categoryList = [];

  List<bool> categoryCheckList = [];
  String currentCategory;
  int categoryIndex = 0;

  CategoryModel cropData;
  List cropList = [];

  List<bool> cropCheckList = [];
  String currentCrop;
  int cropIndex = 0;

  VarietyModel varietyData;
  List varietyList = [];

  List<bool> varietyCheckList = [];
  String currentVariety;
  int varietyIndex = 0;

  bool buy = false;

  String locationAddress;
  Coordinates coordinates;

  //tile height
  double tileHeight(int count) {
    double val = double.parse("0.$count") * 0.8;
    return cHeight * val;
  }

  //Change Dropdowns
  void changedDropDownPrimaryCat(String selectedPrimaryCategory) {
    primaryIndex = primaryCategoryList.indexOf(selectedPrimaryCategory);
    categoryIndex = 0;
    varietyIndex = 0;
    categoryList.clear();
    varietyList.clear();
    cropList.clear();
    currentCrop = null;
    currentCategory = null;
    currentVariety = null;
    setState(() {
      currentPrimaryCategory = selectedPrimaryCategory;
    });
    var param = {"primaryParentCategoryId": currentPrimaryCategory};
    _apiBase
        .get(context, "/api/getRelatedCategoryList", param, widget.userToken)
        .then((val) {
      if (val.statusCode == 200) {
        setState(() {
          categoryData = categoryModelFromJson(val.body);
          for (int i = 0; i < categoryData.categories.length; i++) {
            categoryList.add(categoryData.categories[i].productCategoryId);
          }
        });
        print(categoryList);
      }
    });
  }

  clearAll() {
    setState(() {
      primaryIndex = 0;
      primaryCategoryCheckList.clear();
      categoryIndex = 0;
      varietyIndex = 0;
      categoryList.clear();
      cropList.clear();
      varietyList.clear();
      categoryCheckList.clear();
      cropCheckList.clear();
      varietyCheckList.clear();
      currentCrop = null;
      currentCategory = null;
      currentVariety = null;
      currentPrimaryCategory = null;
      locationAddress = null;
      coordinates = null;
    });
  }

  clearPrimary() {
    setState(() {
      categoryIndex = 0;
      varietyIndex = 0;
      categoryList.clear();
      cropList.clear();
      varietyList.clear();
      categoryCheckList.clear();
      cropCheckList.clear();
      varietyCheckList.clear();
      currentCrop = null;
      currentCategory = null;
      currentVariety = null;
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
      currentCategory = selectedCategory;
    });
    if (categoryData.categories[categoryIndex].showChildCategory == "Y") {
      var param = {"topCategory": currentCategory};
      _apiBase
          .get(context, "/api/getAllCategories", param, widget.userToken)
          .then((val) {
        if (val.statusCode == 200) {
          setState(() {
            cropData = categoryModelFromJson(val.body);
            for (int i = 0; i < cropData.categories.length; i++) {
              cropList.add(cropData.categories[i].productCategoryId);
            }
          });
          print(varietyList);
        }
      });
    } else {
      var param = {"productCategoryId": currentCategory};
      _apiBase
          .get(context, "/api/getProductCategoryMembers", param,
              widget.userToken)
          .then((val) {
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

  clearCategory() {
    setState(() {
      varietyIndex = 0;
      cropList.clear();
      cropCheckList.clear();
      currentCrop = null;
      varietyList.clear();
      varietyCheckList.clear();
      currentVariety = null;
    });
  }

  void changedDropDownCrop(String selectedCrop) {
    varietyList.clear();
    currentVariety = null;
    varietyIndex = 0;
    cropIndex = cropList.indexOf(selectedCrop);
    setState(() {
      currentCrop = selectedCrop;
    });
    var param = {"productCategoryId": currentCrop};
    _apiBase
        .get(context, "/api/getProductCategoryMembers", param, widget.userToken)
        .then((val) {
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

  clearCrop() {
    setState(() {
      varietyList.clear();
      varietyCheckList.clear();
      currentVariety = null;
      varietyIndex = 0;
    });
  }

  void changedDropDownVariety(String selectedVariety) {
    varietyIndex = varietyList.indexOf(selectedVariety);
    print(varietyIndex);
    setState(() {
      currentVariety = selectedVariety;
    });
  }

  @override
  void initState() {
    _apiBase
        .get(context, "/api/getParentCategoryList", null, widget.userToken)
        .then((val) {
      if (val.statusCode == 200) {
        setState(() {
          primaryCategoryData = primaryCategoryModelFromJson(val.body);
          for (int i = 0;
              i < primaryCategoryData.prodCatalogCategoryList.length;
              i++) {
            primaryCategoryList.add(primaryCategoryData
                .prodCatalogCategoryList[i].productCategoryId);
          }
        });
      }
    });
    super.initState();
  }

  Future onLoationChange(LatLng loc) async {
    print("object");
    coordinates = new Coordinates(loc.latitude, loc.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    Address first = addresses.first;
    setState(() {
      locationAddress = first.addressLine;
      // latitude = loc.latitude.toString();
      // longitude = loc.longitude.toString();
      // country = first.countryName;
      // state = first.adminArea;
      // district = first.subAdminArea;
      // tehsil = first.subLocality;
      // block = first.thoroughfare;
      // village = first.subThoroughfare;
    });
    // print("${first.featureName} : ${first.addressLine}");
    // return first;
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  color: Colors.black,
                  size: 18,
                ),
                Text(
                  MyLocalizations.of(context).word("location", "location"),
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          //Screen
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Filter",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF0047C4), fontSize: 22),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: cHeight * 0.01, bottom: cHeight * 0.03),
            // child: Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: <Widget>[
            //     GestureDetector(
            //       onTap: () {
            //         setState(() {
            //           buy = true;
            //         });
            //       },
            //       child: Container(
            //         width: cWidth * 0.3,
            //         height: cHeight * 0.05,
            //         child: Center(
            //             child: Text(
            //           "Buy",
            //           style: TextStyle(
            //             color: buy == false ? Colors.black : Colors.white,
            //           ),
            //         )),
            //         decoration: BoxDecoration(
            //           color: buy == false ? Colors.white : Colors.blue[900],
            //           borderRadius: BorderRadius.circular(10),
            //           border: Border.all(),
            //         ),
            //       ),
            //     ),
            //     GestureDetector(
            //       onTap: () {
            //         setState(() {
            //           buy = false;
            //         });
            //       },
            //       child: Container(
            //         width: cWidth * 0.3,
            //         height: cHeight * 0.05,
            //         child: Center(
            //             child: Text(
            //           "Sell",
            //           style: TextStyle(
            //             color: buy ? Colors.black : Colors.white,
            //           ),
            //         )),
            //         decoration: BoxDecoration(
            //           color: buy ? Colors.white : Colors.blue[900],
            //           borderRadius: BorderRadius.circular(10),
            //           border: Border.all(),
            //         ),
            //       ),
            //     )
            //   ],
            // ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: cWidth * 0.05,
                right: cWidth * 0.05,
                bottom: cHeight * 0.01),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SelectLocation(
                          onLocationChange: onLoationChange,
                        )));
              },
              child: Container(
                color: Colors.grey[200],
                child: Padding(
                  padding: EdgeInsets.only(
                    left: cWidth * 0.05,
                    right: cWidth * 0.05,
                    top: cHeight * 0.01,
                    bottom: cHeight * 0.01,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            MyLocalizations.of(context)
                                .word("location", "Location"),
                            style: TextStyle(fontSize: 16),
                          ),
                          Icon(
                            Icons.gps_fixed,
                            color: locationAddress != null
                                ? Colors.blue
                                : Colors.grey,
                          )
                        ],
                      ),
                      locationAddress != null
                          ? Text(
                              "$locationAddress",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey),
                            )
                          : Offstage(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: cWidth * 0.05, right: cWidth * 0.05),
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.grey[200],
                  child: ExpansionTile(
                    title: Text(
                      MyLocalizations.of(context)
                          .word("primaryCategories", " Primary Category"),
                    ),
                    children: <Widget>[
                      Container(
                        height: tileHeight(primaryCategoryList.length),
                        child: ListView(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: cWidth * 0.05, right: cWidth * 0.05),
                              child: Column(
                                children: List.generate(
                                    primaryCategoryList.length, (index) {
                                  if (primaryCategoryCheckList.length <
                                      primaryCategoryList.length) {
                                    primaryCategoryCheckList.add(false);
                                  }
                                  print(primaryCategoryCheckList);
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(primaryCategoryList[index]),
                                      Checkbox(
                                        value: primaryCategoryCheckList[index],
                                        onChanged: (change) {
                                          change
                                              ? changedDropDownPrimaryCat(
                                                  primaryCategoryList[index])
                                              : clearPrimary();
                                          setState(() {
                                            for (int i = 0;
                                                i <
                                                    primaryCategoryCheckList
                                                        .length;
                                                i++) {
                                              primaryCategoryCheckList[i] =
                                                  false;
                                            }
                                            primaryCategoryCheckList[index] =
                                                change;
                                          });
                                        },
                                      )
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.grey[200],
                  child: ExpansionTile(
                    title: Text(
                      MyLocalizations.of(context).word("category", "Category"),
                    ),
                    children: <Widget>[
                      Container(
                        height: tileHeight(categoryList.length),
                        child: ListView(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: cWidth * 0.05, right: cWidth * 0.05),
                              child: Column(
                                children:
                                    List.generate(categoryList.length, (index) {
                                  if (categoryCheckList.length <
                                      categoryList.length) {
                                    categoryCheckList.add(false);
                                  }
                                  print(categoryCheckList);
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(categoryList[index]),
                                      Checkbox(
                                        value: categoryCheckList[index],
                                        onChanged: (change) {
                                          change
                                              ? changedDropDownCat(
                                                  categoryList[index])
                                              : clearCategory();
                                          setState(() {
                                            for (int i = 0;
                                                i < categoryCheckList.length;
                                                i++) {
                                              categoryCheckList[i] = false;
                                            }
                                            categoryCheckList[index] = change;
                                          });
                                        },
                                      )
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                currentCategory != null &&
                        categoryData != null &&
                        categoryData
                                .categories[categoryIndex].showChildCategory ==
                            "Y"
                    ? Container(
                        color: Colors.grey[200],
                        child: ExpansionTile(
                          title: Text(
                            MyLocalizations.of(context)
                                .word("category", "Category"),
                          ),
                          children: <Widget>[
                            Container(
                              height: tileHeight(cropList.length),
                              child: ListView(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: cWidth * 0.05,
                                        right: cWidth * 0.05),
                                    child: Column(
                                      children: List.generate(cropList.length,
                                          (index) {
                                        if (cropCheckList.length <
                                            cropList.length) {
                                          cropCheckList.add(false);
                                        }
                                        print(cropCheckList);
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(cropList[index]),
                                            Checkbox(
                                              value: cropCheckList[index],
                                              onChanged: (change) {
                                                change
                                                    ? changedDropDownCrop(
                                                        cropList[index])
                                                    : clearCrop();
                                                setState(() {
                                                  for (int i = 0;
                                                      i < cropCheckList.length;
                                                      i++) {
                                                    cropCheckList[i] = false;
                                                  }
                                                  cropCheckList[index] = change;
                                                });
                                              },
                                            )
                                          ],
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    : Offstage(),
                Container(
                  color: Colors.grey[200],
                  child: ExpansionTile(
                    title: Text(
                      MyLocalizations.of(context).word("variety", "Variety"),
                    ),
                    children: <Widget>[
                      Container(
                        height: tileHeight(varietyList.length),
                        child: ListView(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: cWidth * 0.05, right: cWidth * 0.05),
                              child: Column(
                                children:
                                    List.generate(varietyList.length, (index) {
                                  if (varietyCheckList.length <
                                      varietyList.length) {
                                    varietyCheckList.add(false);
                                  }
                                  print(varietyCheckList);
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(varietyList[index]),
                                      Checkbox(
                                        value: varietyCheckList[index],
                                        onChanged: (change) {
                                          change
                                              ? changedDropDownVariety(
                                                  varietyList[index])
                                              : {};
                                          setState(() {
                                            for (int i = 0;
                                                i < varietyCheckList.length;
                                                i++) {
                                              varietyCheckList[i] = false;
                                            }
                                            varietyCheckList[index] = change;
                                          });
                                        },
                                      )
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // Container(
                //   color: Colors.grey[200],
                //   child: ExpansionTile(
                //     title: Text("Category"),
                //     children: <Widget>[
                //       Container(
                //         height: cHeight * 0.3,
                //         child: ListView(
                //           children: <Widget>[
                //             Padding(
                //               padding: EdgeInsets.only(
                //                   left: cWidth * 0.05, right: cWidth * 0.05),
                //               child: Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: <Widget>[
                //                   Text("data1"),
                //                   Checkbox(
                //                     value: true,
                //                     onChanged: (change) {},
                //                   )
                //                 ],
                //               ),
                //             ),
                //             Padding(
                //               padding: EdgeInsets.only(
                //                   left: cWidth * 0.05, right: cWidth * 0.05),
                //               child: Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: <Widget>[
                //                   Text("data1"),
                //                   Checkbox(
                //                     value: true,
                //                     onChanged: (change) {},
                //                   )
                //                 ],
                //               ),
                //             ),
                //             Padding(
                //               padding: EdgeInsets.only(
                //                   left: cWidth * 0.05, right: cWidth * 0.05),
                //               child: Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: <Widget>[
                //                   Text("data1"),
                //                   Checkbox(
                //                     value: true,
                //                     onChanged: (change) {},
                //                   )
                //                 ],
                //               ),
                //             ),
                //             Padding(
                //               padding: EdgeInsets.only(
                //                   left: cWidth * 0.05, right: cWidth * 0.05),
                //               child: Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: <Widget>[
                //                   Text("data1"),
                //                   Checkbox(
                //                     value: true,
                //                     onChanged: (change) {},
                //                   )
                //                 ],
                //               ),
                //             ),
                //           ],
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                // Container(
                //   color: Colors.grey[200],
                //   child: ExpansionTile(
                //     title: Text("Quality"),
                //     children: <Widget>[
                //       Container(
                //         height: cHeight * 0.3,
                //         child: ListView(
                //           children: <Widget>[
                //             Padding(
                //               padding: EdgeInsets.only(
                //                   left: cWidth * 0.05, right: cWidth * 0.05),
                //               child: Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: <Widget>[
                //                   Text("data1"),
                //                   Checkbox(
                //                     value: true,
                //                     onChanged: (change) {},
                //                   )
                //                 ],
                //               ),
                //             ),
                //             Padding(
                //               padding: EdgeInsets.only(
                //                   left: cWidth * 0.05, right: cWidth * 0.05),
                //               child: Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: <Widget>[
                //                   Text("data1"),
                //                   Checkbox(
                //                     value: true,
                //                     onChanged: (change) {},
                //                   )
                //                 ],
                //               ),
                //             ),
                //             Padding(
                //               padding: EdgeInsets.only(
                //                   left: cWidth * 0.05, right: cWidth * 0.05),
                //               child: Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: <Widget>[
                //                   Text("data1"),
                //                   Checkbox(
                //                     value: true,
                //                     onChanged: (change) {},
                //                   )
                //                 ],
                //               ),
                //             ),
                //             Padding(
                //               padding: EdgeInsets.only(
                //                   left: cWidth * 0.05, right: cWidth * 0.05),
                //               child: Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: <Widget>[
                //                   Text("data1"),
                //                   Checkbox(
                //                     value: true,
                //                     onChanged: (change) {},
                //                   )
                //                 ],
                //               ),
                //             ),
                //           ],
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                // Container(
                //   color: Colors.grey[200],
                //   child: ExpansionTile(
                //     title: Text("Price"),
                //     children: <Widget>[
                //       Container(
                //         height: cHeight * 0.3,
                //         child: ListView(
                //           children: <Widget>[
                //             Padding(
                //               padding: EdgeInsets.only(
                //                   left: cWidth * 0.05, right: cWidth * 0.05),
                //               child: Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: <Widget>[
                //                   Text("data1"),
                //                   Checkbox(
                //                     value: true,
                //                     onChanged: (change) {},
                //                   )
                //                 ],
                //               ),
                //             ),
                //             Padding(
                //               padding: EdgeInsets.only(
                //                   left: cWidth * 0.05, right: cWidth * 0.05),
                //               child: Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: <Widget>[
                //                   Text("data1"),
                //                   Checkbox(
                //                     value: true,
                //                     onChanged: (change) {},
                //                   )
                //                 ],
                //               ),
                //             ),
                //             Padding(
                //               padding: EdgeInsets.only(
                //                   left: cWidth * 0.05, right: cWidth * 0.05),
                //               child: Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: <Widget>[
                //                   Text("data1"),
                //                   Checkbox(
                //                     value: true,
                //                     onChanged: (change) {},
                //                   )
                //                 ],
                //               ),
                //             ),
                //             Padding(
                //               padding: EdgeInsets.only(
                //                   left: cWidth * 0.05, right: cWidth * 0.05),
                //               child: Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: <Widget>[
                //                   Text("data1"),
                //                   Checkbox(
                //                     value: true,
                //                     onChanged: (change) {},
                //                   )
                //                 ],
                //               ),
                //             ),
                //           ],
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                // Container(
                //   color: Colors.grey[200],
                //   child: ExpansionTile(
                //     title: Text("Country"),
                //     children: <Widget>[
                //       Container(
                //         height: cHeight * 0.3,
                //         child: ListView(
                //           children: <Widget>[
                //             Padding(
                //               padding: EdgeInsets.only(
                //                   left: cWidth * 0.05, right: cWidth * 0.05),
                //               child: Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: <Widget>[
                //                   Text("data1"),
                //                   Checkbox(
                //                     value: true,
                //                     onChanged: (change) {},
                //                   )
                //                 ],
                //               ),
                //             ),
                //             Padding(
                //               padding: EdgeInsets.only(
                //                   left: cWidth * 0.05, right: cWidth * 0.05),
                //               child: Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: <Widget>[
                //                   Text("data1"),
                //                   Checkbox(
                //                     value: true,
                //                     onChanged: (change) {},
                //                   )
                //                 ],
                //               ),
                //             ),
                //             Padding(
                //               padding: EdgeInsets.only(
                //                   left: cWidth * 0.05, right: cWidth * 0.05),
                //               child: Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: <Widget>[
                //                   Text("data1"),
                //                   Checkbox(
                //                     value: true,
                //                     onChanged: (change) {},
                //                   )
                //                 ],
                //               ),
                //             ),
                //             Padding(
                //               padding: EdgeInsets.only(
                //                   left: cWidth * 0.05, right: cWidth * 0.05),
                //               child: Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: <Widget>[
                //                   Text("data1"),
                //                   Checkbox(
                //                     value: true,
                //                     onChanged: (change) {},
                //                   )
                //                 ],
                //               ),
                //             ),
                //           ],
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                // Container(
                //   color: Colors.grey[200],
                //   child: ExpansionTile(
                //     title: Text("State"),
                //     children: <Widget>[
                //       Container(
                //         height: cHeight * 0.3,
                //         child: ListView(
                //           children: <Widget>[
                //             Padding(
                //               padding: EdgeInsets.only(
                //                   left: cWidth * 0.05, right: cWidth * 0.05),
                //               child: Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: <Widget>[
                //                   Text("data1"),
                //                   Checkbox(
                //                     value: true,
                //                     onChanged: (change) {},
                //                   )
                //                 ],
                //               ),
                //             ),
                //             Padding(
                //               padding: EdgeInsets.only(
                //                   left: cWidth * 0.05, right: cWidth * 0.05),
                //               child: Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: <Widget>[
                //                   Text("data1"),
                //                   Checkbox(
                //                     value: true,
                //                     onChanged: (change) {},
                //                   )
                //                 ],
                //               ),
                //             ),
                //             Padding(
                //               padding: EdgeInsets.only(
                //                   left: cWidth * 0.05, right: cWidth * 0.05),
                //               child: Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: <Widget>[
                //                   Text("data1"),
                //                   Checkbox(
                //                     value: true,
                //                     onChanged: (change) {},
                //                   )
                //                 ],
                //               ),
                //             ),
                //             Padding(
                //               padding: EdgeInsets.only(
                //                   left: cWidth * 0.05, right: cWidth * 0.05),
                //               child: Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: <Widget>[
                //                   Text("data1"),
                //                   Checkbox(
                //                     value: true,
                //                     onChanged: (change) {},
                //                   )
                //                 ],
                //               ),
                //             ),
                //           ],
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                // Container(
                //   color: Colors.grey[200],
                //   child: ExpansionTile(
                //     title: Text("City"),
                //     children: <Widget>[
                //       Container(
                //         height: cHeight * 0.3,
                //         child: ListView(
                //           children: <Widget>[
                //             Padding(
                //               padding: EdgeInsets.only(
                //                   left: cWidth * 0.05, right: cWidth * 0.05),
                //               child: Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: <Widget>[
                //                   Text("data1"),
                //                   Checkbox(
                //                     value: true,
                //                     onChanged: (change) {},
                //                   )
                //                 ],
                //               ),
                //             ),
                //             Padding(
                //               padding: EdgeInsets.only(
                //                   left: cWidth * 0.05, right: cWidth * 0.05),
                //               child: Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: <Widget>[
                //                   Text("data1"),
                //                   Checkbox(
                //                     value: true,
                //                     onChanged: (change) {},
                //                   )
                //                 ],
                //               ),
                //             ),
                //             Padding(
                //               padding: EdgeInsets.only(
                //                   left: cWidth * 0.05, right: cWidth * 0.05),
                //               child: Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: <Widget>[
                //                   Text("data1"),
                //                   Checkbox(
                //                     value: true,
                //                     onChanged: (change) {},
                //                   )
                //                 ],
                //               ),
                //             ),
                //             Padding(
                //               padding: EdgeInsets.only(
                //                   left: cWidth * 0.05, right: cWidth * 0.05),
                //               child: Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: <Widget>[
                //                   Text("data1"),
                //                   Checkbox(
                //                     value: true,
                //                     onChanged: (change) {},
                //                   )
                //                 ],
                //               ),
                //             ),
                //           ],
                //         ),
                //       )
                //     ],
                //   ),
                // ),
              ],
            ),
          ),

          Padding(
            padding:
                EdgeInsets.only(top: cHeight * 0.03, bottom: cHeight * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                    onPressed: () {
                      String pId;
                      String catId;
                      String varId;
                      pId = currentPrimaryCategory != null
                          ? primaryCategoryData
                              .prodCatalogCategoryList[primaryIndex]
                              .productCategoryId
                          : null;
                      catId = currentCrop != null
                          ? cropData.categories[categoryIndex].productCategoryId
                          : currentCategory != null
                              ? categoryData
                                  .categories[categoryIndex].productCategoryId
                              : null;
                      varId = currentVariety != null
                          ? varietyData
                              .productMembersList[varietyIndex].productId
                          : null;
                      widget.applyFilter(pId, catId, varId, coordinates);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Apply",
                      style: TextStyle(
                        color: Color(0xFF0047C4),
                      ),
                    )),
                FlatButton(
                    onPressed: () {
                      clearAll();
                    },
                    child: Text(
                      "Reset",
                      style: TextStyle(
                        color: Color(0xFF0047C4),
                      ),
                    )),
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Close",
                      style: TextStyle(
                        color: Color(0xFF0047C4),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
