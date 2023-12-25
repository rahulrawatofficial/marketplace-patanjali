import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:marketplace_patanjali/Functions/error_handling.dart';
import 'package:marketplace_patanjali/Functions/save_login.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';
import 'package:marketplace_patanjali/Models/LocationModel/block_model.dart';
import 'package:marketplace_patanjali/Models/LocationModel/tehsil_model.dart';
import 'package:marketplace_patanjali/Models/LocationModel/village_model.dart';
import 'package:marketplace_patanjali/Models/add_user_model.dart';
import 'package:marketplace_patanjali/Models/user_response_model.dart';
import 'package:marketplace_patanjali/resources/http_requests.dart';
import 'package:marketplace_patanjali/ui/Screens/main_screen.dart';
import 'package:marketplace_patanjali/ui/Widgets/mandatory_field.dart';
import 'package:marketplace_patanjali/ui/Widgets/widget_methods.dart';

class ProfileScreen extends StatefulWidget {
  final UserResponseModel userInfo;
  final String phoneNumber;
  const ProfileScreen({
    Key key,
    this.userInfo,
    this.phoneNumber,
  }) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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

  // List methodList = ["Cert-Organic", "Organic", "Chemical"];
  // String currentMethod;

  List countryIdList = [];
  List stateIdList = [];
  List cityIdList = [];
  List tehsilIdList = [];
  List blockIdList = [];
  List villageIdList = [];

  int i;

