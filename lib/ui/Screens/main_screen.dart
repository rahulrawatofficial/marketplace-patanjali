import 'package:flutter/material.dart';
import 'package:marketplace_patanjali/Functions/error_handling.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';
import 'package:marketplace_patanjali/LanguageSetup/localizations.dart';
import 'package:marketplace_patanjali/Models/cart_item_model.dart';
import 'package:marketplace_patanjali/resources/http_requests.dart';
import 'package:marketplace_patanjali/ui/Screens/DkdScreens/user_first_page.dart';
import 'package:marketplace_patanjali/ui/Screens/home_category_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/home_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/home_tab_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/mandi_bhav_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/MyAds/my_ad_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/notification_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/PostAdScreens/post_ad_screen.dart';
import 'package:marketplace_patanjali/ui/Widgets/user_drawer.dart';

class MainScreen extends StatefulWidget {
  final String userId;
  final String userToken;
  final String userName;
  final String userPhoneNum;
  final bool roleAlert;
  final int pageNum;

  const MainScreen({
    Key key,
    this.userId,
    this.userToken,
    this.userName,
    this.userPhoneNum,
    this.roleAlert,
    this.pageNum,
  }) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // ApiBase _apiBase = ApiBase();
  String pCategory;
  String cType;
  String cName;
  PageController _pageController;

  int _page = 0;
  bool buyerSelected = false;

