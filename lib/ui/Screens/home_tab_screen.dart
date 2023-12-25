import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';
import 'package:marketplace_patanjali/LanguageSetup/localizations.dart';
import 'package:marketplace_patanjali/Models/AuctionModel/auction_model.dart';
import 'package:marketplace_patanjali/resources/http_requests.dart';
import 'package:marketplace_patanjali/ui/Screens/MyAds/buy_ads_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/MyAds/recent_activity_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/MyAds/selling_ads_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/cart_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/home_screen.dart';
import 'package:marketplace_patanjali/ui/Widgets/user_drawer.dart';

class HomeTabScreen extends StatefulWidget {
  final String userId;
  final String userToken;
  final String userName;
  final String userPhoneNum;
  final String primaryId;

  const HomeTabScreen({
    Key key,
    this.userToken,
    this.userId,
    this.userPhoneNum,
    this.userName,
    this.primaryId,
  }) : super(key: key);
  @override
  _HomeTabScreenState createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen>
    with SingleTickerProviderStateMixin {
  String title = "Annadata MarketPlace";
  Color titleColor = Color(0xFF009D37);
  Color buttonColor = Color(0xFF0047C4);

  bool dkdProducts = false;
  TabController tabController;
  String location = "Location";

  @override
  void initState() {
    tabController = new TabController(length: 3, vsync: this);
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
                    text: MyLocalizations.of(context).word("allAds", 'All'),
                  ),
                  Tab(
                    text:
                        MyLocalizations.of(context).word("auctions", 'Auction'),
                  ),
                  Tab(
                    text:
                        MyLocalizations.of(context).word("regular", 'Regular'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: TabBarView(
              // Tab Bar View
              physics: BouncingScrollPhysics(),
              controller: tabController,
              children: <Widget>[
                HomeScreen(
                  userToken: widget.userToken,
                  userId: widget.userId,
                  userName: widget.userName,
                  userPhoneNum: widget.userPhoneNum,
                  primaryId: widget.primaryId,
                ),
                HomeScreen(
                  userToken: widget.userToken,
                  userId: widget.userId,
                  userName: widget.userName,
                  userPhoneNum: widget.userPhoneNum,
                  primaryId: widget.primaryId,
                  fixedPrice: "N",
                ),
                HomeScreen(
                  userToken: widget.userToken,
                  userId: widget.userId,
                  userName: widget.userName,
                  userPhoneNum: widget.userPhoneNum,
                  primaryId: widget.primaryId,
                  fixedPrice: "Y",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
