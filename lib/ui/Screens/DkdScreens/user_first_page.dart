import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';
import 'package:marketplace_patanjali/LanguageSetup/initialize_i18n.dart';
import 'package:marketplace_patanjali/Models/get_weather_model.dart';
import 'package:marketplace_patanjali/main.dart';
import 'package:marketplace_patanjali/resources/http_requests.dart';
import 'package:marketplace_patanjali/ui/Screens/DkdScreens/report_history_list.dart';
import 'package:marketplace_patanjali/ui/Screens/DkdScreens/weather_page.dart';
import 'package:marketplace_patanjali/ui/Widgets/widget_methods.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class UserFirstPage extends StatefulWidget {
  final String userId;
  final String userToken;
  final String phoneNumber;
  // final String clear;

  const UserFirstPage({
    Key key,
    this.userId,
    this.userToken,
    this.phoneNumber,
    // this.clear,
  }) : super(key: key);
  @override
  UserFirstPageState createState() => UserFirstPageState();
}

class UserFirstPageState extends State<UserFirstPage> {
  String userStateId = "";
  String userCityId = "";
  String userCropId = "";

  GetWeatherModel data;
  String connection = "Done";
  double latitude;
  double longitude;
  List<String> title = [
    "Personal\nInformation",
    // "Identification\nDetails",
    "Weather",
    "Mandi Bhav",
    "Farm Details\n and Updates",
    // "Farm Ownership\n Details",
    "Seed Quality",
    "News & Feeds",
    "Nearby Distributers",
    // "Farm Details",
    "Blogs",
    "Report History",
  ];
  // GetLocation getLoc = GetLocation();

  List<Map> mandiBhav = [
    {
      "name": "Apple",
      "price": "Rs. 100/Kg",
    },
    {
      "name": "Mango",
      "price": "Rs. 120/Kg",
    },
    {
      "name": "Guava",
      "price": "Rs. 70/Kg",
    },
    {
      "name": "Maize",
      "price": "Rs. 50/Kg",
    },
    {
      "name": "Tomato",
      "price": "Rs. 30/Kg",
    },
    {
      "name": "Potato",
      "price": "Rs. 30/Kg",
    },
    {
      "name": "Rice",
      "price": "Rs. 90/Kg",
    },
    {
      "name": "Wheat",
      "price": "Rs. 25/Kg",
    },
    {
      "name": "Onion",
      "price": "Rs. 15/Kg",
    },
    {
      "name": "Lemon",
      "price": "Rs. 60/Kg",
    },
    {
      "name": "Lauki",
      "price": "Rs. 15/Kg",
    },
    {
      "name": "Anaar",
      "price": "Rs. 80/Kg",
    },
    {
      "name": "Grapes",
      "price": "Rs. 80/Kg",
    },
    {
      "name": "Papita",
      "price": "Rs. 30/Kg",
    },
    {
      "name": "Guava",
      "price": "Rs. 60/Kg",
    },
    {
      "name": "Carrot",
      "price": "Rs. 25/Kg",
    },
    {
      "name": "Beans",
      "price": "Rs. 20/Kg",
    },
    {
      "name": "Bhindi",
      "price": "Rs. 40/Kg",
    },
    {
      "name": "Shimla Mirch",
      "price": "Rs. 20/Kg",
    },
    {
      "name": "Green Chilli",
      "price": "Rs. 20/Kg",
    },
    {
      "name": "Cabbage",
      "price": "Rs. 15/Kg",
    },
    {
      "name": "Karela",
      "price": "Rs. 30/Kg",
    },
  ];

  String assetPDFPath = "";