  @override
  void initState() {
    buyerSelected = !widget.roleAlert ? true : false;
    // setState(() {
    //   userId = widget.userId;
    //   userToken = widget.userToken;
    //   userRole = widget.userRole;
    //   userName = widget.userName;
    //   userProfilePic = widget.userProfilePic;
    // });
    print("userTokenNew: ${widget.userPhoneNum}");
    super.initState();
    _pageController = new PageController(
        initialPage: widget.pageNum != null ? widget.pageNum : 0);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void navigationTapped(int page) {
    // Animating to the page.
    // You can use whatever duration and curve you like
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void navigateToPostAd(
      String primaryCategory, String cropType, String cropName) {
    // Animating to the page.
    // You can use whatever duration and curve you like
    setState(() {
      pCategory = primaryCategory;
      cType = cropType;
      cName = cropName;
    });
    _pageController.animateToPage(2,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  navigateToPostAds() {
    _pageController.animateToPage(2,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void navigateToMyAds() {
    // Animating to the page.
    // You can use whatever duration and curve you like
    _pageController.animateToPage(3,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
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

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;

    cWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: getAllAuctions(),
        builder: (context, AsyncSnapshot<CartItemModel> snapshot) {
          if (snapshot.hasData) {
            finalCartCount = snapshot.data.cartItemList.length;
            return Scaffold(
              drawer: UserDrawer(
                userId: widget.userId,
                userToken: widget.userToken,
                userName: widget.userName,
                userPhoneNum: widget.userPhoneNum,
              ),
              // appBar: AppBar(
              //   title: Text("Home"),
              // ),
              body: Stack(
                children: <Widget>[
                  AbsorbPointer(
                    absorbing: buyerSelected ? false : true,
                    child: new PageView(
                      children: [
                        HomeCategoryScreen(
                          userToken: widget.userToken,
                          userId: widget.userId,
                          userName: widget.userName,
                          userPhoneNum: widget.userPhoneNum,
                        ),
                        MandiBhavScreen(),
                        PostAdScreen(
                          navigateMyAds: navigateToMyAds,
                          userToken: widget.userToken,
                          userId: widget.userId,
                          primaryCategory: pCategory,
                          cropType: cType,
                          cropName: cName,
                          userName: widget.userName,
                          userPhoneNum: widget.userPhoneNum,
                        ),
                        MyAdScreen(
                          userToken: widget.userToken,
                          userId: widget.userId,
                          postAd: navigateToPostAd,
                          userPhoneNum: widget.userPhoneNum,
                          userName: widget.userName,
                        ),
                        NotificationScreen(),
                      ],
                      onPageChanged: onPageChanged,
                      controller: _pageController,
                    ),
                  ),
                  !buyerSelected
                      ? AlertDialog(
                          // title: new Text("d \n"),
                          title: Center(child: new Text("Select your Role")),
                          content: Container(
                            height: cHeight * 0.3,
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          buyerSelected = true;
                                        });
                                        // Navigator.of(context).pop();
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/images/Buyer.png",
                                            height: cHeight * 0.1,
                                            width: cHeight * 0.1,
                                          ),
                                          Text(
                                            "Buyer",
                                            style: TextStyle(
                                                fontSize: cHeight * 0.02),
                                          )
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          buyerSelected = true;
                                          _pageController.animateToPage(2,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.ease);
                                        });
                                        // Navigator.of(context).pop();
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Image.asset(
                                            "assets/images/Seller.png",
                                            height: cHeight * 0.1,
                                            width: cHeight * 0.1,
                                          ),
                                          Text("Seller",
                                              style: TextStyle(
                                                  fontSize: cHeight * 0.02))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Divider(),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      buyerSelected = true;
                                    });
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => UserFirstPage(
                                                userId: widget.userId,
                                                // userName: userName,
                                                userToken: widget.userToken,
                                                phoneNumber:
                                                    widget.userPhoneNum,
                                                // userPhoneNum: userPhoneNum,
                                              )),
                                    );
                                    // Navigator.of(context).pop();
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/haramrit.png",
                                        height: cHeight * 0.1,
                                        width: cHeight * 0.1,
                                      ),
                                      Text(
                                        "Harit Kranti\nFarmer की बात",
                                        textAlign: TextAlign.center,
                                        style:
                                            TextStyle(fontSize: cHeight * 0.02),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // actions: <Widget>[
                          //   FlatButton(
                          //     child: new Text("Buyer"),
                          //     onPressed: () {
                          //       setState(() {
                          //         buyerSelected = true;
                          //       });
                          //       // Navigator.of(context).pop();
                          //     },
                          //   ),
                          //   FlatButton(
                          //     child: new Text("Seller"),
                          //     onPressed: () {
                          //       setState(() {
                          //         buyerSelected = true;
                          //         _pageController.animateToPage(2,
                          //             duration: const Duration(milliseconds: 300),
                          //             curve: Curves.ease);
                          //       });
                          //       // Navigator.of(context).pop();
                          //     },
                          //   )
                          // ],
                        )
                      : Offstage(),
                ],
              ),
              bottomNavigationBar: AbsorbPointer(
                absorbing: buyerSelected ? false : true,
                child: new Theme(
                  data: Theme.of(context).copyWith(
                      // sets the background color of the `BottomNavigationBar`
                      // canvasColor: const Color(0xFFFFFFFF),
                      canvasColor: Color(
                          0xFF79CE1E)), // sets the inactive color of the `BottomNavigationBar`
                  child: new BottomNavigationBar(
                    showUnselectedLabels: true,
                    type: BottomNavigationBarType.fixed,
                    items: [
                      new BottomNavigationBarItem(

                          // backgroundColor: Color(0xFF00C100),
                          icon: new Icon(
                            Icons.home,
                            // color: const Color(0xFF000000),
                            color: Color(0xFFFFFFFF),
                          ),
                          // title: new Text(
                          //   MyLocalizations.of(context).word("home", "Home"),
                          //   //   "Home",
                          //   style: new TextStyle(
                          //     fontSize: 12,
                          //     // color: const Color(0xFF000000),
                          //     color: Color(0xFFFFFFFF),
                          //   ),
                          // ),
                          ),
                      new BottomNavigationBarItem(
                          icon: new Icon(
                            Icons.perm_device_information,
                            // color: const Color(0xFF000000),

                            color: Color(0xFFFFFFFF),
                          ),
                          // title: new Text(
                          //   MyLocalizations.of(context)
                          //       .word("mandiRate", "Mandi Rate"),
                          //   //"Mandi Rate",
                          //   style: new TextStyle(
                          //     // color: const Color(0xFF000000),
                          //     fontSize: 12,
                          //     color: Color(0xFFFFFFFF),
                          //   ),
                          // )
                          ),
                      new BottomNavigationBarItem(
                        icon: new Icon(
                          Icons.add_circle,
                          // color: const Color(0xFF000000),

                          color: Color(0xFFFFFFFF),
                          size: 30,
                        ),
                        // title: new Text(
                        //   "POST\nAD",
                        //   textAlign: TextAlign.center,
                        //   style: new TextStyle(
                        //     // color: const Color(0xFF000000),
                        //     fontSize: 12,
                        //     color: Color(0xFFFFFFFF),
                        //   ),
                        // ),
                      ),
                      new BottomNavigationBarItem(
                          icon: new Icon(
                            Icons.event_note,
                            // color: const Color(0xFF000000),

                            color: Color(0xFFFFFFFF),
                          ),
                          // title: new Text(
                          //   MyLocalizations.of(context).word("myAd", "My Ad"),
                          //   //"My Ad",
                          //   style: new TextStyle(
                          //     // color: const Color(0xFF000000),
                          //     fontSize: 12,
                          //     color: Color(0xFFFFFFFF),
                          //   ),
                          // )
                          ),
                      new BottomNavigationBarItem(
                          icon: new Icon(
                            Icons.notifications,
                            // color: const Color(0xFF000000),

                            color: Color(0xFFFFFFFF),
                          ),
                          // title: new Text(
                          //   MyLocalizations.of(context)
                          //       .word("notifications", "Notifications"),
                          //   //"Notifications",
                          //   style: new TextStyle(
                          //     // color: const Color(0xFF000000),
                          //     fontSize: 12,
                          //     color: Color(0xFFFFFFFF),
                          //   ),
                          // )
                          )
                    ],
                    onTap: navigationTapped,
                    currentIndex: _page,
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
