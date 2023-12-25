import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';
import 'package:marketplace_patanjali/LanguageSetup/localizations.dart';
import 'package:marketplace_patanjali/Models/LocationModel/block_model.dart';
import 'package:marketplace_patanjali/Models/LocationModel/tehsil_model.dart';
import 'package:marketplace_patanjali/Models/LocationModel/village_model.dart';
import 'package:marketplace_patanjali/Models/update_profile_model.dart';
import 'package:marketplace_patanjali/resources/http_requests.dart';
import 'package:marketplace_patanjali/ui/Widgets/mandatory_field.dart';
import 'package:marketplace_patanjali/ui/Widgets/widget_methods.dart';

class EditProfileScreen extends StatefulWidget {
  final String userToken;
  final String userId;
  const EditProfileScreen({
    Key key,
    this.userToken,
    this.userId,
  }) : super(key: key);
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String currentCountry,
      currentState,
      currentCity,
      currentTehsil,
      currentBlock,
      currentVillage;
  String countryId, stateId, cityId, tehsilId, blockId, villageId;
  int countryIndex,
      stateIndex,
      cityIndex,
      tehsilIndex,
      blockIndex,
      villageIndex = 0;

  ApiBase _apiBase = ApiBase();

  File imageFile;
  List<int> imageBytes;
  String base64Image;
  String imageName;
  String imageFormat;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List countryData = [];
  // List countryCodeList = [];

  List stateData;
  List cityData;
  List tehsilData;
  List blockData;
  List villageData;

  List countryList = [];
  List stateList = [];
  List cityList = [];
  List tehsilList = [];
  List blockList = [];
  List villageList = [];

  List userTypeList = [];
  List userTypeIdList = [];
  String currentUserType;
  int userTypeIndex = 0;

  List qualityList = [];
  List qualityIdList = [];
  String currentQuality;
  int qualityIndex = 0;

  List countryIdList = [];
  List stateIdList = [];
  List cityIdList = [];
  List tehsilIdList = [];
  List blockIdList = [];
  List villageIdList = [];

  int i;

  Map<String, dynamic> param;
  var uData;
  bool loading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //Change Dropdown items

  Future<bool> changedDropDownItemCountry(
      String selectedCountry, String selectedState) async {
    setState(() {
      currentCountry = selectedCountry;
      countryIndex = countryList.indexOf(selectedCountry);

      cityIndex = 0;
      tehsilIndex = 0;
      blockIndex = 0;
      villageIndex = 0;
      countryId = countryIdList[countryIndex];
      currentState = null;
      stateId = null;
      stateIndex = 0;
    });
    param = {"countryGeoId": countryId};
    cityList.clear();
    tehsilList.clear();
    blockList.clear();
    villageList.clear();
    _apiBase.get(context, "/api/getAssociatedStateList", param, "").then((val) {
      print(val.body);
      var data = json.decode(val.body);
      setState(() {
        stateData = data["stateList"];

        stateList.clear();
        for (int i = 0; i < stateData.length; i++) {
          stateList.add(data["stateList"][i].split(": ")[0]);
          stateIdList.add(data["stateList"][i].split(": ")[1]);
        }
        print(stateIdList);
      });
      if (selectedState != null) {
        changedDropDownItemState(selectedState);
      }
    });
    return true;
  }

  void changedDropDownItemState(String selectedState) {
    stateIndex = stateList.indexOf(selectedState);
    cityIndex = 0;
    tehsilIndex = 0;
    blockIndex = 0;
    villageIndex = 0;
    setState(() {
      currentState = selectedState;
      stateId = stateIdList[stateIndex];
    });
    cityList.clear();
    tehsilList.clear();
    blockList.clear();
    villageList.clear();
  }

  void changedDropDownItemCity(String selectedCity) {
    cityIndex = cityList.indexOf(selectedCity);
    tehsilIndex = 0;
    blockIndex = 0;
    villageIndex = 0;
    setState(() {
      currentCity = selectedCity;
      cityId = cityData[cityIndex].id;
    });
    param = {"districtId": cityId};
    tehsilList.clear();
    blockList.clear();
    villageList.clear();
    _apiBase
        .get(context, "/api/getTehsilsByDistrict", param, widget.userToken)
        .then((val) {
      print(val.body);
      tehsilData = tehsilModelFromJson(val.body);
      if (tehsilData.length != 0) {
        setState(() {
          for (i = 0; i < tehsilData.length; i++) {
            tehsilList.add(tehsilData[i].name);
          }
          currentTehsil = tehsilData[0].name;
        });
      }
    });
  }

