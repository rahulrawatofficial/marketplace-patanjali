import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:marketplace_patanjali/Functions/get_saved_info.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';
import 'package:marketplace_patanjali/LanguageSetup/constant.dart';
import 'package:marketplace_patanjali/LanguageSetup/initialize_i18n.dart';
import 'package:marketplace_patanjali/LanguageSetup/localizations.dart';
import 'package:marketplace_patanjali/resources/http_requests.dart';
import 'package:marketplace_patanjali/ui/Login/login_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/main_screen.dart';
import 'package:marketplace_patanjali/ui/Widgets/top_bar.dart';
import 'package:marketplace_patanjali/ui/Widgets/widget_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Functions/error_handling.dart';

class CountryScreen extends StatefulWidget {
  final String settings;
  final VoidCallback onChangeLanguage;

  CountryScreen(this.onChangeLanguage, this.settings);
  @override
  _CountryScreenState createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  String userId;
  String userToken;
  String userName;
  String userPhoneNum;
  TextEditingController phoneNumberController = TextEditingController();
  bool loading = true;

  ApiBase _apiBase = ApiBase();

  List countryData;
  List countryList = [];
  List<String> languageList = [
    "English",
    "हिंदी",
    "मराठी",
    'অসমীয়া',
    'ગુજરાતી',
    'മലയാളം',
    'বাংলা',
    'ಕನ್ನಡ',
    'नेपाली',
    'ओड़िया',
    'ਪੰਜਾਬੀ',
    'தமிழ்',
    'తెలుగు',
  ];
  List languageCode = [
    'en',
    'hi',
    'mr',
    'as',
    'gu',
    'ml',
    'bn',
    'kn',
    'ne',
    'or',
    'pa',
    'ta',
    'te',
  ];
  int languageIndex = 0;

  String currentCountry;
  String currentLanguage;
  _nextPage() async {
    Map<String, Map<String, String>> localizedValues = await initializeI18n();
    if (widget.settings == "yes") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => /* HomeTabScreen*/ MainScreen(
            userId: userId,
            userName: userName,
            userToken: userToken,
            userPhoneNum: userPhoneNum,
            roleAlert: false,
          ),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }
  }

  saveLanguage(String code) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.setString('language', code);
  }

  @override
  void initState() {
    _apiBase.get(context, "/api/getCountryList", null, "").then((val) {
      setState(() {
        loading = false;
      });
      print(val.body);
      var data = json.decode(val.body);
      setState(() {
        loading = false;
        countryData = data["countryList"];
        currentCountry = "India";
        for (int i = 0; i < countryData.length; i++) {
          countryList.add(data["countryList"][i].split(":")[0]);
        }
      });
    });

    getUserSavedInfo().then((val) {
      setState(() {
        userId = val["userId"];
        userToken = val["userToken"];
        userName = val["userName"];
        userPhoneNum = val["userPhoneNum"];
      });
      print("PartyID: $userId");

      print("Token: $userToken");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new TopBar(),
              Column(
                children: <Widget>[
                  Image.asset(
                    "assets/images/LoginScreen/sendOtp.png",
                    height: cHeight * 0.2,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: cHeight * 0.02,
                      left: cWidth * 0.2,
                      right: cWidth * 0.2,
                    ),
                    child: DropdownButton(
                      isExpanded: true,
                      items: getDropDownMenuItems(null, countryList),
                      value: currentCountry,
                      hint: Text("Country"),
                      onChanged: (change) {
                        setState(() {
                          currentCountry = change;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: cHeight * 0.02,
                      left: cWidth * 0.2,
                      right: cWidth * 0.2,
                    ),
                    child: DropdownButton(
                      isExpanded: true,
                      items: getDropDownMenuItems(null, languageList),
                      value: currentLanguage,
                      hint: Text("Language"),
                      onChanged: (String change) {
                        var lanCode;
                        languageIndex = languageList.indexOf(change);
                        lanCode = languageCode[languageIndex];
                        // if (change == "Marathi") {
                        //   lanCode = "mr";
                        // } else if (change == "Hindi") {
                        //   lanCode = "hi";
                        // } else {
                        //   lanCode = "en";
                        // }
                        // if (change)
                        // lanCode = "te";
                        saveLanguage(lanCode);
                        setState(() {
                          currentLanguage = change;
                          locale = lanCode;
                        });
                        print(locale);
                        widget.onChangeLanguage();
                        print("next step");
                        // setState(() {
                        //   currentLanguage = change;
                        // });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: cHeight * 0.3,
                      left: cWidth * 0.15,
                      right: cWidth * 0.15,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: PhysicalModel(
                            color: loading ? Colors.grey : Color(0xFF0047C4),
                            child: MaterialButton(
                              child: Text(
                                MyLocalizations.of(context)
                                    .word("next", "Next"),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                currentLanguage != null
                                    ? _nextPage()
                                    : ErrorHandling().showErrorDailog(
                                        context, " ", "Select Language");
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (context) => LoginScreen(),
                                //   ),
                                // );
                              },
                              // onPressed: null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Offstage(),
        ],
      ),
    );
  }
}
