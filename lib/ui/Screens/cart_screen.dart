import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';
import 'package:marketplace_patanjali/LanguageSetup/localizations.dart';
import 'package:marketplace_patanjali/Models/cart_item_model.dart';
import 'package:marketplace_patanjali/Models/create_cart_order_model.dart';
import 'package:marketplace_patanjali/Models/razor_pay_cart_model.dart';
import 'package:marketplace_patanjali/Models/store_cart_order_model.dart';
import 'package:marketplace_patanjali/resources/http_requests.dart';
import 'package:marketplace_patanjali/ui/Screens/order_history_screen.dart';
import 'package:marketplace_patanjali/ui/Widgets/payment_type_alert_cart.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CartScreen extends StatefulWidget {
  final String userId;
  final String userToken;
  // final String userName;
  // final String userPhoneNum;

  const CartScreen({
    Key key,
    this.userToken,
    this.userId,
    //  this.userName, this.userPhoneNum,
  }) : super(key: key);
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String title = "Annadata MarketPlace";
  Color titleColor = Color(0xFF79CE1E);
  Color textColor = Color(0xFF0047C4);
  Color barColor = Colors.white;

  String location = "location";

  Razorpay _razorpay;
  String orderId;
  String orderIdRazor;
  String emailId;
  String phoneNum;
  int totalAmount;
  int quantity;
  RazorPayCartModel storeOrder;
  CartItemModel cartData;
  // String bidId;
  // bool paymentViaWallet = false;
  // bool cashBool = false;
  // bool chequeBool = false;
  // bool ddBool = false;
  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    var param1 = {"partyId": widget.userId};
    ApiBase()
        .get(context, "/api/getUserDetail", param1, widget.userToken)
        .then((uVal) {
      var uData = json.decode(uVal.body);

      phoneNum = uData["userDetail"]["phoneNumber"]["contactNumber"];
      emailId = uData["userDetail"]["emailAddress"]["emailAddress"];
    });
    // getAddress().then((val) {
    //   setState(() {
    //     location = val.locality;
    //   });
    // });
    // print("userTokenNew: $userToken");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
      msg: "SUCCESS: " + response.paymentId,
    );
    storePayment(response.paymentId, "Success");
    print("PaymentId: ${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message);
    storePayment(null, "Failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName);
    storePayment(null, "Failed");
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
    print(options);
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  Future createOrder(CartItemModel cartItem) async {
    print(cartItem.cartItemList[0].custRequestDetail.maximumAmount);
    print(cartItem.cartItemList[0].custRequestDetail.inventoryItemId);
    print(cartItem.cartItemList[0].custRequestDetail.quantity);
    print(cartItem.cartItemList[0].cartItemId);
    print(cartItem.cartItemList[0].cartItemSeqId);
    List<InventoryItemDetail> inventoryItemDetailList = [];
    for (int i = 0; i < cartItem.cartItemList.length; i++) {
      inventoryItemDetailList.add(InventoryItemDetail(
        amount:
            "${cartItem.cartItemList[i].custRequestDetail.maximumAmount.toInt()}",
        inventoryItemId:
            "${cartItem.cartItemList[i].custRequestDetail.inventoryItemId}",
        quantity: "${cartItem.cartItemList[i].custRequestDetail.quantity}",
        shoppingListId: "${cartItem.cartItemList[i].cartItemId}",
        shoppingListItemSeqId: "${cartItem.cartItemList[i].cartItemSeqId}",
      ));
    }
    CreateCartOrderModel body = CreateCartOrderModel(
      inventoryItemDetail: inventoryItemDetailList,
      totalAmount: double.parse(cartItem.cartGrandTotal).toInt().toString(),
    );
    final response = await ApiBase().post(
        context, "/api/createRazorPayOrder", null, body, widget.userToken);
    print("!!${response.statusCode}!!");
    print("!!${response.body}!!");
    if (response.statusCode == 200) {
      // setState(() {});
      RazorPayCartModel paymData = razorPayCartModelFromJson(response.body);
      storeOrder = paymData;
      orderIdRazor = paymData.responseData.id;
      // orderId = paymData.orderId;
      // print("OrderId: $orderId");
      openCheckout(paymData);
    }
  }

  Future storePayment(String paymentId, String status) async {
    print("OrderId: $orderId");
    List<OrderListStore> orderListStore = [];
    for (int i = 0; i < storeOrder.orderList.length; i++) {
      orderListStore.add(OrderListStore(
        amount: storeOrder.orderList[i].amount,
        inventoryItemId: storeOrder.orderList[i].inventoryItemId,
        orderId: storeOrder.orderList[i].orderId,
        shoppingListId: "${cartData.cartItemList[i].cartItemId}",
        shoppingListItemSeqId: "${cartData.cartItemList[i].cartItemSeqId}",
      ));
    }
    StoreCartOrderModel body = StoreCartOrderModel(
      orderList: orderListStore,
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
            // paymentStatus = "COMPLETED";
          });
          orderAlert(context, "mode", d["successMessage"]);
          // orderAlert(context, "mode", d["successMessage"]);
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

  Future addToWishlist(String productId, String custRequestId) async {
    var body = {
      "reqData": {
        "partyId": widget.userId,
        "productId": productId,
        "custRequestId": custRequestId,
      }
    };
    final response = await ApiBase()
        .post(context, "/api/addItemToWishList", null, body, widget.userToken);
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {});
    }
  }

  Future removeFromlist(String wishlistId, String wishListItemSeqId) async {
    var param = {
      "wishlistId": wishlistId,
      "wishListItemSeqId": wishListItemSeqId,
    };
    final response = await ApiBase().get(
        context, "/api/deleteWishListByWishListId", param, widget.userToken);
    print("WW${response.body}WW");
    if (response.statusCode == 200) {
      setState(() {});
    }
  }

  Future<CartItemModel> getAllAuctions() async {
    var param = {"partyId": widget.userId};
    final response = await ApiBase()
        .get(context, "/api/getCartItemByPartyId", param, widget.userToken);
    if (response != null) {
      debugPrint("Success");
      debugPrint(response.body);
      return cartItemModelFromJson(response.body);
    } else {
      return CartItemModel(
        cartItemList: [],
      );
    }
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

  Future walletOrder(CartItemModel cartItem) async {
    List<InventoryItemDetail> inventoryItemDetailList = [];
    for (int i = 0; i < cartItem.cartItemList.length; i++) {
      inventoryItemDetailList.add(InventoryItemDetail(
        amount:
            "${cartItem.cartItemList[i].custRequestDetail.maximumAmount.toInt()}",
        inventoryItemId:
            "${cartItem.cartItemList[i].custRequestDetail.inventoryItemId}",
        quantity: "${cartItem.cartItemList[i].custRequestDetail.quantity}",
        shoppingListId: "${cartItem.cartItemList[i].cartItemId}",
        shoppingListItemSeqId: "${cartItem.cartItemList[i].cartItemSeqId}",
      ));
    }
    CreateCartOrderModel body = CreateCartOrderModel(
      inventoryItemDetail: inventoryItemDetailList,
      totalAmount: double.parse(cartItem.cartGrandTotal).toInt().toString(),
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
          // paymentStatus = "COMPLETED";
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

  codPaymentOrder(String type, CartItemModel cartItem) {
    codOrder(cartItem, type);
  }

  void confirmOrder(BuildContext context, String mode, CartItemModel cartItem) {
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
                  createOrder(cartItem);
                }
                if (mode == "Wallet") {
                  walletOrder(cartItem);
                }
                if (mode == "Pay on Delivery") {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return PaymentTypeAlertCart(
                          codOrder: codPaymentOrder,
                          userToken: widget.userToken,
                          cartItemModel: cartItem,
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

  Future codOrder(CartItemModel cartItem, String type) async {
    List<InventoryItemDetail> inventoryItemDetailList = [];
    for (int i = 0; i < cartItem.cartItemList.length; i++) {
      inventoryItemDetailList.add(InventoryItemDetail(
        amount:
            "${cartItem.cartItemList[i].custRequestDetail.maximumAmount.toInt()}",
        inventoryItemId:
            "${cartItem.cartItemList[i].custRequestDetail.inventoryItemId}",
        quantity: "${cartItem.cartItemList[i].custRequestDetail.quantity}",
        paymentMethodTypeId: type,
        shoppingListId: "${cartItem.cartItemList[i].cartItemId}",
        shoppingListItemSeqId: "${cartItem.cartItemList[i].cartItemSeqId}",
      ));
    }
    CreateCartOrderModel body = CreateCartOrderModel(
      inventoryItemDetail: inventoryItemDetailList,
      totalAmount: double.parse(cartItem.cartGrandTotal).toInt().toString(),
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
          // paymentStatus = "COMPLETED";
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

  void _showBottomSheet(context, CartItemModel cartItem) {
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
                  confirmOrder(context, "Account", cartItem);
                  // createOrder(
                  //     widget.bidQuantity.toInt(), widget.bidAmount.toInt());
                },
              ),
              new ListTile(
                leading: new Icon(Icons.account_balance_wallet),
                title: new Text('Pay via Wallet'),
                onTap: () {
                  Navigator.of(context).pop();
                  confirmOrder(context, "Wallet", cartItem);
                  // walletOrder(
                  //     widget.bidQuantity.toInt(), widget.bidAmount.toInt());
                },
              ),
              new ListTile(
                leading: new Icon(Icons.departure_board),
                title: new Text('Pay on Delivery'),
                onTap: () {
                  Navigator.of(context).pop();
                  confirmOrder(context, "Pay on Delivery", cartItem);
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
    void errorDailogDisplay(
        BuildContext context, String wishlistId, String wishListItemSeqId) {
//flutter define function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          //return object of type dialoge
          return AlertDialog(
            title: new Text("Remove?"),
            content: new Text("Are you sure to remove this item from cart"),
            actions: <Widget>[
              FlatButton(
                child: new Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  removeFromlist(wishlistId, wishListItemSeqId).then((val) {
                    Navigator.of(context).pop();
                  });
                },
              )
            ],
          );
        },
      );
    }

    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return new Scaffold(
      // drawer: UserDrawer(
      //   userId: widget.userId,
      //   userName: widget.userName,
      //   userPhoneNum: widget.userPhoneNum,
      //   userToken: widget.userToken,
      // ),
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
        // centerTitle: false,
        // actions: <Widget>[
        //   Padding(
        //     padding: EdgeInsets.only(right: 10),
        //     child: Row(
        //       children: <Widget>[
        //         Icon(
        //           Icons.location_on,
        //           color: Colors.black,
        //           size: 18,
        //         ),
        //         Text(
        //           MyLocalizations.of(context).word("$location", "$location"),
        //           style: TextStyle(color: Colors.black, fontSize: 12),
        //         ),
        //       ],
        //     ),
        //   )
        // ],
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: getAllAuctions(),
          builder: (context, AsyncSnapshot<CartItemModel> snapshot) {
            if (snapshot.hasData == true) {
              if (!snapshot.hasError) {
                if (snapshot.data.cartItemList.length != 0) {
                  cartData = snapshot.data;
                  double tAmount = double.parse(snapshot.data.cartGrandTotal);
                  totalAmount = tAmount.toInt();
                  quantity = snapshot.data.cartItemList.length;
                  return Center(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: ListView.builder(
                                  itemCount: snapshot.data.cartItemList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: cHeight * 0.01,
                                        // left: cWidth * 0.05,
                                        // right: cWidth * 0.05,
                                      ),
                                      child: GestureDetector(
                                        // onTap: () {
                                        //   snapshot
                                        //               .data
                                        //               .cartItemList[index]
                                        //               .custRequestDetail
                                        //               .fixedProduct ==
                                        //           "N"
                                        //       ? Navigator.of(context).push(
                                        //           MaterialPageRoute(
                                        //               builder: (context) =>
                                        //                   AddBidScreen(
                                        //                     userId:
                                        //                         widget.userId,
                                        //                     userToken: widget
                                        //                         .userToken,
                                        //                     custRequestId: snapshot
                                        //                         .data
                                        //                         .cartItemList[
                                        //                             index]
                                        //                         .custRequestDetail
                                        //                         .i,
                                        //                     addBidOp: true,
                                        //                     userName:
                                        //                         widget.userName,
                                        //                     userPhoneNum: widget
                                        //                         .userPhoneNum,
                                        //                     fixedProduct: snapshot
                                        //                         .data
                                        //                         .requestList[
                                        //                             index]
                                        //                         .custRequestDetail
                                        //                         .fixedProduct,
                                        //                     inventoryItemId: snapshot
                                        //                         .data
                                        //                         .requestList[
                                        //                             index]
                                        //                         .custRequestDetail
                                        //                         .inventoryItemId,
                                        //                   )),
                                        //         )
                                        //       : Navigator.of(context).push(
                                        //           MaterialPageRoute(
                                        //               builder: (context) =>
                                        //                   PaymentScreen(
                                        //                     userId:
                                        //                         widget.userId,
                                        //                     userToken: widget
                                        //                         .userToken,
                                        //                     custRequestId: snapshot
                                        //                         .data
                                        //                         .requestList[
                                        //                             index]
                                        //                         .custRequestDetail
                                        //                         .custRequestId,
                                        //                     bidAmount: snapshot
                                        //                         .data
                                        //                         .requestList[
                                        //                             index]
                                        //                         .custRequestDetail
                                        //                         .maximumAmount,
                                        //                     bidQuantity: snapshot
                                        //                         .data
                                        //                         .requestList[
                                        //                             index]
                                        //                         .custRequestDetail
                                        //                         .quantity,
                                        //                     payNow:
                                        //                         "QUO_APPROVED",
                                        //                     userName:
                                        //                         widget.userName,
                                        //                     userPhoneNum: widget
                                        //                         .userPhoneNum,
                                        //                     fixedProduct: snapshot
                                        //                         .data
                                        //                         .requestList[
                                        //                             index]
                                        //                         .custRequestDetail
                                        //                         .fixedProduct,
                                        //                     inventoryItemId: snapshot
                                        //                         .data
                                        //                         .requestList[
                                        //                             index]
                                        //                         .custRequestDetail
                                        //                         .inventoryItemId,
                                        //                     // quoteId: snapshot
                                        //                     //     .data
                                        //                     //     .requestList[index]
                                        //                     //     .,
                                        //                   )),
                                        //         );
                                        // },
                                        child: Card(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              // bottom: cHeight * 0.01,
                                              left: cWidth * 0.02,
                                              right: cWidth * 0.02,
                                              top: cHeight * 0.005,
                                              bottom: cHeight * 0.005,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                // Column(
                                                //   crossAxisAlignment:
                                                //       CrossAxisAlignment.start,
                                                //   children: <Widget>[
                                                //     snapshot
                                                //                 .data
                                                //                 .cartItemList[
                                                //                     index]
                                                //                 .images
                                                //                 .length >
                                                //             0
                                                //         ? CachedNetworkImage(
                                                //             imageUrl: snapshot
                                                //                 .data
                                                //                 .requestList[
                                                //                     index]
                                                //                 .images[0]
                                                //                 .imageUrl,
                                                //             height:
                                                //                 cHeight * 0.18,
                                                //             width:
                                                //                 cWidth * 0.37,
                                                //             fit: BoxFit.cover,
                                                //             placeholder:
                                                //                 (context,
                                                //                         url) =>
                                                //                     Image.asset(
                                                //               "assets/images/imageplaceholder.png",
                                                //               height: cHeight *
                                                //                   0.18,
                                                //               width:
                                                //                   cWidth * 0.37,
                                                //               fit: BoxFit.cover,
                                                //             ),
                                                //             errorWidget:
                                                //                 (context, url,
                                                //                         error) =>
                                                //                     Image.asset(
                                                //               "assets/images/imageplaceholder.png",
                                                //               height: cHeight *
                                                //                   0.18,
                                                //               width:
                                                //                   cWidth * 0.37,
                                                //               fit: BoxFit.cover,
                                                //             ),
                                                //           )
                                                //         : Image.asset(
                                                //             "assets/images/imageplaceholder.png",
                                                //             height:
                                                //                 cHeight * 0.18,
                                                //             width:
                                                //                 cWidth * 0.37,
                                                //             fit: BoxFit.cover,
                                                //           ),
                                                //     // : Image.asset(
                                                //     //     "assets/images/test_image.jpg"),

                                                //     // Divider(),
                                                //   ],
                                                // ),
                                                Image.asset(
                                                  "assets/images/imageplaceholder.png",
                                                  height: cHeight * 0.18,
                                                  width: cWidth * 0.37,
                                                  fit: BoxFit.cover,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    left: cWidth * 0.01,
                                                    right: cHeight * 0.005,
                                                  ),
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          width: cWidth * 0.54,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: <Widget>[
                                                              GestureDetector(
                                                                onTap: () {
                                                                  errorDailogDisplay(
                                                                      context,
                                                                      snapshot
                                                                          .data
                                                                          .cartItemList[
                                                                              index]
                                                                          .cartItemId,
                                                                      snapshot
                                                                          .data
                                                                          .cartItemList[
                                                                              index]
                                                                          .cartItemSeqId);
                                                                },
                                                                child: Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red,
                                                                  size: 15,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            snapshot
                                                                        .data
                                                                        .cartItemList[
                                                                            index]
                                                                        .sellerName !=
                                                                    null
                                                                ? Text(
                                                                    "Posted by ${snapshot.data.cartItemList[index].sellerName.split(" ")[0]}",
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          titleColor,
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  )
                                                                : Text(
                                                                    MyLocalizations.of(
                                                                            context)
                                                                        .word(
                                                                            "postBySeller",
                                                                            "Posted by seller"),
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          titleColor,
                                                                      fontSize:
                                                                          11,
                                                                    ),
                                                                  ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: cWidth *
                                                                          0.02),
                                                              child: Text(
                                                                "(${snapshot.data.cartItemList[index].productUploadTime} ago)",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 9,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
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
                                                                      "Category"),
                                                              style: TextStyle(
                                                                fontSize: 11,
                                                                color:
                                                                    titleColor,
                                                              ),
                                                            ),
                                                            Text(
                                                              " ${snapshot.data.cartItemList[index].categoryName} ",
                                                              style: TextStyle(
                                                                fontSize: 11,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            Text(
                                                              MyLocalizations.of(
                                                                          context)
                                                                      .word(
                                                                          "variety",
                                                                          "Variety") +
                                                                  ":",
                                                              style: TextStyle(
                                                                fontSize: 11,
                                                                color:
                                                                    titleColor,
                                                              ),
                                                            ),
                                                            Text(
                                                              " ${snapshot.data.cartItemList[index].variety}",
                                                              style: TextStyle(
                                                                fontSize: 11,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        snapshot
                                                                    .data
                                                                    .cartItemList[
                                                                        index]
                                                                    .custRequestDetail
                                                                    .description !=
                                                                null
                                                            ? Padding(
                                                                padding: EdgeInsets.only(
                                                                    top: cHeight *
                                                                        0.01),
                                                                child:
                                                                    Container(
                                                                  width:
                                                                      cWidth *
                                                                          0.53,
                                                                  height:
                                                                      cHeight *
                                                                          0.06,
                                                                  child: Text(
                                                                    "${snapshot.data.cartItemList[index].custRequestDetail.description}",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          800],
                                                                      fontSize:
                                                                          11,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : Padding(
                                                                padding: EdgeInsets.only(
                                                                    top: cHeight *
                                                                        0.01),
                                                                child:
                                                                    Container(
                                                                  width:
                                                                      cWidth *
                                                                          0.53,
                                                                  height:
                                                                      cHeight *
                                                                          0.06,
                                                                )),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: cHeight *
                                                                      0.01),
                                                          child: Container(
                                                            width:
                                                                cWidth * 0.54,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "${snapshot.data.cartItemList[index].custRequestDetail.methodOfFarming}    ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color:
                                                                          titleColor),
                                                                ),
                                                                // Container(
                                                                //   decoration:
                                                                //       BoxDecoration(
                                                                //     color: Color(
                                                                //         0xFF94BC19),
                                                                //     borderRadius:
                                                                //         BorderRadius
                                                                //             .circular(4),
                                                                //   ),
                                                                //   // width:
                                                                //   //     cWidth * 0.25,
                                                                //   child:
                                                                //       Padding(
                                                                //     padding:
                                                                //         const EdgeInsets.all(
                                                                //             4.0),
                                                                //     child: snapshot.data.cartItemList[index].custRequestDetail.fixedProduct ==
                                                                //             "N"
                                                                //         ? Text(
                                                                //             MyLocalizations.of(context).word("bidNow",
                                                                //                 "Bid Now"),
                                                                //             textAlign:
                                                                //                 TextAlign.end,
                                                                //             style:
                                                                //                 TextStyle(
                                                                //               color: Colors.white,
                                                                //               // color:
                                                                //               //     Color(0xFF1144A6),
                                                                //               fontWeight: FontWeight.w600,
                                                                //               fontSize: 13,
                                                                //             ),
                                                                //           )
                                                                //         : Text(
                                                                //             "Buy Now",
                                                                //             textAlign:
                                                                //                 TextAlign.end,
                                                                //             style:
                                                                //                 TextStyle(
                                                                //               color: Colors.white,
                                                                //               // color:
                                                                //               //     Color(0xFF1144A6),
                                                                //               fontWeight: FontWeight.w600,
                                                                //               fontSize: 13,
                                                                //             ),
                                                                //           ),
                                                                //   ),
                                                                // ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        PhysicalModel(
                          color: Color(0xFF79CE1E),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: MaterialButton(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "${MyLocalizations.of(context).word("total", "Total")} Rs. ${snapshot.data.cartGrandTotal}",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        MyLocalizations.of(context)
                                            .word("payNow", "Pay now"),
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    // createOrder(snapshot.data);
                                    _showBottomSheet(context, snapshot.data);
                                    // _validate();
                                    // widget.onChangeCertificate();
                                    // Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Text("Your cart is empty"),
                  );
                }
              } else {
                return Center(
                  child: Text("No internet Connection"),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