  Map<String, dynamic> param;

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
    stateList.clear();
    cityList.clear();
    tehsilList.clear();
    blockList.clear();
    villageList.clear();
    _apiBase.get(context, "/api/getAssociatedStateList", param, "").then((val) {
      print(val.body);
      var data = json.decode(val.body);
      setState(() {
        stateData = data["stateList"];
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
        .get(context, "/api/getTehsilsByDistrict", param,
            widget.userInfo.basicAuth)
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
        .get(
            context, "/api/getBlocksByTehsil", param, widget.userInfo.basicAuth)
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
        .get(context, "/api/getVillagesByBlockId", param,
            widget.userInfo.basicAuth)
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
    // print("##${widget.userInfo.partyDetail.partyId}##");
    phoneController.text = widget.phoneNumber;
    _apiBase.get(context, "/api/getCountryList", null, "").then((val) {
      print(val.body);
      var data = json.decode(val.body);
      setState(() {
        countryData = data["countryList"];
        for (int i = 0; i < countryData.length; i++) {
          countryList.add(data["countryList"][i].split(": ")[0]);
          countryIdList.add(data["countryList"][i].split(": ")[1]);
        }
        print(countryIdList);
      });
      _apiBase.get(context, "/api/getUserTypesList", null, "").then((val) {
        if (val.statusCode == 200) {
          setState(() {
            var userTypeData = json.decode(val.body);
            for (int i = 0; i < userTypeData["roleTypeList"].length; i++) {
              userTypeList.add(userTypeData["roleTypeList"][i]["description"]);
              userTypeIdList.add(userTypeData["roleTypeList"][i]["roleTypeId"]);
            }
          });
          _apiBase.get(context, "/api/getQualityList", null, "").then((val) {
            if (val.statusCode == 200) {
              setState(() {
                var qualityData = json.decode(val.body);
                for (int i = 0; i < qualityData["qualityList"].length; i++) {
                  qualityList.add(qualityData["qualityList"][i]["description"]);
                  qualityIdList.add(qualityData["qualityList"][i]["enumId"]);
                  //
                }
              });
              _apiBase
                  .get(context, "/api/getUserByPhoneNumber",
                      {"phoneNumber": widget.phoneNumber}, "")
                  .then((val) {
                var userData = json.decode(val.body);
                if (userData["responseData"]["id"] != null) {
                  setState(() {
                    firstNameController.text =
                        userData["responseData"]["firstName"];
                    fatherNameController.text =
                        userData["responseData"]["fatherName"];
                    lastNameController.text =
                        userData["responseData"]["lastName"];
                    districtController.text = userData["responseData"]
                        ["addressModel"]["city"]["name"];
                    tehsilController.text = userData["responseData"]
                        ["addressModel"]["tehsil"]["name"];
                    blockController.text = userData["responseData"]
                        ["addressModel"]["block"]["name"];
                    villageController.text = userData["responseData"]
                        ["addressModel"]["villageModel"]["name"];
                    //Getting Country
                    countryIndex = countryIdList.indexOf("IND");
                    countryId = countryIdList[countryIndex];
                    currentCountry = countryList[countryIndex];
                    //Get State Data
                    param = {"countryGeoId": countryId};
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
                        stateIndex = stateList.indexOf(userData["responseData"]
                            ["addressModel"]["state"]["name"]);
                        stateId = stateIdList[stateIndex];
                        currentState = stateList[stateIndex];
                      });
                    });
                  });
                }
              });
            }
          });
        }
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //Top Container
          Container(
            height: cHeight * 0.2,
            width: cWidth,
            color: Color(0xFF79CE1E),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: cHeight * 0.05),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                      Text(
                        "My Profile",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Text("              ")
                      // Column(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: <Widget>[
                      //     Text(
                      //       "Cloudy",
                      //       style: TextStyle(color: Colors.white, fontSize: 18),
                      //     ),
                      //     Text(
                      //       "Roorkee",
                      //       style: TextStyle(color: Colors.white, fontSize: 10),
                      //     ),
                      //     Row(
                      //       children: <Widget>[
                      //         Icon(
                      //           Icons.cloud,
                      //           color: Colors.white,
                      //         ),
                      //         Text(
                      //           "12",
                      //           style: TextStyle(
                      //               color: Colors.white, fontSize: 22),
                      //         ),
                      //         Text(
                      //           "°",
                      //           style: TextStyle(
                      //               color: Colors.white, fontSize: 22),
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
                Positioned(
                    top: cHeight * 0.09,
                    left: cWidth * 0.4,
                    child: Container(
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: cWidth * 0.04),
                            child: CircleAvatar(
                              radius: cWidth * 0.1,
                              child:
                                  imageFile != null ? null : Icon(Icons.person),
                              backgroundColor: Colors.white,
                              backgroundImage: imageFile != null
                                  ? FileImage(imageFile)
                                  : null,
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
                                      imageFormat = val["imageFormat"];
                                      imageBytes = imageFile.readAsBytesSync();
                                      base64Image = base64Encode(imageBytes);
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
                            "Personal Information",
                            style: TextStyle(fontSize: 20),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  controller: firstNameController,
                                  decoration:
                                      InputDecoration(labelText: "First Name"),
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
                                  decoration:
                                      InputDecoration(labelText: "Last Name"),
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
                                      labelText: "Father's Name"),
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
                                child: DropdownButtonFormField(
                                  hint: Text("User Type"),
                                  items:
                                      getDropDownMenuItems(null, userTypeList),
                                  value: currentUserType,
                                  onChanged: (change) {
                                    setState(() {
                                      currentUserType = change;
                                    });
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
                                  hint: Text("Method of Farming"),
                                  items:
                                      getDropDownMenuItems(null, qualityList),
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
                                  controller: phoneController,
                                  decoration: InputDecoration(
                                      labelText: "Phone number"),
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
                                      labelText: "Email Address"),
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
                            child: InkWell(
                              onTap: () {
                                getLocation().then((coord) {
                                  getLocationName(coord).then((val) {
                                    changedDropDownItemCountry(
                                            val.countryName, val.adminArea)
                                        .then((v) {
                                      // changedDropDownItemState(val.adminArea);
                                      setState(() {
                                        districtController.text =
                                            val.subAdminArea;
                                        tehsilController.text = val.subLocality;
                                        villageController.text =
                                            val.thoroughfare;
                                      });
                                    });
                                    print(val.countryName);
                                    print(val.adminArea);
                                    print(val.subAdminArea);
                                    print(val.addressLine);
                                  });
                                });
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Location Details",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                      Text(
                                        "Fetch Location",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        "Using Gps",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: DropdownButton(
                                  isExpanded: true,
                                  hint: Text("Country"),
                                  items:
                                      getDropDownMenuItems(null, countryList),
                                  value: currentCountry,
                                  onChanged: (cont) {
                                    changedDropDownItemCountry(cont, null);
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
                                  hint: Text("State"),
                                  items: getDropDownMenuItems(null, stateList),
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
                                  decoration:
                                      InputDecoration(labelText: "District"),
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
                                  decoration:
                                      InputDecoration(labelText: "Tehsil"),
                                  validator: (value) {
                                    if (value.length == 0) {
                                      return ('Enter Tehsil Name');
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
                                  controller: blockController,
                                  decoration:
                                      InputDecoration(labelText: "Block"),
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
                                  decoration:
                                      InputDecoration(labelText: "Village"),
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
            color: Color(0xFF79CE1E),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: MaterialButton(
                    child: Text(
                      "Next",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      _validate();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _validate() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      PostalAddress postalAddress = PostalAddress(
        countryGeoId: countryId,
        stateProvinceGeoId: stateId,
        city: districtController.text,
        address1: tehsilController.text,
        block: blockController.text,
        address2: villageController.text,
      );
      ReqData reqData = ReqData(
        email: emailController.text,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        fatherName: fatherNameController.text,
        methodOfFarming: qualityIdList[qualityIndex],
        userType: userTypeIdList[userTypeIndex],
        postalAddress: postalAddress,
      );
      AddUserModel body = AddUserModel(
        partyId: widget.userInfo.partyDetail.partyId,
        reqData: reqData,
      );
      _apiBase.post(context, "/api/addUserDetail", null, body, "").then((val) {
        print(json.encode(body));
        if (val.statusCode == 200) {
          var d = json.decode(val.body);
          if (d["responseMessage"] != "error") {
            PartyDetail partyDetail = PartyDetail(
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              partyId: widget.userInfo.partyDetail.partyId,
            );
            UserResponseModel userIn = UserResponseModel(
              basicAuth: widget.userInfo.basicAuth,
              responseMessage: widget.userInfo.responseMessage,
              partyDetail: partyDetail,
            );
            if (imageFile != null) {
              var body1 = {
                "fileName": imageName,
                "mimeTypeId": "image/$imageFormat",
                "partyId": widget.userInfo.partyDetail.partyId,
                "uploadImage": base64Image
              };
              _apiBase
                  .post(context, "/api/uploadProfilePicImage", null, body1,
                      widget.userInfo.basicAuth)
                  .then((val) {
                saveCurrentLogin(userIn, widget.phoneNumber).then((onValue) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => MainScreen(
                          userId: widget.userInfo.partyDetail.partyId,
                          userName: firstNameController.text,
                          userToken: widget.userInfo.basicAuth,
                          userPhoneNum: widget.phoneNumber,
                          roleAlert: true,
                        ),
                      ),
                      ModalRoute.withName('sad'));
                });
              });
            } else {
              saveCurrentLogin(userIn, widget.phoneNumber).then((onValue) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => MainScreen(
                        userId: widget.userInfo.partyDetail.partyId,
                        userName: firstNameController.text,
                        userToken: widget.userInfo.basicAuth,
                        userPhoneNum: widget.phoneNumber,
                        roleAlert: true,
                      ),
                    ),
                    ModalRoute.withName('sad'));
              });
            }
          } else {
            ErrorHandling().showErrorDailog(context, "", d["errorMessage"]);
          }
        }
      });
    }
  }
}
