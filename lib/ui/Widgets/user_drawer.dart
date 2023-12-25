import 'package:flutter/material.dart';
import 'package:marketplace_patanjali/Functions/logout_profile.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';
import 'package:marketplace_patanjali/LanguageSetup/initialize_i18n.dart';
import 'package:marketplace_patanjali/LanguageSetup/localizations.dart';
import 'package:marketplace_patanjali/main.dart';
import 'package:marketplace_patanjali/ui/Login/country_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/BidScreens/mybids_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/DkdScreens/user_first_page.dart';
import 'package:marketplace_patanjali/ui/Screens/Profile/edit_profile_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/bank_details_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/main_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/order_history_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/transaction_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/wallet_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/wishlist_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDrawer extends StatefulWidget {
  final String userId;
  final String userToken;
  final String userRole;
  final String userName;
  final String userPhoneNum;
  final String userProfilePic;
  final Function navigateToPostAds;

  const UserDrawer({
    Key key,
    this.userId,
    this.userToken,
    this.userRole,
    this.userName,
    this.userProfilePic,
    this.userPhoneNum,
    this.navigateToPostAds,
  }) : super(key: key);

  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  @override
  Widget build(BuildContext context) {
    saveLanguage() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      await preferences.setString('language', null);
      await preferences.setBool('lanSplash', false);
    }

    onChangeLanguage() {
      print("done");
    }

    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;

    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: cHeight * 0.18,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: cWidth,
                  decoration: BoxDecoration(
                      color: Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                      )),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: cHeight * 0.03, left: cWidth * 0.04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CircleAvatar(
                          child: Icon(
                            Icons.person,
                            size: 40,
                          ),
                          radius: 40,
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              "${widget.userName}",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text("${widget.userPhoneNum}"),
                          ],
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.navigate_before,
                              size: 40,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            })
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: cHeight * 0.01,
              left: cWidth * 0.12,
              right: cWidth * 0.2,
            ),
            child: Divider(
              thickness: 2,
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.only(left: cWidth * 0.1),
                  leading: Icon(
                    Icons.person_outline,
                    color: Color(0xFF0047C4),
                  ),
                  title: Text(
                    MyLocalizations.of(context).word("myProfile", "My Profile"),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => EditProfileScreen(
                                userId: widget.userId,
                                userToken: widget.userToken,
                              )),
                    );
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: cWidth * 0.1),
                  leading: Icon(
                    Icons.home,
                    color: Color(0xFF0047C4),
                  ),
                  title: Text(
                    MyLocalizations.of(context).word("home", "Home"),
                  ),
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => MainScreen(
                                  userId: widget.userId,
                                  userName: widget.userName,
                                  userToken: widget.userToken,
                                  userPhoneNum: widget.userPhoneNum,
                                  roleAlert: false,
                                )),
                        ModalRoute.withName('/'));
                  },
                ),
                // ListTile(
                //   contentPadding: EdgeInsets.only(left: cWidth * 0.1),
                //   leading: Icon(
                //     Icons.speaker,
                //     color: Color(0xFF0047C4),
                //   ),
                //   title: Text("Post Free Ad"),
                //   onTap: () {},
                // ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: cWidth * 0.1),
                  leading: Icon(
                    Icons.library_books,
                    color: Color(0xFF0047C4),
                  ),
                  title: Text(
                    MyLocalizations.of(context).word("myBids", "My Bids"),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => MyBidScreen(
                                userId: widget.userId,
                                userName: widget.userName,
                                userToken: widget.userToken,
                                userPhoneNum: widget.userPhoneNum,
                              )),
                    );
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: cWidth * 0.1),
                  leading: Icon(
                    Icons.monetization_on,
                    color: Color(0xFF0047C4),
                  ),
                  title: Text("Transaction"),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => TransactionsScreen(
                                userId: widget.userId,
                                // userName: userName,
                                userToken: widget.userToken,
                                // userPhoneNum: userPhoneNum,
                              )),
                    );
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: cWidth * 0.1),
                  leading: Icon(
                    Icons.shopping_cart,
                    color: Color(0xFF0047C4),
                  ),
                  title: Text("Order History"),
                  onTap: () {
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
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: cWidth * 0.1),
                  leading: Icon(
                    Icons.description,
                    color: Color(0xFF0047C4),
                  ),
                  title: Text("Bank Details"),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => BankDetailScreen(
                              widget.userId, widget.userToken)),
                    );
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: cWidth * 0.1),
                  leading: Icon(
                    Icons.apps,
                    color: Color(0xFF0047C4),
                  ),
                  title: Text("Haritkranti"),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => UserFirstPage(
                                userId: widget.userId,
                                // userName: userName,
                                userToken: widget.userToken,

                                phoneNumber: widget.userPhoneNum,
                              )),
                    );
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: cWidth * 0.1),
                  leading: Icon(
                    Icons.account_balance_wallet,
                    color: Color(0xFF0047C4),
                  ),
                  title: Text(
                    MyLocalizations.of(context).word("wallet", "Wallet"),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => WalletScreen(
                                userId: widget.userId,
                                userName: widget.userName,
                                userToken: widget.userToken,
                                userPhoneNum: widget.userPhoneNum,
                                userProfilePic: widget.userProfilePic,
                                userRole: widget.userRole,
                              )),
                    );
                  },
                ),
                // ListTile(
                //   contentPadding: EdgeInsets.only(left: cWidth * 0.1),
                //   leading: Icon(
                //     Icons.home,
                //     color: Color(0xFF0047C4),
                //   ),
                //   title: Text("Home"),
                //   onTap: () {},
                // ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: cWidth * 0.1),
                  leading: Icon(
                    Icons.speaker,
                    color: Color(0xFF0047C4),
                  ),
                  title: Text(
                    MyLocalizations.of(context)
                        .word("postFreeAd", "Post Free Ad"),
                  ),
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => MainScreen(
                                  userId: widget.userId,
                                  userName: widget.userName,
                                  userToken: widget.userToken,
                                  userPhoneNum: widget.userPhoneNum,
                                  roleAlert: false,
                                  pageNum: 2,
                                )),
                        ModalRoute.withName('/'));
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: cWidth * 0.1),
                  leading: Icon(
                    Icons.library_books,
                    color: Color(0xFF0047C4),
                  ),
                  title: Text(
                    MyLocalizations.of(context).word("wishlist", "Wishlist"),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => WishlistScreen(
                                userId: widget.userId,
                                userName: widget.userName,
                                userToken: widget.userToken,
                                userPhoneNum: widget.userPhoneNum,
                              )),
                    );
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: cWidth * 0.1),
                  leading: Icon(
                    Icons.language,
                    color: Color(0xFF0047C4),
                  ),
                  title: Text(
                    MyLocalizations.of(context)
                        .word("changeLanguage", "Change Language"),
                  ),
                  onTap: () async {
                    saveLanguage();
                    // var route = MaterialPageRoute(
                    //     builder: (BuildContext context) =>
                    //         CountryScreen(onChangeLanguage, "yes"));
                    // Navigator.of(context).push(route);
                    Map<String, Map<String, String>> localizedValues =
                        await initializeI18n();
                    var route = MaterialPageRoute(
                        builder: (BuildContext context) =>
                            MyApp(localizedValues));
                    Navigator.of(context)
                        .pushAndRemoveUntil(route, ModalRoute.withName("name"));
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: cWidth * 0.1),
                  leading: Icon(
                    Icons.screen_share,
                    color: Colors.grey,
                    // color: Color(0xFF0047C4),
                  ),
                  title: Text(
                    MyLocalizations.of(context).word("shareApp", "Share App"),
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: cWidth * 0.1),
                  leading: Icon(
                    Icons.stars,
                    // color: Color(0xFF0047C4),
                    color: Colors.grey,
                  ),
                  title: Text(
                    MyLocalizations.of(context).word("rateUs", "Rate Us"),
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: cWidth * 0.1),
                  leading: Icon(
                    Icons.sms,
                    // color: Color(0xFF0047C4),
                    color: Colors.grey,
                  ),
                  title: Text(
                    MyLocalizations.of(context)
                        .word("connectWithUs", "Connect With Us"),
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: cWidth * 0.1),
                  leading: Icon(
                    Icons.playlist_add_check,
                    // color: Color(0xFF0047C4),
                    color: Colors.grey,
                  ),
                  title: Text(
                    MyLocalizations.of(context)
                        .word("privacyPolicy", "Privacy Policy"),
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: cWidth * 0.1),
                  leading: Icon(
                    Icons.content_paste,
                    // color: Color(0xFF0047C4),
                    color: Colors.grey,
                  ),
                  title: Text(
                    MyLocalizations.of(context)
                        .word("terms&Condition", "Terms & Condition"),
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  onTap: () {},
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.only(left: cWidth * 0.1),
                  leading: Icon(
                    Icons.power_settings_new,
                    color: Color(0xFF0047C4),
                  ),
                  title: Text(
                    MyLocalizations.of(context).word("logout", "Logout"),
                  ),
                  onTap: () async {
                    Map<String, Map<String, String>> localizedValues =
                        await initializeI18n();
                    logoutProfile().then((val) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => MyApp(localizedValues)),
                          ModalRoute.withName("no"));
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
