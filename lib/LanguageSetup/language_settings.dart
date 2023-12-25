// import 'package:fertilizercalculator/src/UI/login/login.dart';
// import 'package:fertilizercalculator/src/UI/home.dart';
import 'package:flutter/material.dart';
import 'package:marketplace_patanjali/LanguageSetup/constant.dart';
import 'package:marketplace_patanjali/ui/Login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSettings extends StatefulWidget {
  @override
  _LanguageSettingsState createState() => _LanguageSettingsState();
}

class _LanguageSettingsState extends State<LanguageSettings> {
  List languages = [
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
  //String selectedLanguage="";

  double cHeight;
  double cWidth;

  _nextPage() {
    var route =
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen());
    Navigator.of(context).push(route);
  }

  saveLanguage(String code) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    await preferences.setString('language', code);
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: cWidth * 0.05,
          right: cWidth * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Welcome to Dharti Ka Doctor!",
              style: TextStyle(color: Colors.white, fontSize: cHeight * 0.04),
            ),
            Padding(
              padding: EdgeInsets.only(top: cHeight * 0.04),
              child: Text(
                "Choose a language",
                style: TextStyle(
                  fontSize: cHeight * 0.02,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    top: cHeight * 0.04, bottom: cHeight * 0.04),
                child: Scrollbar(
                  child: ListView.builder(
                    itemCount: languages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: <Widget>[
                          ListTile(
                            onTap: () {
                              saveLanguage(languageCode[index]);
                              setState(() {
                                locale = languageCode[index];
                              });
                              print(locale);
                              _nextPage();
                            },
                            title: Text(
                              languages[index],
                              style: TextStyle(
                                fontSize: cHeight * 0.022,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Divider(),
                        ],
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