  void changedDropDownItemTehsil(String selectedTehsil) {
    tehsilIndex = tehsilList.indexOf(selectedTehsil);
    blockIndex = 0;
    villageIndex = 0;
    setState(() {
      currentTehsil = selectedTehsil;
      tehsilId = tehsilData[tehsilIndex].id;
    });
    param = {"tehsilId": tehsilId};
    blockList.clear();
    villageList.clear();
    _apiBase
        .get(context, "/api/getBlocksByTehsil", param, widget.userToken)
        .then((val) {
      print(val.body);
      blockData = blockModelFromJson(val.body);
      if (blockData.length != 0) {
        setState(() {
          for (i = 0; i < blockData.length; i++) {
            blockList.add(blockData[i].name);
          }
          currentBlock = blockData[0].name;
        });
      }
    });
  }

  void changedDropDownItemBlock(String selectedBlock) {
    blockIndex = blockList.indexOf(selectedBlock);
    villageIndex = 0;
    setState(() {
      currentBlock = selectedBlock;
      blockId = blockData[blockIndex].id;
    });
    param = {"blockId": blockId};
    villageList.clear();
    _apiBase
        .get(context, "/api/getVillagesByBlockId", param, widget.userToken)
        .then((val) {
      print(val.body);
      villageData = villageModelFromJson(val.body);
      if (villageData.length != 0) {
        setState(() {
          for (i = 0; i < villageData.length; i++) {
            villageList.add(villageData[i].name);
          }
          currentVillage = villageData[0].name;
        });
      }
    });
  }

  void changedDropDownItemVillage(String selectedVillage) {
    villageIndex = villageList.indexOf(selectedVillage);
    setState(() {
      currentVillage = selectedVillage;
      villageId = villageData[villageIndex].id;
    });
  }

  void changedDropDownUserType(String selectedUserType) {
    userTypeIndex = userTypeList.indexOf(selectedUserType);
    print(userTypeIndex);
    setState(() {
      currentUserType = selectedUserType;
    });
  }

  void changedDropDownQuality(String selectedQuality) {
    qualityIndex = qualityList.indexOf(selectedQuality);
    setState(() {
      currentQuality = selectedQuality;
    });
  }

  @override
  void initState() {
    _apiBase.get(context, "/api/getCountryList", null, "").then((cVal) {
      print(cVal.body);
      var cData = json.decode(cVal.body);
      setState(() {
        countryData = cData["countryList"];
        for (int i = 0; i < countryData.length; i++) {
          countryList.add(cData["countryList"][i].split(": ")[0]);
          countryIdList.add(cData["countryList"][i].split(": ")[1]);
        }
        print(countryIdList);
        //GET USERINFO
        param = {"partyId": widget.userId};
        _apiBase
            .get(context, "/api/getUserDetail", param, widget.userToken)
            .then((uVal) {
          print(uVal.body);
          uData = json.decode(uVal.body);
          firstNameController.text = uData["userDetail"]["firstName"];
          lastNameController.text = uData["userDetail"]["lastName"];
          fatherNameController.text = uData["userDetail"]["fatherName"];
          //Setting Country
          countryIndex = countryIdList
              .indexOf(uData["userDetail"]["postalAddress"]["countryGeoId"]);
          countryId = countryIdList[countryIndex];
          currentCountry = countryList[countryIndex];
          // currentUserType = uData["userDetail"]["userType"];
          // currentMethod = uData["userDetail"]["methodOfFarming"];
          emailController.text =
              uData["userDetail"]["emailAddress"]["emailAddress"];
          districtController.text =
              uData["userDetail"]["postalAddress"]["city"];
          tehsilController.text =
              uData["userDetail"]["postalAddress"]["address1"];
          blockController.text = uData["userDetail"]["postalAddress"]["block"];
          villageController.text =
              uData["userDetail"]["postalAddress"]["address2"];
          phoneController.text =
              uData["userDetail"]["phoneNumber"]["contactNumber"];

          //Get types
          _apiBase
              .get(context, "/api/getUserTypesList", null, "")
              .then((userTypeval) {
            if (userTypeval.statusCode == 200) {
              setState(() {
                var userTypeData = json.decode(userTypeval.body);
                for (int i = 0; i < userTypeData["roleTypeList"].length; i++) {
                  userTypeList
                      .add(userTypeData["roleTypeList"][i]["description"]);
                  userTypeIdList
                      .add(userTypeData["roleTypeList"][i]["roleTypeId"]);
                }
                print("$userTypeIdList ${uData["userDetail"]["userType"]}");
                setState(() {
                  userTypeIndex =
                      userTypeIdList.indexOf(uData["userDetail"]["userType"]);
                  print("wer$userTypeIndex");
                  currentUserType = userTypeList[userTypeIndex];
                });
              });
              _apiBase
                  .get(context, "/api/getQualityList", null, "")
                  .then((val) {
                if (val.statusCode == 200) {
                  setState(() {
                    var qualityData = json.decode(val.body);
                    for (int i = 0;
                        i < qualityData["qualityList"].length;
                        i++) {
                      qualityList
                          .add(qualityData["qualityList"][i]["description"]);
                      qualityIdList
                          .add(qualityData["qualityList"][i]["enumId"]);
                    }
                    setState(() {
                      qualityIndex = qualityIdList
                          .indexOf(uData["userDetail"]["methodOfFarming"]);
                      currentQuality = qualityList[qualityIndex];
                    });
                  });
                }
              });
            }
          });
          //Get State Data
          param = {
            "countryGeoId": uData["userDetail"]["postalAddress"]["countryGeoId"]
          };
          _apiBase
              .get(context, "/api/getAssociatedStateList", param, "")
              .then((sVal) {
            print(sVal.body);
            var sData = json.decode(sVal.body);
            setState(() {
              stateData = sData["stateList"];
              for (int i = 0; i < stateData.length; i++) {
                stateList.add(sData["stateList"][i].split(": ")[0]);
                stateIdList.add(sData["stateList"][i].split(": ")[1]);
              }
              stateIndex = stateIdList.indexOf(
                  uData["userDetail"]["postalAddress"]["stateProvinceGeoId"]);
              stateId = stateIdList[stateIndex];
              currentState = stateList[stateIndex];
            });
          });
        });
      });
    });

    super.initState();
  }

