import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';
import 'package:marketplace_patanjali/LanguageSetup/localizations.dart';
import 'package:marketplace_patanjali/Models/razoe_pay_model.dart';
import 'package:marketplace_patanjali/Models/razor_pay_cart_model.dart';
import 'package:marketplace_patanjali/Models/transactions_model.dart';
import 'package:marketplace_patanjali/Models/wallet_history_model.dart';
import 'package:marketplace_patanjali/resources/http_requests.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class WalletScreen extends StatefulWidget {
  final String userId;
  final String userToken;
  final String userRole;
  final String userName;
  final String userPhoneNum;
  final String userProfilePic;

  const WalletScreen(
      {Key key,
      this.userId,
      this.userToken,
      this.userRole,
      this.userName,
      this.userPhoneNum,
      this.userProfilePic})
      : super(key: key);
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  String title = "Annadata MarketPlace";
  Color titleColor = Color(0xFF009D37);
  Color buttonColor = Color(0xFF0047C4);
  Color barColor = Color(0xFF009D37);
  bool loading = false;
  bool addingAmount = false;
  bool showHistory = false;
  var data;

  String orderId;
  String orderIdRazor;

  String paymentStatus;
  String emailId;
  String phoneNum;

  static const platform = const MethodChannel("razorpay_flutter");

  Razorpay _razorpay;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();

  Future getWalletDetail() async {
    setState(() {
      loading = true;
    });
    var param = {"partyId": widget.userId};
    final response = await ApiBase()
        .get(context, "/api/getBillingAccDetails", param, widget.userToken);
    if (response != null) {
      setState(() {
        loading = false;
      });
      debugPrint("Success");
      debugPrint(response.body);
      return json.decode(response.body);
    } else {
      setState(() {
        loading = false;
      });
      return null;
    }
  }

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getWalletDetail().then((val) {
      setState(() {
        data = val;
      });

      var param1 = {"partyId": widget.userId};
      ApiBase()
          .get(context, "/api/getUserDetail", param1, widget.userToken)
          .then((uVal) {
        var uData = json.decode(uVal.body);

        phoneNum = uData["userDetail"]["phoneNumber"]["contactNumber"];
        emailId = uData["userDetail"]["emailAddress"]["emailAddress"];
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout(RazorPayCartModel paymentData) async {
    // String testkey="rzp_test_GdnRWgQjPX2qQX";
    //String liveKey="rzp_live_VorkgrX7YnFt7x";
    var options = {
      'key': 'rzp_test_GdnRWgQjPX2qQX',
      'amount': paymentData.responseData.amount,
      'order_id': orderIdRazor,
      // 'fatherName': 'Father',
      // 'name': 'Crsops',
      // 'description': 'Premium Quality',
      'prefill': {'contact': phoneNum, 'email': emailId},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
      msg: "SUCCESS: " + response.paymentId,
    );
    storePayment(
        int.parse(amountController.text), response.paymentId, "Success");
    print("PaymentId: ${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message);
    storePayment(int.parse(amountController.text), null, "Failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName);
    storePayment(int.parse(amountController.text), null, "Failed");
  }

  Future createOrder() async {
    var body = {
      "totalAmount": amountController.text,
      // "quantity": "1",
    };
    final response = await ApiBase().post(context,
        "/api/createWalletRazorPayOrder", null, body, widget.userToken);
    print("!!${response.statusCode}!!");
    print("!!${response.body}!!");
    if (response.statusCode == 200) {
      // setState(() {});
      RazorPayCartModel paymData = razorPayCartModelFromJson(response.body);
      orderIdRazor = paymData.responseData.id;
      orderId = paymData.orderId;
      print("OrderId: $orderId");
      openCheckout(paymData);
    }
  }

  Future storePayment(int amount, String paymentId, String status) async {
    print("OrderId: $orderId");
    var body = {
      "amount": amountController.text,
      "orderId": orderId,
      "partyId": widget.userId,
      "paymentId": paymentId,
      "paymentStatus": status
    };
    final response = await ApiBase().post(
        context, "/api/addBalanceByRazorPay", null, body, widget.userToken);
    print("!!${response.statusCode}!!");
    print("!!${response.body}!!");
    if (response.statusCode == 200) {
      var responseJson = response.body;
      var d = json.decode(responseJson);

      if (d["responseMessage"] != "error") {
        if (status == "Success") {
          setState(() {
            paymentStatus = "COMPLETED";
            addingAmount = false;
          });
          getWalletDetail().then((val) {
            setState(() {
              data = val;
            });
          });
        }
      }
    }
  }

  Future<WalletHistoryModel> getAllAuctions() async {
    var param = {
      "partyId": widget.userId,
    };
    final response = await ApiBase().get(
        context, "/api/getWalletHistoryByPartyId", param, widget.userToken);
    if (response != null) {
      debugPrint("Success");
      debugPrint(response.body);
      return walletHistoryModelFromJson(response.body);
    } else {
      return WalletHistoryModel(
        walletTransactionList: [],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
      ),
      body: !loading
          ? SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.only(left: cWidth * 0.02, right: cWidth * 0.02),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          width: cWidth,
                          height: cHeight * 0.3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.account_balance_wallet,
                                color: Colors.grey[700],
                                size: 80,
                              ),
                              Text(
                                "Wallet Balance",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 24),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: cHeight * 0.02),
                                child: Text(
                                  "₹ ${data["balance"]}",
                                  style: TextStyle(
                                      color: Colors.grey[700], fontSize: 24),
                                ),
                              ),
                            ],
                          )),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    addingAmount = addingAmount ? false : true;
                                  });
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Add Balance",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      addingAmount
                                          ? Icon(Icons.arrow_drop_up)
                                          : Icon(Icons.arrow_drop_down),
                                    ],
                                  ),
                                ),
                              ),
                              addingAmount
                                  ? TextFormField(
                                      controller: amountController,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value.length == 0) {
                                          return ('Enter Amount');
                                        } else {
                                          return null;
                                        }
                                      },
                                    )
                                  : Offstage(),
                              addingAmount
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: RaisedButton(
                                              color: Colors.green,
                                              child: Text(
                                                MyLocalizations.of(context)
                                                    .word("add", "Add"),
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onPressed: () {
                                                _validate();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Offstage()
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showHistory = showHistory ? false : true;
                                  });
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Transaction History",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      showHistory
                                          ? Icon(Icons.arrow_drop_up)
                                          : Icon(Icons.arrow_drop_down),
                                    ],
                                  ),
                                ),
                              ),
                              showHistory
                                  ? Container(
                                      height: cHeight * 0.5,
                                      child: FutureBuilder(
                                          future: getAllAuctions(),
                                          builder: (context,
                                              AsyncSnapshot<WalletHistoryModel>
                                                  snapshot) {
                                            if (snapshot.hasData == true) {
                                              if (!snapshot.hasError) {
                                                if (snapshot
                                                        .data
                                                        .walletTransactionList
                                                        .length !=
                                                    0) {
                                                  return ListView.builder(
                                                    itemCount: snapshot
                                                        .data
                                                        .walletTransactionList
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          bottom:
                                                              cHeight * 0.01,
                                                          // left: cWidth * 0.05,
                                                          // right: cWidth * 0.05,
                                                        ),
                                                        child: Card(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              // bottom: cHeight * 0.01,
                                                              left:
                                                                  cWidth * 0.02,
                                                              right:
                                                                  cWidth * 0.02,
                                                            ),
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    top: cHeight *
                                                                        0.02,
                                                                    bottom:
                                                                        cHeight *
                                                                            0.02,
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                        width: cWidth *
                                                                            0.6,
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: <
                                                                              Widget>[
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  "Added to Wallet",
                                                                                  style: TextStyle(
                                                                                    color: Colors.green,
                                                                                    fontSize: 14,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.only(top: 8.0),
                                                                              child: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    "Amount: ",
                                                                                    style: TextStyle(
                                                                                      fontSize: 14,
                                                                                      color: Colors.blue,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    " ${snapshot.data.walletTransactionList[index].amount} ",
                                                                                    style: TextStyle(
                                                                                      fontSize: 13,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: <
                                                                            Widget>[
                                                                          Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.end,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            children: <Widget>[],
                                                                          ),
                                                                          Text(
                                                                            "${snapshot.data.walletTransactionList[index].gatewayCode}",
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: snapshot.data.walletTransactionList[index].gatewayCode == "COMPLETED" ? Colors.green : Colors.red,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                // Divider(),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                } else {
                                                  return Center(
                                                    child: Text(
                                                        "No transaction found"),
                                                  );
                                                }
                                              } else {
                                                return Center(
                                                  child: Text(
                                                      "No internet Connection"),
                                                );
                                              }
                                            } else {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                          }),
                                    )
                                  : Offstage()
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void _validate() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      createOrder();
    }
  }
}
