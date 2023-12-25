import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketplace_patanjali/Functions/get_saved_info.dart';
import 'package:marketplace_patanjali/LanguageSetup/constant.dart';
import 'package:marketplace_patanjali/ui/Login/country_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/MyAds/my_ad_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/home_category_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/main_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:marketplace_patanjali/LanguageSetup/initialize_i18n.dart'
    show initializeI18n;
import 'package:marketplace_patanjali/LanguageSetup/constant.dart'
    show languages, locale;
import 'package:marketplace_patanjali/LanguageSetup/localizations.dart'
    show MyLocalizations, MyLocalizationsDelegate;
import 'package:marketplace_patanjali/ui/launch_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Map<String, Map<String, String>> localizedValues = await initializeI18n();
  runApp(MyApp(localizedValues));
}

class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>> localizedValues;
  MyApp(this.localizedValues);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String userId;
  String userToken;
  String userName;
  String userPhoneNum;
  String languageCode;
  String newApp;
  bool launch = true;
  bool lanSplash = true;

  getLanguage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      languageCode = preferences.getString('language');
      lanSplash = preferences.getBool('lanSplash');
      preferences.getString('language') != null
          ? locale = preferences.getString('language')
          : locale = 'en';
    });
  }

  launchIt() {
    new Future.delayed(const Duration(seconds: 2), () {
      return setState(() {
        launch = false;
      });
    });
  }

  onChangeLanguage() {
    setState(() {});
    print("done");
  }

  @override
  void initState() {
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
    getLanguage();
    launchIt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => MainScreen(
              userId: userId,
              userName: userName,
              userToken: userToken,
              userPhoneNum: userPhoneNum,
              roleAlert: false,
            ),
        '/myAds': (BuildContext context) => MyAdScreen(
              userId: userId,
              userName: userName,
              userToken: userToken,
              userPhoneNum: userPhoneNum,
            ),
      },
      locale: Locale(locale),
      localizationsDelegates: [
        MyLocalizationsDelegate(widget.localizedValues),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: languages.map((language) => Locale(language, '')),
      debugShowCheckedModeBanner: false,
      title: 'Annadata',
      theme: ThemeData(
        // scaffoldBackgroundColor: Color(0xFFFF6200),
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          actionsIconTheme: IconThemeData(
            color: Color(0xFF0047C4),
          ),
          color: Color(0xFF79CE1E),
          textTheme: TextTheme(
            // title: GoogleFonts.getFont('Lato'),
            // title: TextStyle(
            //     color: Colors.white, fontSize: 20, fontFamily: "Matura"),
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
      home: launch == true && lanSplash == true
          ? LaunchScreen()
          : userId != null
              ? languageCode != null
                  ? MainScreen(
                      userId: userId,
                      userName: userName,
                      userToken: userToken,
                      userPhoneNum: userPhoneNum,
                      roleAlert: true,
                    )
                  // ? HomeCategoryScreen(
                  //     userId: userId,
                  //     userName: userName,
                  //     userToken: userToken,
                  //     userPhoneNum: userPhoneNum,
                  //   )
                  : CountryScreen(this.onChangeLanguage, "yes")
              : CountryScreen(this.onChangeLanguage, "no"),
      // : MainScreen(
      //     userId: userId,
      //     userRole: userRole,
      //     userToken: userToken,
      //     userName: userName,
      //     userProfilePic: userProfilePic,
      //   ),
    );
  }
}
