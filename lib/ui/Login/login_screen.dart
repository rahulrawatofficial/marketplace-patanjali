import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';
import 'package:marketplace_patanjali/LanguageSetup/localizations.dart';
import 'package:marketplace_patanjali/resources/http_requests.dart';
import 'package:marketplace_patanjali/ui/Login/verification_screen.dart';
import 'package:marketplace_patanjali/ui/Widgets/top_bar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneNumberController = TextEditingController();
  bool loading = false;

  String _fcmToken;

  final FirebaseMessaging _messaging = FirebaseMessaging();

  checkLogin() {
    print("Running");
    {
      Map<String, String> params = {"phoneNumber": phoneNumberController.text};
      setState(() {
        loading = true;
      });
      print(phoneNumberController.text);
      ApiBase().get(context, "/api/sendOtp", params, null).then((val) {
        print("!!${val.body}!!");
        setState(() {
          loading = false;
        });
        if (val.statusCode == 200) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => VerificationScreen(
                phoneNumber: phoneNumberController.text,
              ),
            ),
          );
        }
      });
    }
  }

  @override
  void initState() {
    firebaseCloudMessagingListeners();

    _messaging.getToken().then((token) {
      print("fcmToken: $token");
      _fcmToken = token;
    });
    super.initState();
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iosPermission();

    _messaging.getToken().then((token) {
      print(token);
    });

    _messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        showNotification(message['notification']);
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iosPermission() {
    _messaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _messaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  //Local Notification
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  localNotification() {
    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);
  }

  showNotification(msg) async {
    var android = new AndroidNotificationDetails(
      'vizitor pass',
      "CHANNLE NAME",
      "channelDescription",
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, msg['title'], msg['body'], platform);
  }

  @override
  void dispose() {
    localNotification();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // resizeToAvoidBottomPadding: true,
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new TopBar(),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Image.asset(
                          "assets/images/LoginScreen/sendOtp.png",
                          height: cHeight * 0.2,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: cHeight * 0.04,
                            bottom: cHeight * 0.02,
                            left: cWidth * 0.2,
                            right: cWidth * 0.2,
                          ),
                          child: Text(
                            MyLocalizations.of(context)
                                .word("otpVerification", "OTP Verification"),
                            // "OTP Verification",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: cHeight * 0.08,
                            left: cWidth * 0.2,
                            right: cWidth * 0.2,
                          ),
                          child: Text(
                            "Enter your mobile number to recieve OTP",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: cHeight * 0.02,
                            left: cWidth * 0.2,
                            right: cWidth * 0.2,
                          ),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: phoneNumberController,
                            decoration: InputDecoration(
                              prefix: Container(
                                width: cWidth * 0.17,
                                child: Row(
                                  children: <Widget>[
                                    Text("+91"),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                                  color:
                                      loading ? Colors.grey : Color(0xFF0047C4),
                                  child: MaterialButton(
                                    child: Text(
                                      "Get OTP",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: loading ? null : checkLogin,
                                    // onPressed: null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
