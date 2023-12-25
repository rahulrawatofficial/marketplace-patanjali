import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';
import 'package:marketplace_patanjali/LanguageSetup/localizations.dart';
import 'package:marketplace_patanjali/Models/AuctionModel/auction_model.dart';
import 'package:marketplace_patanjali/resources/http_requests.dart';
import 'package:marketplace_patanjali/ui/Screens/MyAds/ad_detail_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/MyAds/buy_ads_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/MyAds/dkd_products_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/MyAds/recent_activity_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/MyAds/selling_ads_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/cart_screen.dart';
import 'package:marketplace_patanjali/ui/Widgets/user_drawer.dart';

class MyAdScreen extends StatefulWidget {
  final void Function(String, String, String) postAd;
  final String userToken;
  final String userId;
  final String userPhoneNum;
  final String userName;
  const MyAdScreen({
    Key key,
    this.userToken,
    this.userId,
    this.postAd,
    this.userPhoneNum,
    this.userName,
  }) : super(key: key);
  @override
  _MyAdScreenState createState() => _MyAdScreenState();
}

class _MyAdScreenState extends State<MyAdScreen>
    with SingleTickerProviderStateMixin {
  String title = "Annadata MarketPlace";
  Color titleColor = Color(0xFF009D37);
  Color buttonColor = Color(0xFF0047C4);
  Color barColor = Color(0xFF062967);

  bool dkdProducts = false;
  TabController tabController;
  String location = "Location";

  @override
  void initState() {
    // getAddress().then((val) {
    //   setState(() {
    //     location = val.locality;
    //   });
    // });
    tabController = new TabController(length: 4, vsync: this);
    super.initState();
  }

  Future<UserAuctionModel> getMyAuctions() async {
    var param = {"partyId": widget.userId};
    final response = await ApiBase()
        .get(context, "/api/getRequestListByPartyId", param, widget.userToken);
    if (response != null) {
      debugPrint("Success");
      debugPrint(response.body);
      return userAuctionModelFromJson(response.body);
    } else {
      return UserAuctionModel(
        requestList: [],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: UserDrawer(
        userId: widget.userId,
        userName: widget.userName,
        userPhoneNum: widget.userPhoneNum,
        userToken: widget.userToken,
      ),
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
      body: Column(
        // Column
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Container(
              color: Theme.of(context)
                  .scaffoldBackgroundColor, // Tab Bar color change
              child: TabBar(
                // TabBar
                controller: tabController,
                unselectedLabelColor: Color(0xFFFFA100),
                labelColor: Color(0xFF79CE1E),
                indicatorWeight: 2,
                labelStyle: TextStyle(fontSize: 17),
                unselectedLabelStyle: TextStyle(fontSize: 15),
                indicatorColor: Color(0xFF79CE1E),
                tabs: <Widget>[
                  Tab(
                    text: MyLocalizations.of(context)
                        .word("sellingAds", 'Selling\n  Ads'),
                  ),
                  Tab(
                    text: MyLocalizations.of(context)
                        .word("buyingAdds", 'Buying\n  Ads'),
                  ),
                  Tab(
                    text: MyLocalizations.of(context)
                        .word("recentActivity", 'Recent\nActivity'),
                  ),
                  Tab(
                    text: MyLocalizations.of(context)
                        .word("dkdProducts", '    DKD\nProducts'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: TabBarView(
              // Tab Bar View
              physics: BouncingScrollPhysics(),
              controller: tabController,
              children: <Widget>[
                SellingAdsScreen(
                  userId: widget.userId,
                  userToken: widget.userToken,
                ),
                BuyAdsScreen(
                  userId: widget.userId,
                  userToken: widget.userToken,
                ),
                RecentActivityScreen(
                  userId: widget.userId,
                  userToken: widget.userToken,
                  userName: widget.userName,
                  userPhoneNum: widget.userPhoneNum,
                ),
                DkdProductsScreen(
                  postAd: widget.postAd,
                  userId: widget.userId,
                  userToken: widget.userToken,
                  userPhoneNum: widget.userPhoneNum,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Expanded dkdProductsList() {
  //   List cropList = ["Maize", "Oats", "Banana"];
  //   List categoryList = ["Cereal", "Cereal", "Fruit"];
  //   List descriptionList = [
  //     "Best quality Maize",
  //     "Organic Oats grown in organic fields",
  //     "High quality bananas"
  //   ];
  //   List images = [
  //     "assets/images/maize.jpg",
  //     "assets/images/oats.jpg",
  //     "assets/images/banana.jpg",
  //   ];
  //   return Expanded(
  //     child: ListView.builder(
  //       itemCount: cropList.length,
  //       itemBuilder: (context, index) {
  //         return GestureDetector(
  //           onTap: () {
  //             Navigator.of(context).push(MaterialPageRoute(
  //                 builder: (context) => AdDetailScreen(
  //                       userId: widget.userId,
  //                       userToken: widget.userToken,
  //                     )));
  //           },
  //           child: Padding(
  //             padding: EdgeInsets.only(
  //                 bottom: cHeight * 0.01,
  //                 left: cWidth * 0.05,
  //                 right: cWidth * 0.05),
  //             child: Container(
  //               child: Column(
  //                 children: <Widget>[
  //                   Image.asset(images[index]),
  //                   Padding(
  //                     padding: EdgeInsets.only(
  //                       top: cHeight * 0.02,
  //                       bottom: cHeight * 0.02,
  //                     ),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: <Widget>[
  //                         Container(
  //                           width: cWidth * 0.6,
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: <Widget>[
  //                               Row(
  //                                 mainAxisAlignment: MainAxisAlignment.start,
  //                                 children: <Widget>[
  //                                   Text(
  //                                     MyLocalizations.of(context)
  //                                             .word("cropName", "Crop Name") +
  //                                         ":",
  //                                     style: TextStyle(
  //                                       // color: Colors
  //                                       //     .green,
  //                                       fontSize: 14,
  //                                     ),
  //                                   ),
  //                                   Padding(
  //                                     padding:
  //                                         EdgeInsets.only(left: cWidth * 0.02),
  //                                     child: Text(
  //                                       cropList[index],
  //                                       style: TextStyle(
  //                                         color: Colors.grey,
  //                                         fontSize: 14,
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                               Row(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 mainAxisAlignment: MainAxisAlignment.start,
  //                                 children: <Widget>[
  //                                   Text(
  //                                     MyLocalizations.of(context)
  //                                             .word("categories", "Category") +
  //                                         ":",
  //                                     style: TextStyle(
  //                                       fontSize: 13,
  //                                     ),
  //                                   ),
  //                                   Padding(
  //                                     padding:
  //                                         EdgeInsets.only(left: cWidth * 0.02),
  //                                     child: Container(
  //                                       width: cWidth * 0.4,
  //                                       child: Text(
  //                                         categoryList[index],
  //                                         style: TextStyle(
  //                                           fontSize: 13,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                               Row(
  //                                 mainAxisAlignment: MainAxisAlignment.start,
  //                                 children: <Widget>[
  //                                   Container(
  //                                     width: cWidth * 0.6,
  //                                     child: Text(
  //                                       descriptionList[index],
  //                                       style: TextStyle(
  //                                         color: Colors.grey[800],
  //                                         fontSize: 12,
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                         Container(
  //                           width: cWidth * 0.3,
  //                           child: Column(
  //                             mainAxisAlignment: MainAxisAlignment.start,
  //                             children: <Widget>[
  //                               Container(
  //                                 child: Text(
  //                                   "Organic",
  //                                   textAlign: TextAlign.center,
  //                                 ),
  //                                 width: cWidth * 0.3,
  //                               ),
  //                               // Padding(
  //                               //   padding:
  //                               //       EdgeInsets.only(
  //                               //           top: cHeight *
  //                               //               0.02),
  //                               //   child: Container(
  //                               //     width: cWidth * 0.3,
  //                               //     child: Text(
  //                               //       "Bid Now",
  //                               //       textAlign:
  //                               //           TextAlign
  //                               //               .center,
  //                               //       style: TextStyle(
  //                               //         color: Color(
  //                               //             0xFF0047C4),
  //                               //         fontWeight:
  //                               //             FontWeight
  //                               //                 .bold,
  //                               //         fontSize: 16,
  //                               //       ),
  //                               //     ),
  //                               //   ),
  //                               // ),
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
}
