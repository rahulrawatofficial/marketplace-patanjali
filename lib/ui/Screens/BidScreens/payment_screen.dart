import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:marketplace_patanjali/Functions/error_handling.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';
import 'package:marketplace_patanjali/LanguageSetup/localizations.dart';
import 'package:marketplace_patanjali/Models/add_bid_model.dart';
import 'package:marketplace_patanjali/Models/category_model.dart';
import 'package:marketplace_patanjali/Models/create_cart_order_model.dart';
import 'package:marketplace_patanjali/Models/primary_category_model.dart';
import 'package:marketplace_patanjali/Models/razoe_pay_model.dart';
import 'package:marketplace_patanjali/Models/store_cart_order_model.dart';
import 'package:marketplace_patanjali/Models/variety_model.dart';
import 'package:marketplace_patanjali/resources/http_requests.dart';
import 'package:marketplace_patanjali/ui/Screens/cart_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/order_history_screen.dart';
import 'package:marketplace_patanjali/ui/Widgets/payment_type_alert.dart';
import 'package:marketplace_patanjali/ui/Widgets/photo_view.dart';
import 'package:marketplace_patanjali/ui/Widgets/title_app_bar.dart';
import 'package:marketplace_patanjali/ui/Widgets/user_drawer.dart';
import 'package:marketplace_patanjali/ui/Widgets/widget_methods.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final String userToken;
  final String userId;
  final String custRequestId;
  final double bidQuantity;
  final double bidAmount;
  final String payNow;
  final String quoteId;

  final String userName;
  final String userPhoneNum;
  final String inventoryItemId;
  final String fixedProduct;

  const PaymentScreen({
    Key key,
    this.userToken,
    this.userId,
    this.custRequestId,
    this.bidQuantity,
    this.bidAmount,
    this.payNow,
    this.quoteId,
    this.userName,
    this.userPhoneNum,
    this.inventoryItemId,
    this.fixedProduct,
  }) : super(key: key);
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String title = "Annadata MarketPlace";
  Color titleColor = Color(0xFF009D37);
  Color textColor = Color(0xFF009D37);
  Color barColor = Colors.white;

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

  TextEditingController quantityController = TextEditingController();
  TextEditingController bidController = TextEditingController();

  ApiBase _apiBase = ApiBase();
  var adData;
  bool connetion = false;
  String orderId;
  String orderIdRazor;
  String sellerName = "Seller";
  String sellerContact;
  String locationName;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const platform = const MethodChannel("razorpay_flutter");

  Razorpay _razorpay;
  String paymentStatus;
  String emailId;
  String phoneNum;
  String bidId;
  bool paymentViaWallet = false;
  bool cashBool = false;
  bool chequeBool = false;
  bool ddBool = false;
  String cartId;

  void confirmOrder(BuildContext context, String mode) {
    String title = mode != "Pay on Delivery" ? mode : "Pay on Delivery";
//flutter define function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        //return object of type dialoge
        return AlertDialog(
          title: new Text("Confirm Order"),
          content: new Text("Do you want place order and pay through $title"),
          actions: <Widget>[
            FlatButton(
              child: new Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                if (mode == "Account") {
                  createOrder(
                      widget.bidQuantity.toInt(), widget.bidAmount.toInt());
                }
                if (mode == "Wallet") {
                  walletOrder(
                      widget.bidQuantity.toInt(), widget.bidAmount.toInt());
                }
                if (mode == "Pay on Delivery") {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return PaymentTypeAlert(
                          codOrder: codPaymentOrder,
                          userToken: widget.userToken,
                        );
                      });
                  // codOrder(
                  //     widget.bidQuantity.toInt(), widget.bidAmount.toInt());
                }
              },
            )
          ],
        );
      },
    );
  }

  void orderAlert(BuildContext context, String mode, String message) {
//flutter define function
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        //return object of type dialoge
        return AlertDialog(
          // title: new Text("Confirm Order"),
          content: new Text("$message"),
          actions: <Widget>[
            FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => OrderHistoryScreen(
                            userId: widget.userId,
                            // userName: userName,
                            userToken: widget.userToken,
                            // userPhoneNum: userPhoneNum,
                          )),
                );
              },
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    paymentStatus = widget.payNow;
    print("@@${widget.payNow}@@");
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    print("^^^^^${widget.custRequestId}");
    print("^^^^^${widget.payNow}");
    var param = widget.fixedProduct == "N"
        ? {
            "custRequestId": widget.custRequestId,
            "inventoryItemId": widget.inventoryItemId,
            "partyId": widget.userId
          }
        : {
            "inventoryItemId": widget.inventoryItemId,
            "partyId": widget.userId,
          };
    // var param = {
    //   "custRequestId": widget.custRequestId,
    //   "partyId": widget.userId
    // };
    _apiBase
        .get(context, "/api/getRequestDetailById", param, widget.userToken)
        .then((val) {
      print("##${val.body}##");
      // print("---${adData["custRequestResult"][0]["cartItem"]}---");
      var data = json.decode(val.body);
      setState(() {
        adData = data;
        sellerName = adData["custRequestResult"][0]["sellerName"];
        sellerContact = adData["custRequestResult"][0]["sellerPhoneNumber"];
        bidId = adData["custRequestResult"][0]["bidId"];
        connetion = true;
        cartId = adData["custRequestResult"][0]["cartItemId"];
        // locationName =
        //     "${adData["custRequestResult"][0]["locationDetail"]["district"]}, ${adData["custRequestResult"][0]["locationDetail"]["state"]}";
      });
      print("----$cartId----");
      if (adData["custRequestResult"][0]["locationDetail"]["latitude"] !=
              null &&
          adData["custRequestResult"][0]["locationDetail"]["longitude"] !=
              null) {
        setState(() {
          locationName =
              "${adData["custRequestResult"][0]["locationDetail"]["district"]}, ${adData["custRequestResult"][0]["locationDetail"]["state"]}";
        });
        // getAddressName(
        //         adData["custRequestResult"][0]["locationDetail"]["latitude"],
        //         adData["custRequestResult"][0]["locationDetail"]["longitude"])
        //     .then((locVal) {
        //   setState(() {
        //     locationName = locVal;
        //   });
        // });
      }
      // if (widget.quoteId == null &&
      //     adData["custRequestResult"][0]["bidId"] == null) {
      //   print("ADDING BID");
      //   ReqDataFixed reqData2 = ReqDataFixed(
      //     custRequestId: adData["custRequestResult"][0]["custRequestResult"]
      //         ["custRequestId"],
      //     partyId: widget.userId,
      //   );
      //   AddBidModelFixed body = AddBidModelFixed(reqData: reqData2);
      //   // d
      //   ApiBase()
      //       .post(context, "/api/createQuoteFromRequest", null, body,
      //           widget.userToken)
      //       .then((val) {
      //     print(json.encode(body));
      //     if (val.statusCode == 200) {
      //       var d = json.decode(val.body);
      //       if (d["errorMessage"] == null) {
      //         print("##${val.body}##");
      //         var d = json.decode(val.body);
      //         _apiBase
      //             .get(context, "/api/getRequestDetailById", param,
      //                 widget.userToken)
      //             .then((valN) {
      //           print("##${valN.body}##");
      //           var dataN = json.decode(valN.body);
      //           setState(() {
      //             adData = dataN;
      //             sellerName = adData["custRequestResult"][0]["sellerName"];
      //             sellerContact = adData["custRequestResult"][0]
      //                 ["custRequestResult"]["lastModifiedByUserLogin"];
      //             bidId = adData["custRequestResult"][0]["bidId"];
      //             connetion = true;
      //           });
      //         });
      //         setState(() {
      //           bidId = d["quoteId"];
      //         });
      //       } else {
      //         ErrorHandling()
      //             .showErrorDailog(context, "Error", d["errorMessage"]);
      //       }
      //     }
      //   });
      //   print("^^^^^${adData["custRequestResult"][0]["bidId"]}");
      //   var param1 = {"partyId": widget.userId};
      //   _apiBase
      //       .get(context, "/api/getUserDetail", param1, widget.userToken)
      //       .then((uVal) {
      //     var uData = json.decode(uVal.body);

      //     phoneNum = uData["userDetail"]["phoneNumber"]["contactNumber"];
      //     emailId = uData["userDetail"]["emailAddress"]["emailAddress"];
      //   });
      //   print("!${widget.payNow}!");
      // }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout(RazorPayModel paymentData) async {
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
    storePayment(widget.bidAmount.toInt(), response.paymentId, "Success");
    print("PaymentId: ${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message);
    storePayment(widget.bidAmount.toInt(), null, "Failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName);
    storePayment(widget.bidAmount.toInt(), null, "Failed");
  }

  Future walletOrder(int quantity, int amount) async {
    // var body = widget.quoteId != null
    //     ? {
    //         "amount":
    //             "${adData["custRequestResult"][0]["totalAmount"].toInt()}",
    //         "quantity": "$quantity",
    //         "custRequestId": adData["custRequestResult"][0]["custRequestResult"]
    //             ["custRequestId"],
    //         "quoteId": widget.quoteId,
    //         "inventoryItemId": widget.inventoryItemId,
    //       }
    //     : {
    //         "amount":
    //             "${adData["custRequestResult"][0]["totalAmount"].toInt()}",
    //         "quantity": "$quantity",
    //         "custRequestId": adData["custRequestResult"][0]["custRequestResult"]
    //             ["custRequestId"],
    //         "quoteId": bidId,
    //         "inventoryItemId": widget.inventoryItemId,
    //       };
    CreateCartOrderModel body = CreateCartOrderModel(
      inventoryItemDetail: [
        InventoryItemDetail(
          amount: "${adData["custRequestResult"][0]["totalAmount"].toInt()}",
          inventoryItemId: widget.inventoryItemId,
          quantity: "$quantity",
        )
      ],
      totalAmount: "${adData["custRequestResult"][0]["totalAmount"].toInt()}",
    );
    final response = await ApiBase()
        .post(context, "/api/paymentByWallet", null, body, widget.userToken);
    print("!!${response.statusCode}!!");
    print("!!${response.body}!!");
    if (response.statusCode == 200) {
      // setState(() {});
      // RazorPayModel paymData = razorPayModelFromJson(response.body);
      // orderIdRazor = paymData.responseData.id;
      // orderId = paymData.orderId;
      // print("OrderId: $orderId");
      var d = json.decode(response.body);

      if (d["responseMessage"] != "error") {
        setState(() {
          paymentStatus = "COMPLETED";
        });

        orderAlert(context, "mode", d["successMessage"]);
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //       builder: (context) => OrderHistoryScreen(
        //             userId: widget.userId,
        //             // userName: userName,
        //             userToken: widget.userToken,
        //             // userPhoneNum: userPhoneNum,
        //           )),
        // );
      }
    }
  }

  Future createOrder(int quantity, int amount) async {
    var body = widget.quoteId != null
        ? {
            "amount":
                "${adData["custRequestResult"][0]["totalAmount"].toInt()}",
            "quantity": "$quantity",
            "custRequestId": adData["custRequestResult"][0]["custRequestResult"]
                ["custRequestId"],
            "quoteId": widget.quoteId,
            "inventoryItemId": widget.inventoryItemId,
          }
        : {
            "amount":
                "${adData["custRequestResult"][0]["totalAmount"].toInt()}",
            "quantity": "$quantity",
            "custRequestId": adData["custRequestResult"][0]["custRequestResult"]
                ["custRequestId"],
            "quoteId": bidId,
            "inventoryItemId": widget.inventoryItemId,
          };
    final response = await ApiBase().post(
        context, "/api/createRazorPayOrder", null, body, widget.userToken);
    print("!!${response.statusCode}!!");
    print("!!${response.body}!!");
    if (response.statusCode == 200) {
      // setState(() {});
      RazorPayModel paymData = razorPayModelFromJson(response.body);
      orderIdRazor = paymData.responseData.id;
      orderId = paymData.orderId;
      print("OrderId: $orderId");
      openCheckout(paymData);
    }
  }

  Future storePayment(int amount, String paymentId, String status) async {
    print("OrderId: $orderId");
    // var body = {
    //   "amount": "${adData["custRequestResult"][0]["totalAmount"].toInt()}",
    //   "orderId": orderId,
    //   "partyId": widget.userId,
    //   "paymentId": paymentId,
    //   "paymentStatus": status
    // };
    StoreCartOrderModel body = StoreCartOrderModel(
      orderList: [
        OrderListStore(
          amount: "${adData["custRequestResult"][0]["totalAmount"].toInt()}",
          inventoryItemId: widget.inventoryItemId,
          orderId: orderId,
        )
      ],
      partyId: widget.userId,
      paymentId: paymentId,
      paymentStatus: status,
      // totalAmount: double.parse(cartItem.cartGrandTotal).toInt().toString(),
    );
    final response = await ApiBase().post(
        context, "/api/storeRazorPayPaymentId", null, body, widget.userToken);
    print("!!${response.statusCode}!!");
    print("!!${response.body}!!");
    if (response.statusCode == 200) {
      var responseJson = response.body;
      var d = json.decode(responseJson);

      if (d["responseMessage"] != "error") {
        if (status == "Success") {
          setState(() {
            paymentStatus = "COMPLETED";
          });
          orderAlert(context, "mode", d["successMessage"]);
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //       builder: (context) => OrderHistoryScreen(
          //             userId: widget.userId,
          //             // userName: userName,
          //             userToken: widget.userToken,
          //             // userPhoneNum: userPhoneNum,
          //           )),
          // );
        }
      }
    }
  }

  codPaymentOrder(String type) {
    codOrder(widget.bidQuantity.toInt(), widget.bidAmount.toInt(), type);
  }

  Future codOrder(int quantity, int amount, String paymnetType) async {
    // var body = widget.quoteId != null
    //     ? {
    //         "amount":
    //             "${adData["custRequestResult"][0]["totalAmount"].toInt()}",
    //         "quantity": "$quantity",
    //         "custRequestId": adData["custRequestResult"][0]["custRequestResult"]
    //             ["custRequestId"],
    //         "quoteId": widget.quoteId,
    //         "paymentMethodTypeId": paymnetType,
    //         "inventoryItemId": widget.inventoryItemId,
    //       }
    //     : {
    //         "amount":
    //             "${adData["custRequestResult"][0]["totalAmount"].toInt()}",
    //         "quantity": "$quantity",
    //         "custRequestId": adData["custRequestResult"][0]["custRequestResult"]
    //             ["custRequestId"],
    //         "quoteId": bidId,
    //         "paymentMethodTypeId": paymnetType,
    //         "inventoryItemId": widget.inventoryItemId,
    //       };
    // List<InventoryItemDetail> inventoryItemDetailList = [];
    // CreateCartOrderModel body = CreateCartOrderModel(
    //   inventoryItemDetail: [
    //     InventoryItemDetail(
    //       amount: "${adData["custRequestResult"][0]["totalAmount"].toInt()}",
    //       inventoryItemId: widget.inventoryItemId,
    //       quantity: "$quantity",
    //     )
    //   ],
    //   totalAmount: "${adData["custRequestResult"][0]["totalAmount"].toInt()}",
    // );
    CreateCartOrderModel body = CreateCartOrderModel(
      inventoryItemDetail: [
        InventoryItemDetail(
          amount: "${adData["custRequestResult"][0]["totalAmount"].toInt()}",
          inventoryItemId: widget.inventoryItemId,
          quantity: "$quantity",
          paymentMethodTypeId: paymnetType,
        )
      ],
      totalAmount: "${adData["custRequestResult"][0]["totalAmount"].toInt()}",
    );
    final response = await ApiBase()
        .post(context, "/api/paymentByCash", null, body, widget.userToken);
    print("!!${response.statusCode}!!");
    print("!!${response.body}!!");
    if (response.statusCode == 200) {
      // setState(() {});
      // RazorPayModel paymData = razorPayModelFromJson(response.body);
      // orderIdRazor = paymData.responseData.id;
      // orderId = paymData.orderId;
      // print("OrderId: $orderId");
      var d = json.decode(response.body);

      if (d["responseMessage"] != "error") {
        setState(() {
          paymentStatus = "COMPLETED";
        });

        orderAlert(context, "mode", d["successMessage"]);
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //       builder: (context) => OrderHistoryScreen(
        //             userId: widget.userId,
        //             // userName: userName,
        //             userToken: widget.userToken,
        //             // userPhoneNum: userPhoneNum,
        //           )),
        // );
        // ErrorHandling()
        //     .showErrorDailog(context, "Order Placed", d["successMessage"]);
      }
      return d;
    }
  }

  Future addToCart(int quantity, int amount) async {
    var body = widget.quoteId != null
        ? {
            "reqData": {
              "partyId": widget.userId,
              "productId": adData["custRequestResult"][0]["custRequestResult"]
                  ["productId"],
              "inventoryItemId": widget.inventoryItemId,
              "quantity": "$quantity"
            }
          }
        : {
            "reqData": {
              "partyId": widget.userId,
              "productId": adData["custRequestResult"][0]["custRequestResult"]
                  ["productId"],
              "inventoryItemId": widget.inventoryItemId,
              "quantity": "$quantity"
            }
          };
    final response = await ApiBase()
        .post(context, "/api/addItemToCart", null, body, widget.userToken);
    print("!!${response.statusCode}!!");
    print("!!${response.body}!!");
    if (response.statusCode == 200) {
      var d = json.decode(response.body);

      if (d["responseMessage"] != "error") {
        setState(() {
          finalCartCount = d["totalItems"];
          cartId = d["cartItemId"];
        });
        Fluttertoast.showToast(msg: "Added to cart");
      }
      return d;
    }
  }

  void _showBottomSheet(context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (context) {
          return new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.account_balance),
                title: new Text('Pay Now'),
                onTap: () {
                  Navigator.of(context).pop();
                  confirmOrder(context, "Account");
                  // createOrder(
                  //     widget.bidQuantity.toInt(), widget.bidAmount.toInt());
                },
              ),
              new ListTile(
                leading: new Icon(Icons.account_balance_wallet),
                title: new Text('Pay via Wallet'),
                onTap: () {
                  Navigator.of(context).pop();
                  confirmOrder(context, "Wallet");
                  // walletOrder(
                  //     widget.bidQuantity.toInt(), widget.bidAmount.toInt());
                },
              ),
              new ListTile(
                leading: new Icon(Icons.departure_board),
                title: new Text('Pay on Delivery'),
                onTap: () {
                  Navigator.of(context).pop();
                  confirmOrder(context, "Pay on Delivery");
                  // codOrder(
                  //     widget.bidQuantity.toInt(), widget.bidAmount.toInt());
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return new Scaffold(
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
        centerTitle: false,
        actions: <Widget>[
          Stack(
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CartScreen(
                              userToken: widget.userToken,
                              userId: widget.userId,
                              // userName: widget.userName,
                              // userPhoneNum: widget.userPhoneNum,
                            )));
                  }),
              Positioned(
                  left: 25,
                  child: CircleAvatar(
                    child: Text(
                      "$finalCartCount",
                      style: TextStyle(fontSize: 12),
                    ),
                    radius: 9,
                    backgroundColor: Colors.red,
                  )),
            ],
          )
        ],
      ),
      drawer: UserDrawer(
        userId: widget.userId,
        userName: widget.userName,
        userPhoneNum: widget.userPhoneNum,
        userToken: widget.userToken,
      ),
      key: _scaffoldKey,
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // TitleAppBar(
            //   title: "Annadata",
            //   sContext: context,
            // ),
            connetion
                ? Expanded(
                    // width: cWidth,
                    // height: cHeight * 0.735,
                    // color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: cHeight * 0.12,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Ad by $sellerName",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                "Published on ${DateFormat("dd-MM-yyyy").format(DateTime.parse(adData["custRequestResult"][0]["custRequestDate"]))}",
                                style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.only(
                            left: cWidth * 0.01,
                            right: cWidth * 0.01,
                          ),
                          child: Form(
                            key: _formKey,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            adData["custRequestResult"][0]
                                                            ["images"]
                                                        .length >
                                                    0
                                                ? GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  PhotoViewScreen(
                                                                    imageUrl: adData["custRequestResult"][0]
                                                                            [
                                                                            "images"][0]
                                                                        [
                                                                        "imageUrl"],
                                                                  )));
                                                    },
                                                    child: FadeInImage
                                                        .assetNetwork(
                                                      placeholder:
                                                          "assets/images/imageplaceholder.png",
                                                      image:
                                                          adData["custRequestResult"]
                                                                  [0]["images"]
                                                              [0]["imageUrl"],
                                                      height: cHeight * 0.13,
                                                      width: cWidth * 0.3,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                : Image.asset(
                                                    "assets/images/imageplaceholder.png",
                                                    height: cHeight * 0.13,
                                                    width: cWidth * 0.3,
                                                    fit: BoxFit.cover,
                                                  ),
                                            Container(
                                              // color: Colors.grey,
                                              width: cWidth * 0.6,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        MyLocalizations.of(
                                                                    context)
                                                                .word(
                                                                    "primaryCategories",
                                                                    "Primary Categories") +
                                                            ":",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          color: textColor,
                                                        ),
                                                      ),
                                                      Text(
                                                        " ${adData["custRequestResult"][0]["primaryCategoryName"]}",
                                                        style: TextStyle(
                                                          // fontWeight: FontWeight.bold,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: cHeight * 0.01),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          MyLocalizations.of(
                                                                      context)
                                                                  .word(
                                                                      "category",
                                                                      "Category") +
                                                              ":",
                                                          style: TextStyle(
                                                            // fontWeight: FontWeight.bold,
                                                            fontSize: 14,
                                                            color: textColor,
                                                          ),
                                                        ),
                                                        Text(
                                                          " ${adData["custRequestResult"][0]["childCategoy"]}",
                                                          style: TextStyle(
                                                            // fontWeight: FontWeight.bold,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  adData["custRequestResult"][0]
                                                              ["cropName"] !=
                                                          null
                                                      ? Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: cHeight *
                                                                      0.01),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Text(
                                                                MyLocalizations.of(
                                                                            context)
                                                                        .word(
                                                                            "cropName",
                                                                            "Crop Name") +
                                                                    ":",
                                                                style:
                                                                    TextStyle(
                                                                  // fontWeight: FontWeight.bold,
                                                                  fontSize: 14,
                                                                  color:
                                                                      textColor,
                                                                ),
                                                              ),
                                                              Text(
                                                                " ${adData["custRequestResult"][0]["cropName"]}",
                                                                style:
                                                                    TextStyle(
                                                                  // fontWeight: FontWeight.bold,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Offstage(),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: cHeight * 0.01),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          MyLocalizations.of(
                                                                      context)
                                                                  .word(
                                                                      "variety",
                                                                      "Variety") +
                                                              ":",
                                                          style: TextStyle(
                                                            // fontWeight: FontWeight.bold,
                                                            fontSize: 14,
                                                            color: textColor,
                                                          ),
                                                        ),
                                                        Text(
                                                          " ${adData["custRequestResult"][0]["variety"]}",
                                                          style: TextStyle(
                                                            // fontWeight: FontWeight.bold,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: cHeight * 0.01),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          MyLocalizations.of(
                                                                      context)
                                                                  .word(
                                                                      "quality",
                                                                      "Quality") +
                                                              ":",
                                                          style: TextStyle(
                                                            // fontWeight: FontWeight.bold,
                                                            fontSize: 14,
                                                            color: textColor,
                                                          ),
                                                        ),
                                                        Text(
                                                          " ${adData["custRequestResult"][0]["custRequestResult"]["methodOfFarming"]}",
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
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: cHeight * 0.01),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                MyLocalizations.of(context)
                                                        .word("quantity",
                                                            "Quantity") +
                                                    ":",
                                                style: TextStyle(
                                                  // fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: textColor,
                                                ),
                                              ),
                                              Text(
                                                " ${adData["custRequestResult"][0]["custRequestResult"]["quantity"]} ${adData["custRequestResult"][0]["custRequestResult"]["unit"]}",
                                                style: TextStyle(
                                                  // fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        adData["custRequestResult"][0]
                                                        ["custRequestResult"]
                                                    ["fixedProduct"] ==
                                                "N"
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    top: cHeight * 0.01),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      MyLocalizations.of(context).word(
                                                              "minimumQuantity",
                                                              "Minimum Quantity") +
                                                          ":",
                                                      style: TextStyle(
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                    Text(
                                                      " ${adData["custRequestResult"][0]["custRequestResult"]["minimumQuantity"]} ${adData["custRequestResult"][0]["custRequestResult"]["minimumUnit"]} ",
                                                      style: TextStyle(
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Offstage(),
                                        adData["custRequestResult"][0]
                                                        ["custRequestResult"]
                                                    ["fixedProduct"] ==
                                                "N"
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    top: cHeight * 0.01),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      MyLocalizations.of(
                                                                  context)
                                                              .word(
                                                                  "minimumAmount",
                                                                  "Minimum Amount") +
                                                          ":",
                                                      style: TextStyle(
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                    Text(
                                                      " Rs. ${adData["custRequestResult"][0]["custRequestResult"]["minimumAmount"]}",
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
                                          padding: EdgeInsets.only(
                                              top: cHeight * 0.01),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
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
                                                "${adData["custRequestResult"][0]["custRequestResult"]["description"]}",
                                                style: TextStyle(
                                                  // fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        adData["custRequestResult"][0]
                                                        ["custRequestResult"]
                                                    ["fixedProduct"] ==
                                                "Y"
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    top: cHeight * 0.01),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      MyLocalizations.of(
                                                                  context)
                                                              .word(
                                                                  "fixedPrice",
                                                                  "Fixed Price") +
                                                          ":",
                                                      style: TextStyle(
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                    Text(
                                                      " Rs.${adData["custRequestResult"][0]["custRequestResult"]["maximumAmount"]} / ${adData["custRequestResult"][0]["custRequestResult"]["unitForFxiedPrice"]} ",
                                                      style: TextStyle(
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Offstage(),
                                        adData["custRequestResult"][0]
                                                        ["custRequestResult"]
                                                    ["amount"] !=
                                                null
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    top: cHeight * 0.01),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      "Amount:",
                                                      style: TextStyle(
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                    Text(
                                                      " Rs. ${adData["custRequestResult"][0]["custRequestResult"]["amount"].toInt()}",
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
                                          padding: EdgeInsets.only(
                                              top: cHeight * 0.01),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                MyLocalizations.of(context)
                                                        .word("availableFrom",
                                                            "Available from") +
                                                    ":",
                                                style: TextStyle(
                                                  // fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: textColor,
                                                ),
                                              ),
                                              Text(
                                                " ${DateFormat('dd-MM-yyyy').format(DateTime.parse(adData["custRequestResult"][0]["closedDateTime"]))}",
                                                style: TextStyle(
                                                  // fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        locationName != null
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    top: cHeight * 0.01),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      MyLocalizations.of(
                                                                  context)
                                                              .word("location",
                                                                  "Location") +
                                                          ": ",
                                                      style: TextStyle(
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: cWidth * 0.6,
                                                      child: Text(
                                                        "$locationName",
                                                        style: TextStyle(
                                                          // fontWeight: FontWeight.bold,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Offstage(),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: cHeight * 0.01),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Amount:",
                                                style: TextStyle(
                                                  // fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: textColor,
                                                ),
                                              ),
                                              Container(
                                                  width: cWidth * 0.55,
                                                  child: Text(
                                                    "  Rs. ${widget.bidAmount}",
                                                    style: TextStyle(
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        adData["custRequestResult"][0]
                                                        ["custRequestResult"]
                                                    ["fixedProduct"] !=
                                                "Y"
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    top: cHeight * 0.01),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      "Quantity:",
                                                      style: TextStyle(
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                    Container(
                                                        width: cWidth * 0.55,
                                                        child: Text(
                                                          "  ${widget.bidQuantity} ${adData["custRequestResult"][0]["custRequestResult"]["unit"]}",
                                                          style: TextStyle(
                                                            // fontWeight: FontWeight.bold,
                                                            fontSize: 12,
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              )
                                            : Offstage(),
                                        paymentStatus == "QUO_APPROVED" ||
                                                paymentStatus ==
                                                    "QUO_ORDERED" ||
                                                paymentStatus == "COMPLETED"
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    top: cHeight * 0.01),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      "Seller's Contact:",
                                                      style: TextStyle(
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                    Container(
                                                        width: cWidth * 0.5,
                                                        child: Text(
                                                          "  $sellerContact",
                                                          style: TextStyle(
                                                            // fontWeight: FontWeight.bold,
                                                            fontSize: 12,
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              )
                                            : Offstage(),
                                        // paymentStatus == "QUO_APPROVED" ||
                                        //         paymentStatus == "QUO_ORDERED"
                                        //     ? Padding(
                                        //         padding: EdgeInsets.only(
                                        //             top: cHeight * 0.05),
                                        //         child: Row(
                                        //           crossAxisAlignment:
                                        //               CrossAxisAlignment.center,
                                        //           mainAxisAlignment:
                                        //               MainAxisAlignment
                                        //                   .spaceBetween,
                                        //           children: <Widget>[
                                        //             Text(
                                        //               "Pay through wallet",
                                        //               style: TextStyle(
                                        //                 fontWeight:
                                        //                     FontWeight.bold,
                                        //                 fontSize: 13,
                                        //                 color: textColor,
                                        //               ),
                                        //             ),
                                        //             Checkbox(
                                        //                 activeColor: textColor,
                                        //                 materialTapTargetSize:
                                        //                     MaterialTapTargetSize
                                        //                         .shrinkWrap,
                                        //                 value: paymentViaWallet,
                                        //                 onChanged: (change) {
                                        //                   setState(() {
                                        //                     paymentViaWallet =
                                        //                         change;
                                        //                   });
                                        //                 })
                                        //           ],
                                        //         ),
                                        //       )
                                        //     : Offstage(),

                                        cartId != null
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    top: cHeight * 0.05),
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons
                                                            .check_circle_outline,
                                                        color: Colors.green,
                                                      ),
                                                      Text(
                                                        "Added to Cart",
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : paymentStatus == "QUO_APPROVED" &&
                                                    widget.fixedProduct == "Y"
                                                ? Padding(
                                                    padding: EdgeInsets.only(
                                                        top: cHeight * 0.01),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        RaisedButton(
                                                          child: Text(
                                                            "Add to Cart",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          color: Colors.green,
                                                          onPressed: () {
                                                            addToCart(
                                                                widget
                                                                    .bidQuantity
                                                                    .toInt(),
                                                                widget.bidAmount
                                                                    .toInt());
                                                            // _showBottomSheet(
                                                            //     context);
                                                            // paymentViaWallet
                                                            //     ? walletOrder(
                                                            //         widget
                                                            //             .bidQuantity
                                                            //             .toInt(),
                                                            //         widget.bidAmount
                                                            //             .toInt())
                                                            //     : createOrder(
                                                            //         widget
                                                            //             .bidQuantity
                                                            //             .toInt(),
                                                            //         widget.bidAmount
                                                            //             .toInt());
                                                            // openCheckout();
                                                            // _validate();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : paymentStatus ==
                                                            "QUO_APPROVED" &&
                                                        widget.fixedProduct ==
                                                            "N"
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: cHeight *
                                                                    0.01),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: <Widget>[
                                                            RaisedButton(
                                                              child: Text(
                                                                "Pay Now",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              color:
                                                                  Colors.green,
                                                              onPressed: () {
                                                                _showBottomSheet(
                                                                    context);
                                                              },
                                                            ),
                                                          ],
                                                        ))
                                                    : paymentStatus ==
                                                            "COMPLETED"
                                                        ? Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: cHeight *
                                                                        0.05),
                                                            child: Center(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  Icon(
                                                                    Icons
                                                                        .check_circle_outline,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                  Text(
                                                                    "Order Placed",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .green,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        : Offstage(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ],
        ),
      ),
    );
  }

  // void _validate() {
  //   if (_formKey.currentState.validate()) {
  //     print(adData["custRequestResult"][0]["fixedProduct"]);
  //     _formKey.currentState.save();
  //     ReqData reqData1 = ReqData(
  //       custRequestId: adData["custRequestResult"][0]["custRequestId"],
  //       partyId: widget.userId,
  //       quantity: quantityController.text,
  //       quoteUnitPrice: bidController.text,
  //     );
  //     AddBidModel addBid1 = AddBidModel(reqData: reqData1);

  //     ReqDataFixed reqData2 = ReqDataFixed(
  //       custRequestId: adData["custRequestResult"][0]["custRequestId"],
  //       partyId: widget.userId,
  //     );
  //     AddBidModelFixed addBid2 = AddBidModelFixed(reqData: reqData2);

  //     var body = adData["custRequestResult"][0]["fixedProduct"] != "Y"
  //         ? addBid1
  //         : addBid2;

  //     _apiBase
  //         .post(context, "/api/createQuoteFromRequest", null, body,
  //             widget.userToken)
  //         .then((val) {
  //       print(json.encode(body));
  //       if (val.statusCode == 200) {
  //         var d = json.decode(val.body);
  //         if (d["errorMessage"] == null) {
  //           print("##${val.body}##");
  //           var d = json.decode(val.body);
  //           showDialog(
  //               context: context,
  //               builder: (_) {
  //                 return MyDialog(
  //                   quoteId: d["quoteId"],
  //                   userToken: widget.userToken,
  //                 );
  //               });
  //         } else {
  //           ErrorHandling()
  //               .showErrorDailog(context, "Error", d["errorMessage"]);
  //         }
  //       }
  //     });
  //   }
  // }
}