  _launchButton(int index) {
    // if (index == 0) {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => PersonalInformation(
    //                 userId: widget.userId,
    //                 userToken: widget.userToken,
    //               )));
    // }
    //  else
    if (index == 1) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => WeatherPage(
                userId: widget.userId,
                userToken: widget.userToken,
              )));
    }
    // else if (index == 1) {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => FamilyList(
    //                 userId: widget.userId,
    //                 userToken: widget.userToken,
    //               )));
    // } else if (index == 2) {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => FarmDetailsPage(
    //                 userToken: widget.userToken,
    //                 userId: widget.userId,
    //               )));
    // } else if (index == 3) {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => CropHistory(
    //                 userToken: widget.userToken,
    //                 userId: widget.userId,
    //               )));
    // }
    // else if (index == 5) {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => NewsPage(
    //                 path: assetPDFPath,
    //               )));
    // } else if (index == 6) {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => NearbyDistributers(
    //                 // userToken: widget.userToken,
    //                 // userId: widget.userId,
    //                 stateId: "5d288c486511224ceb89bf9f",
    //               )));
    // }
    // else if (index == 7) {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => LandMapList(
    //                 userToken: widget.userToken,
    //                 userId: widget.userId,
    //               )));
    // }
    else if (index == 8) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReportHistoryList(
            userId: widget.userId,
            userToken: widget.userToken,
            phoneNumber: widget.phoneNumber,
          ),
        ),
      );
    }
    // if (index == 10) {
    //   print(finalUserId);
    // }
    // } else {
    //   showDialogSingleButton(
    //       context, "", "Please fill your personal information", "OK");
    // }
  }

  Future<GetWeatherModel> getWeatherInfo(
      String latitude, String longitude, String userToken) async {
    var params = {"latitude": latitude, "longitude": longitude};
    final response = await ApiBase()
        .get(context, "/api/getWeatherDetail", params, widget.userToken);

    //var data = json.decode(response.body);
    print(response.body);

    return GetWeatherModel.fromJson(json.decode(response.body));
  }

  @override
  void initState() {
    // getFileFromAsset("assets/news.pdf").then((f) {
    //   setState(() {
    //     assetPDFPath = f.path;
    //     print(assetPDFPath);
    //   });
    // });
    getData();
    super.initState();
  }

  getData() {
    setState(() {
      connection = "working";
    });
    getLocation().then((value) {
      print(value.toString());
      if (value != null) {
        setState(() {
          latitude = value['latitude'];
          longitude = value['longitude'];
        });
        print(value['latitude']);
        print(value['longitude']);

        getWeatherInfo(
                latitude.toString(), longitude.toString(), widget.userToken)
            .then((val) {
          print(val.responseData.forecasts[0].day);
          setState(() {
            data = val;
            connection = "Done";
          });
        });
      } else {
        setState(() {
          connection = "Done";
          data = null;
          latitude = null;
          longitude = null;
        });
      }
    });
  }

  navigatePage() async {
    Map<String, Map<String, String>> localizedValues = await initializeI18n();
    var route = MaterialPageRoute(
        builder: (BuildContext context) => MyApp(localizedValues));
    Navigator.of(context)
        .pushAndRemoveUntil(route, ModalRoute.withName("name"));
  }

  weatherImage(String weather) {
    if (weather == "Mostly Cloudy" || weather == "Partly Cloudy") {
      return Image.asset(
        'assets/WeatherIcons/partlycloudy.png',
        height: cHeight * 0.12,
        width: cWidth * 0.22,
      );
    }
    if (weather == "Thunderstorms" || weather == "Rainy") {
      return Image.asset(
        'assets/WeatherIcons/thunderstorm.png',
        height: cHeight * 0.12,
        width: cWidth * 0.22,
      );
    }
    if (weather == "Sunny" || weather == "Mostly Sunny") {
      return Image.asset(
        'assets/WeatherIcons/sun.png',
        height: cHeight * 0.12,
        width: cWidth * 0.22,
      );
    } else {
      return Image.asset(
        'assets/WeatherIcons/partlycloudy.png',
        height: cHeight * 0.12,
        width: cWidth * 0.22,
      );
    }
  }

  Future<File> getFileFromAsset(String asset) async {
    try {
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/news.pdf");

      File assetFile = await file.writeAsBytes(bytes);
      return assetFile;
    } catch (e) {
      throw Exception("Error opening asset file");
    }
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    cWidth = MediaQuery.of(context).size.width;
    List<Image> imageList = [
      Image.asset(
        'assets/DashboardIcons/PersonalInformation.png',
        height: cHeight * 0.1,
        width: cWidth * 0.15,
      ),
      // Image.asset(
      //   'assets/DashboardIcons/EditFarmer.png',
      //   height: cHeight * 0.1,
      //   width: cWidth * 0.15,
      // ),
      Image.asset(
        'assets/WeatherIcons/partlycloudy.png',
        height: cHeight * 0.1,
        width: cWidth * 0.15,
      ),
      Image.asset(
        'assets/DashboardIcons/MandiBhav.png',
        height: cHeight * 0.1,
        width: cWidth * 0.15,
      ),
      Image.asset(
        'assets/DashboardIcons/CropDetails.png',
        height: cHeight * 0.1,
        width: cWidth * 0.15,
      ),
      // Image.asset(
      //   'assets/DashboardIcons/OwnershipDetails.png',
      //   height: cHeight * 0.1,
      //   width: cWidth * 0.15,
      // ),
      Image.asset(
        'assets/DashboardIcons/SeedQuality.png',
        height: cHeight * 0.1,
        width: cWidth * 0.15,
      ),
      Image.asset(
        'assets/DashboardIcons/NewsAndFeeds.png',
        height: cHeight * 0.1,
        width: cWidth * 0.15,
      ),
      Image.asset(
        'assets/DashboardIcons/Nearby.png',
        height: cHeight * 0.1,
        width: cWidth * 0.15,
      ),
      Image.asset(
        'assets/DashboardIcons/Blogs.jpg',
        height: cHeight * 0.1,
        width: cWidth * 0.15,
      ),
      // Image.asset(
      //   'assets/DashboardIcons/Blogs.jpg',
      //   height: cHeight * 0.1,
      //   width: cWidth * 0.15,
      // ),
      Image.asset(
        'assets/DashboardIcons/PersonalInformation.png',
        height: cHeight * 0.1,
        width: cWidth * 0.15,
      ),
    ];
    return Scaffold(
      // drawer: DrawerAgent(
      //   userId: widget.userId,
      //   userToken: widget.userToken,
      //   stateId: "",
      // ),
      // drawer: DrawerA(
      //   stateId: "",
      //   userId: widget.userId,
      //   userToken: widget.userToken,
      // ),
      appBar: AppBar(
        centerTitle: false,
        // backgroundColor: appBarColor,
        title: Text(
          'haritkranti',
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            "assets/backgroundimg.jpg",
            fit: BoxFit.cover,
          ),
          Column(
            children: <Widget>[
              CarouselSlider.builder(
                options: CarouselOptions(
                  height: cHeight * 0.08,
                  // aspectRatio: 16 / 9,
                  // viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 5),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  // onPageChanged: callbackFunction,
                  scrollDirection: Axis.horizontal,
                ),
                itemCount: mandiBhav.length,
                itemBuilder: (BuildContext context, int itemIndex) => Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        "${mandiBhav[itemIndex]["name"]}",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${mandiBhav[itemIndex]["price"]}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                // height: cHeight * 0.21,
                // width: cWidth,
                // color: Colors.grey[100],
                child: connection == "Done"
                    ? Padding(
                        padding: EdgeInsets.only(
                          left: cWidth * 0.01,
                          right: cWidth * 0.01,
                          top: cHeight * 0.01,
                        ),
                        child: data != null
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.replay),
                                        onPressed: () {
                                          getData();
                                        },
                                      ),
                                      weatherImage(data.responseData
                                          .currentObservation.condition.text),
                                    ],
                                  ),
                                  Container(
                                    width: cWidth * 0.7,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          data.responseData.location.city,
                                          style: TextStyle(
                                              fontSize: cHeight * 0.02,
                                              color: Colors.blue[700],
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: cHeight * 0.01,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "${data.responseData.currentObservation.condition.temperature}° F",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: cHeight * 0.02),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: cHeight * 0.02,
                                                  left: cWidth * 0.07,
                                                  bottom: cHeight * 0.02,
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Column(
                                                      children: <Widget>[
                                                        Text('Rain'),
                                                        Image.asset(
                                                          'assets/WeatherIcons/rain.png',
                                                          height:
                                                              cHeight * 0.04,
                                                          width: cWidth * 0.06,
                                                        ),
                                                        data
                                                                        .responseData
                                                                        .currentObservation
                                                                        .condition
                                                                        .text ==
                                                                    "Rainy" ||
                                                                data
                                                                        .responseData
                                                                        .currentObservation
                                                                        .condition
                                                                        .text ==
                                                                    "Thunderstorms"
                                                            ? Text(
                                                                'Yes',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      cHeight *
                                                                          0.015,
                                                                ),
                                                              )
                                                            : Text(
                                                                'No',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      cHeight *
                                                                          0.015,
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        left: cWidth * 0.03,
                                                        right: cWidth * 0.03,
                                                      ),
                                                      child: Container(
                                                        height: cHeight * 0.04,
                                                        width: cWidth * 0.003,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Column(
                                                      children: <Widget>[
                                                        Text('Humidity'),
                                                        Image.asset(
                                                          'assets/WeatherIcons/humidity.png',
                                                          height:
                                                              cHeight * 0.04,
                                                          width: cWidth * 0.06,
                                                        ),
                                                        Text(
                                                          "${data.responseData.currentObservation.atmosphere.humidity}%",
                                                          style: TextStyle(
                                                            fontSize:
                                                                cHeight * 0.015,
                                                          ),
                                                        ),
                                                        // Text(
                                                        //   '42.5% Min',
                                                        //   style: TextStyle(
                                                        //     fontSize: cHeight * 0.015,
                                                        //     color: Colors.blue,
                                                        //   ),
                                                        // ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        left: cWidth * 0.03,
                                                        right: cWidth * 0.03,
                                                      ),
                                                      child: Container(
                                                        height: cHeight * 0.04,
                                                        width: cWidth * 0.003,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Column(
                                                      children: <Widget>[
                                                        Text('Wind'),
                                                        Image.asset(
                                                          'assets/WeatherIcons/wind.jpg',
                                                          height:
                                                              cHeight * 0.04,
                                                          width: cWidth * 0.06,
                                                        ),
                                                        Text(
                                                          '${data.responseData.currentObservation.wind.speed} Km/hr',
                                                          style: TextStyle(
                                                            fontSize:
                                                                cHeight * 0.015,
                                                          ),
                                                        ),
                                                        // Text(
                                                        //   'E',
                                                        //   style: TextStyle(
                                                        //     fontSize: cHeight * 0.015,
                                                        //     color: Colors.blue,
                                                        //   ),
                                                        // ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                            : Padding(
                                padding: EdgeInsets.only(
                                  top: cHeight * 0.07,
                                  bottom: cHeight * 0.07,
                                ),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      getData();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Couldn't fetch location Please try again.",
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                        Icon(
                                          Icons.replay,
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                      )
                    :
                    // Padding(
                    //     padding: EdgeInsets.only(
                    //       top: cHeight * 0.08,
                    //       bottom: cHeight * 0.08,
                    //     ),
                    //     child: Center(
                    //       child: GestureDetector(
                    //         child: Text(
                    //           'Get weather details',
                    //           style: TextStyle(fontSize: cHeight * 0.022),
                    //         ),
                    //         onTap: () {
                    //           getData();
                    //         },
                    //       ),
                    //     ),
                    //   )
                    Padding(
                        padding: EdgeInsets.only(
                          top: cHeight * 0.07,
                          bottom: cHeight * 0.07,
                        ),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
              ),
              Expanded(
                child: GridView.builder(
                    itemCount: title.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          _launchButton(index);
                        },
                        child: Card(
                          color: Colors.grey[100],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              // icons[index],
                              imageList[index],
                              Text(
                                title[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: cHeight * 0.017,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
