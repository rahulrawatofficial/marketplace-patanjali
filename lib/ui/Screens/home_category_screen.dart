import 'package:flutter/material.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';
import 'package:marketplace_patanjali/LanguageSetup/localizations.dart';
import 'package:marketplace_patanjali/Models/home_category_model.dart';
import 'package:marketplace_patanjali/resources/http_requests.dart';
import 'package:marketplace_patanjali/ui/Screens/cart_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/home_screen.dart';
import 'package:marketplace_patanjali/ui/Screens/home_tab_screen.dart';
import 'package:marketplace_patanjali/ui/Widgets/user_drawer.dart';

class HomeCategoryScreen extends StatefulWidget {
  final String userId;
  final String userToken;
  final String userName;
  final String userPhoneNum;

  const HomeCategoryScreen({
    Key key,
    this.userId,
    this.userToken,
    this.userName,
    this.userPhoneNum,
  }) : super(key: key);
  @override
  _HomeCategoryScreenState createState() => _HomeCategoryScreenState();
}

class _HomeCategoryScreenState extends State<HomeCategoryScreen> {
  String title = "Annadata MarketPlace";
  Color titleColor = Color(0xFF009D37);
  Color buttonColor = Color(0xFF0047C4);
  Color barColor = Color(0xFF009D37);

  List categoryList = [
    "Fruit",
    "Vegetables",
    "Dry Fruits",
    "Dairy Products",
    "Crops"
  ];

  Future<HomeCategoryModel> getCategories() async {
    final response = await ApiBase()
        .get(context, "/api/getHomeCategoryList", null, widget.userToken);
    if (response != null) {
      debugPrint("Success");
      debugPrint(response.body);
      return homeCategoryModelFromJson(response.body);
    } else {
      return HomeCategoryModel(
        categoryList: [],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: FutureBuilder(
          future: getCategories(),
          builder: (context, AsyncSnapshot<HomeCategoryModel> snapshot) {
            print(cHeight / (cWidth * 1.5));
            if (snapshot.hasData == true) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      top: cHeight * 0.02,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        // border: Border.all(color: Colors.grey[300])
                      ),
                      height: cHeight * 0.05,
                      width: cWidth * 0.5,
                      child: Center(
                          child: Text(
                        "Shop by Category",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF79CE1E),
                        ),
                      )),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          // top: cHeight * 0.01,
                          left: cWidth * 0.01,
                          right: cWidth * 0.01),
                      child: Padding(
                        padding: EdgeInsets.only(top: cHeight * 0.03),
                        child: GridView.builder(
                            itemCount: snapshot.data.categoryList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.1,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  // _launchButton(index);
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 4.0, right: 4.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeTabScreen(
                                                    userToken: widget.userToken,
                                                    userId: widget.userId,
                                                    userName: widget.userName,
                                                    userPhoneNum:
                                                        widget.userPhoneNum,
                                                    primaryId: snapshot
                                                        .data
                                                        .categoryList[index]
                                                        .productCategoryId,
                                                  )));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: cHeight * 0.005,
                                          bottom: cHeight * 0.005),
                                      child: Container(
                                        width: cWidth * 0.48,
                                        height: cHeight * 3,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color(0xFF79CE1E),
                                          ),
                                          // borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: cHeight * 0.02),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Color(0xFFFFA100),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(
                                                        25,
                                                      ),
                                                      bottomRight:
                                                          Radius.circular(
                                                        25,
                                                      ),
                                                    )),
                                                height: cHeight * 0.03,
                                                width: cWidth * 0.35,
                                                child: Center(
                                                  child: Text(
                                                    snapshot
                                                        .data
                                                        .categoryList[index]
                                                        .primaryCategoryName,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: 4.0,
                                                bottom: 4.0,
                                              ),
                                              child: snapshot
                                                          .data
                                                          .categoryList[index]
                                                          .categoryImageUrl !=
                                                      null
                                                  ? Image.network(
                                                      snapshot
                                                          .data
                                                          .categoryList[index]
                                                          .categoryImageUrl,
                                                      height: cHeight * 0.12,
                                                      width: cWidth * 0.4,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Container(
                                                      height: cHeight * 0.12,
                                                      width: cWidth * 0.4,
                                                      color: Colors.grey[300],
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
