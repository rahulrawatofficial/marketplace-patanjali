// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'package:razorpay_flutter/razorpay_flutter.dart';

// import 'package:fluttertoast/fluttertoast.dart';

// class MandiBhavScreen extends StatefulWidget {
//   @override
//   _MandiBhavScreenState createState() => _MandiBhavScreenState();
// }

// class _MandiBhavScreenState extends State<MandiBhavScreen> {
//   static const platform = const MethodChannel("razorpay_flutter");

//   Razorpay _razorpay;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Razorpay'),
//         ),
//         body: Center(
//             child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//               RaisedButton(onPressed: openCheckout, child: Text('Open'))
//             ])),
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _razorpay.clear();
//   }

//   void openCheckout() async {
//     var options = {
//       'key': 'rzp_test_1DP5mmOlF5G5ag',
//       'amount': 2000,
//       'name': 'Acme Corp.',
//       'description': 'Fine T-Shirt',
//       'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
//       'external': {
//         'wallets': ['paytm']
//       }
//     };

//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       debugPrint(e);
//     }
//   }

//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     Fluttertoast.showToast(
//       msg: "SUCCESS: " + response.paymentId,
//     );
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     Fluttertoast.showToast(
//         msg: "ERROR: " + response.code.toString() + " - " + response.message);
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName);
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MandiBhavScreen extends StatefulWidget {
  @override
  _MandiBhavScreenState createState() => _MandiBhavScreenState();
}

class _MandiBhavScreenState extends State<MandiBhavScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              "MandiBhav Screen",
            ),
          ],
        ),
      ),
    );
  }
}
