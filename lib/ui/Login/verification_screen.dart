import 'package:flutter/material.dart';
import 'package:marketplace_patanjali/Functions/save_login.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';
import 'package:marketplace_patanjali/LanguageSetup/localizations.dart';
import 'package:marketplace_patanjali/Models/user_response_model.dart';
import 'package:marketplace_patanjali/resources/http_requests.dart';
import 'package:marketplace_patanjali/ui/Screens/main_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/profile_screen.dart';
import 'package:marketplace_patanjali/ui/Widgets/top_bar.dart';

class VerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const VerificationScreen({Key key, this.phoneNumber}) : super(key: key);
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  TextEditingController otpController = TextEditingController();
  bool loading = false;

  verifyOtp() {
    Map<String, String> body = {
      "otp": otpController.text,
      "phoneNumber": widget.phoneNumber
    };
    setState(() {
      loading = true;
    });
    ApiBase().post(context, "/api/verifyOtp", null, body, "").then((val) {
      setState(() {
        loading = false;
      });

      if (val.statusCode == 200) {
        // var data = json.decode(val.body);
        UserResponseModel userInfo = userResponseModelFromJson(val.body);
        if (userInfo.partyDetail.firstName != null) {
          saveCurrentLogin(userInfo, widget.phoneNumber).then((onValue) {
            print(widget.phoneNumber);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => MainScreen(
                    userId: userInfo.partyDetail.partyId,
                    userName: userInfo.partyDetail.firstName,
                    userToken: userInfo.basicAuth,
                    userPhoneNum: widget.phoneNumber,
                    roleAlert: true,
                  ),
                ),
                ModalRoute.withName('sad'));
          });
        }
        if (userInfo.partyDetail.firstName == null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProfileScreen(
                userInfo: userInfo,
                phoneNumber: widget.phoneNumber,
              ),
            ),
          );
        }
      }
    });
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
                          "assets/images/LoginScreen/receiveOtp.png",
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
                            //"OTP Verification",
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
                            MyLocalizations.of(context).word(
                                "enterOtpManuallyIfWeFailToDetectItAutomatically",
                                "Enter OTP manually in case we fail to detect automatically"),
                            // "Enter OTP manually in case we fail to detect automatically",
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
                            controller: otpController,
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
                                  color: Color(0xFF0047C4),
                                  child: MaterialButton(
                                    child: Text(
                                      "Verify & Proceed",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: loading ? null : verifyOtp,
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
              ),
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