  TextEditingController firstNameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController tehsilController = TextEditingController();
  TextEditingController blockController = TextEditingController();
  TextEditingController villageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        // iconTheme: IconThemeData(color: Colors.white),
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
              MyLocalizations.of(context).word("myProfile", "Profile"),
              textAlign: TextAlign.start,
              // style: TextStyle(color: titleColor, fontSize: 18),
            ),
          ],
        ),
        elevation: 0,
      ),
      key: _scaffoldKey,
      body: uData == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: <Widget>[
                loading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Offstage(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    //Top Container
                    Container(
                      height: cHeight * 0.11,
                      width: cWidth,
                      color: Color(0xFF79CE1E),
                      child: Stack(
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
                          //           color: Colors.white,
                          //         ),
                          //         onPressed: () {},
                          //       ),
                          //       Text(
                          //         "My Profile",
                          //         style:
                          //             TextStyle(color: Colors.white, fontSize: 20),
                          //       ),
                          //       Text("              ")
                          //       // Column(
                          //       //   mainAxisAlignment: MainAxisAlignment.start,
                          //       //   children: <Widget>[
                          //       //     Text(
                          //       //       "Cloudy",
                          //       //       style: TextStyle(color: Colors.white, fontSize: 18),
                          //       //     ),
                          //       //     Text(
                          //       //       "Roorkee",
                          //       //       style: TextStyle(color: Colors.white, fontSize: 10),
                          //       //     ),
                          //       //     Row(
                          //       //       children: <Widget>[
                          //       //         Icon(
                          //       //           Icons.cloud,
                          //       //           color: Colors.white,
                          //       //         ),
                          //       //         Text(
                          //       //           "12",
                          //       //           style: TextStyle(
                          //       //               color: Colors.white, fontSize: 22),
                          //       //         ),
                          //       //         Text(
                          //       //           "°",
                          //       //           style: TextStyle(
                          //       //               color: Colors.white, fontSize: 22),
                          //       //         ),
                          //       //       ],
                          //       //     ),
                          //       //   ],
                          //       // ),
                          //     ],
                          //   ),
                          // ),
                          Positioned(
                              // top: cHeight * 0.01,
                              left: cWidth * 0.4,
                              child: Container(
                                child: Stack(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.only(right: cWidth * 0.04),
                                      child: CircleAvatar(
                                        radius: cWidth * 0.1,
                                        child: uData['userDetail']
                                                        ['profileImageData'] ==
                                                    null &&
                                                imageFile == null
                                            ? Icon(Icons.person)
                                            : null,
                                        backgroundColor: Colors.white,
                                        backgroundImage: uData['userDetail']
                                                        ['profileImageData'] ==
                                                    null &&
                                                imageFile == null
                                            ? null
                                            : imageFile == null
                                                ? NetworkImage(
                                                    uData['userDetail']
                                                        ['profileImageData'])
                                                : FileImage(imageFile),
                                      ),
                                    ),
                                    Positioned(
                                      top: cHeight * 0.05,
                                      left: cWidth * 0.17,
                                      child: GestureDetector(
                                        onTap: () {
                                          getImageGallery().then((val) {
                                            if (val != null) {
                                              setState(() {
                                                imageFile = val["imageFile"];
                                                imageName = val["imageName"];
                                                imageFormat =
                                                    val["imageFormat"];
                                                imageBytes =
                                                    imageFile.readAsBytesSync();
                                                base64Image =
                                                    base64Encode(imageBytes);
                                              });
                                            }
                                          });
                                        },
                                        child: CircleAvatar(
                                          radius: cWidth * 0.035,
                                          backgroundColor: Colors.black87,
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.grey,
                                            size: cWidth * 0.04,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),
                    //Form
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          children: <Widget>[
                            Container(
                              // color: Colors.red,
                              width: cWidth,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: cHeight * 0.01,
                                  left: cWidth * 0.05,
                                  right: cWidth * 0.05,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      MyLocalizations.of(context).word(
                                          "personalInformation",
                                          "Personal Information"),
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: TextFormField(
                                            controller: firstNameController,
                                            decoration: InputDecoration(
                                              labelText:
                                                  MyLocalizations.of(context)
                                                      .word("firstName",
                                                          "First Name"),
                                            ),
                                            validator: (value) {
                                              if (value.length == 0) {
                                                return ('Enter First Name');
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                        new MandatoryField(),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: TextFormField(
                                            controller: lastNameController,
                                            decoration: InputDecoration(
                                              labelText:
                                                  MyLocalizations.of(context)
                                                      .word("lastName",
                                                          "Last Name"),
                                            ),
                                            validator: (value) {
                                              if (value.length == 0) {
                                                return ('Enter Last Name');
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                        new MandatoryField(),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: TextFormField(
                                            controller: fatherNameController,
                                            decoration: InputDecoration(
                                              labelText:
                                                  MyLocalizations.of(context)
                                                      .word("father'SName",
                                                          "Father's Name"),
                                            ),
                                            validator: (value) {
                                              if (value.length == 0) {
                                                return ("Enter Father's Name");
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                        new MandatoryField(),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: AbsorbPointer(
                                            child: DropdownButtonFormField(
                                              hint: Text(
                                                MyLocalizations.of(context)
                                                    .word("userType",
                                                        "User Type"),
                                              ),
                                              items:
                                                  getDropDownMenuItemsDisabled(
                                                      null, userTypeList),
                                              value: currentUserType,
                                              onChanged:
                                                  changedDropDownUserType,
                                            ),
                                          ),
                                        ),
                                        new MandatoryField(),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: DropdownButtonFormField(
                                            hint: Text(
                                              MyLocalizations.of(context).word(
                                                  "methodOfFarming",
                                                  "Method of Farming"),
                                            ),
                                            items: getDropDownMenuItems(
                                                null, qualityList),
                                            value: currentQuality,
                                            onChanged: changedDropDownQuality,
                                          ),
                                        ),
                                        new MandatoryField(),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: TextFormField(
                                            enabled: false,
                                            style:
                                                TextStyle(color: Colors.grey),
                                            controller: phoneController,
                                            decoration: InputDecoration(
                                              labelText:
                                                  MyLocalizations.of(context)
                                                      .word("phoneNumber",
                                                          "Phone number"),
                                            ),
                                            validator: (value) {
                                              if (value.length == 0) {
                                                return ('Enter Phone number');
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                        new MandatoryField(),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: TextFormField(
                                            controller: emailController,
                                            decoration: InputDecoration(
                                              labelText:
                                                  MyLocalizations.of(context)
                                                      .word("emailAddress",
                                                          "Email Address"),
                                            ),
                                            // validator: (value) {
                                            //   if (value.length == 0) {
                                            //     return ('Enter email address');
                                            //   } else {
                                            //     return null;
                                            //   }
                                            // },
                                          ),
                                        ),
                                        new NotMandatoryField(),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: cHeight * 0.035,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            MyLocalizations.of(context).word(
                                                "locationDetails",
                                                "Location Details"),
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                loading = true;
                                              });
                                              getLocation().then((coord) {
                                                getLocationName(coord)
                                                    .then((val) {
                                                  changedDropDownItemCountry(
                                                          val.countryName,
                                                          val.adminArea)
                                                      .then((v) {
                                                    print(val.addressLine);
                                                    // changedDropDownItemState(
                                                    //     val.adminArea);
                                                    setState(() {
                                                      loading = false;
                                                      districtController.text =
                                                          val.subAdminArea;
                                                      tehsilController.text =
                                                          val.subLocality;
                                                      villageController.text =
                                                          val.thoroughfare;
                                                    });
                                                  });
                                                  // print(val.addressLine);
                                                  // print(val.adminArea);
                                                  // print(val.coordinates);
                                                  // print(val.countryCode);
                                                  // print(val.countryName);
                                                  // print(val.featureName);
                                                  // print(val.locality);
                                                  // print(val.postalCode);
                                                  // print(val.subAdminArea);
                                                  // print(val.subLocality);
                                                  // print(val.subThoroughfare);
                                                  // print(val.thoroughfare);
                                                });
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.location_on,
                                                  color: Colors.red,
                                                  size: 20,
                                                ),
                                                Text(
                                                  MyLocalizations.of(context)
                                                      .word("fetchLocation",
                                                          "Fetch Location"),
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                Text(
                                                  "(" +
                                                      MyLocalizations.of(
                                                              context)
                                                          .word("UsingGps",
                                                              "(Using Gps)") +
                                                      ")",
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: DropdownButton(
                                            isExpanded: true,
                                            hint: Text(
                                              MyLocalizations.of(context)
                                                  .word("country", "Country"),
                                            ),
                                            items: getDropDownMenuItems(
                                                null, countryList),
                                            value: currentCountry,
                                            onChanged: (cont) {
                                              changedDropDownItemCountry(
                                                  cont, null);
                                            },
                                          ),
                                        ),
                                        new MandatoryField(),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: DropdownButtonFormField(
                                            hint: Text(
                                              MyLocalizations.of(context)
                                                  .word("state", "State"),
                                            ),
                                            items: getDropDownMenuItems(
                                                null, stateList),
                                            value: currentState,
                                            onChanged: changedDropDownItemState,
                                          ),
                                        ),
                                        new MandatoryField(),
                                      ],
                                    ),
                                    // Row(
                                    //   children: <Widget>[
                                    //     Expanded(
                                    //       child: DropdownButtonFormField(
                                    //         hint: Text("District"),
                                    //         items: getDropDownMenuItems(cityList),
                                    //         value: currentCity,
                                    //         onChanged: changedDropDownItemCity,
                                    //       ),
                                    //     ),
                                    //     new MandatoryField(),
                                    //   ],
                                    // ),
                                    // Row(
                                    //   children: <Widget>[
                                    //     Expanded(
                                    //       child: DropdownButtonFormField(
                                    //         hint: Text("Tehsil"),
                                    //         items: getDropDownMenuItems(tehsilList),
                                    //         value: currentTehsil,
                                    //         onChanged: changedDropDownItemTehsil,
                                    //       ),
                                    //     ),
                                    //     new MandatoryField(),
                                    //   ],
                                    // ),
                                    // Row(
                                    //   children: <Widget>[
                                    //     Expanded(
                                    //       child: DropdownButtonFormField(
                                    //         hint: Text("Block"),
                                    //         items: getDropDownMenuItems(blockList),
                                    //         value: currentBlock,
                                    //         onChanged: changedDropDownItemBlock,
                                    //       ),
                                    //     ),
                                    //     new MandatoryField(),
                                    //   ],
                                    // ),
                                    // Row(
                                    //   children: <Widget>[
                                    //     Expanded(
                                    //       child: DropdownButtonFormField(
                                    //         hint: Text("Village"),
                                    //         items: getDropDownMenuItems(villageList),
                                    //         value: currentVillage,
                                    //         onChanged: changedDropDownItemVillage,
                                    //       ),
                                    //     ),
                                    //     new MandatoryField(),
                                    //   ],
                                    // ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: TextFormField(
                                            controller: districtController,
                                            decoration: InputDecoration(
                                              labelText: MyLocalizations.of(
                                                      context)
                                                  .word("district", "District"),
                                            ),
                                            validator: (value) {
                                              if (value.length == 0) {
                                                return ('Enter district name');
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                        new MandatoryField(),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: TextFormField(
                                            controller: tehsilController,
                                            decoration: InputDecoration(
                                              labelText:
                                                  MyLocalizations.of(context)
                                                      .word("tehsil", "Tehsil"),
                                            ),
                                            // validator: (value) {
                                            //   if (value.length == 0) {
                                            //     return ('Enter Tehsil Name');
                                            //   } else {
                                            //     return null;
                                            //   }
                                            // },
                                          ),
                                        ),
                                        new NotMandatoryField(),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: TextFormField(
                                            controller: blockController,
                                            decoration: InputDecoration(
                                              labelText:
                                                  MyLocalizations.of(context)
                                                      .word("block", "Block"),
                                            ),
                                            // validator: (value) {
                                            //   if (value.length == 0) {
                                            //     return ('Enter Village Name');
                                            //   } else {
                                            //     return null;
                                            //   }
                                            // },
                                          ),
                                        ),
                                        new NotMandatoryField(),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: TextFormField(
                                            controller: villageController,
                                            decoration: InputDecoration(
                                              labelText:
                                                  MyLocalizations.of(context)
                                                      .word(
                                                          "village", "Village"),
                                            ),
                                            // validator: (value) {
                                            //   if (value.length == 0) {
                                            //     return ('Enter Village Name');
                                            //   } else {
                                            //     return null;
                                            //   }
                                            // },
                                          ),
                                        ),
                                        new NotMandatoryField(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    PhysicalModel(
                      color: loading ? Colors.grey : Color(0xFF79CE1E),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: MaterialButton(
                              disabledColor: Colors.grey,
                              child: Text(
                                "Save",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: loading ? null : _validate,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  void _validate() {
    if (_formKey.currentState.validate()) {
      print(userTypeIdList[userTypeIndex]);
      _formKey.currentState.save();
      setState(() {
        loading = true;
      });
      PostalAddress postalAddress = PostalAddress(
        countryGeoId: countryId,
        stateProvinceGeoId: stateId,
        city: districtController.text,
        address1: tehsilController.text,
        block: blockController.text,
        address2: villageController.text,
        contactMechId: uData["userDetail"]["postalAddress"]["contactMechId"],
        contactMechPurposeTypeId: uData["userDetail"]["postalAddress"]
            ["contactMechPurposeTypeId"],
        postalCode: uData["userDetail"]["postalAddress"]["postalCode"],
      );
      EmailAddress emailAddress = EmailAddress(
        contactMechId: uData["userDetail"]["emailAddress"]["contactMechId"],
        emailAddress: emailController.text,
      );
      PhoneNumber phoneNumber = PhoneNumber(
        contactNumber: uData["userDetail"]["phoneNumber"]["contactNumber"],
        contactMechId: uData["userDetail"]["phoneNumber"]["contactMechId"],
        contactMechPurposeTypeId: uData["userDetail"]["phoneNumber"]
            ["contactMechPurposeTypeId"],
      );
      UpdateData updateData = UpdateData(
        emailAddress: emailAddress,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        fatherName: fatherNameController.text,
        methodOfFarming: qualityIdList[qualityIndex],
        userType: userTypeIdList[userTypeIndex],
        postalAddress: postalAddress,
        // name: uData["userDetail"]["name"],
        phoneNumber: phoneNumber,
      );
      UpdateProfileModel body = UpdateProfileModel(
        partyId: widget.userId,
        updateData: updateData,
      );
      _apiBase
          .put(context, "/api/updateUserDetail", null, body, "")
          .then((val) {
        print(json.encode(body));
        if (val.statusCode == 200) {
          if (imageFile != null) {
            var body1 = {
              "fileName": imageName,
              "mimeTypeId": "image/$imageFormat",
              "partyId": widget.userId,
              "uploadImage": base64Image
            };
            _apiBase
                .post(context, "/api/uploadProfilePicImage", null, body1,
                    widget.userToken)
                .then((val) {
              setState(() {
                loading = false;
              });
              _scaffoldKey.currentState.showSnackBar(
                  new SnackBar(content: new Text("Details Saved")));
            });
          } else {
            setState(() {
              loading = false;
            });
            _scaffoldKey.currentState
                .showSnackBar(new SnackBar(content: new Text("Details Saved")));
          }
        } else {
          setState(() {
            loading = false;
          });
          _scaffoldKey.currentState.showSnackBar(
              new SnackBar(content: new Text("Details Not Saved")));
        }
      });
    }
  }
}
