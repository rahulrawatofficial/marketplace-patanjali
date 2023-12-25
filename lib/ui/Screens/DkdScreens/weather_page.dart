import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:marketplace_patanjali/Functions/variables.dart';
import 'package:marketplace_patanjali/LanguageSetup/initialize_i18n.dart';
import 'package:marketplace_patanjali/Models/get_weather_model.dart';
import 'package:marketplace_patanjali/main.dart';
import 'package:marketplace_patanjali/resources/http_requests.dart';
import 'package:marketplace_patanjali/ui/Widgets/widget_methods.dart';
import 'package:http/http.dart' as http;

class WeatherPage extends StatefulWidget {
  final String userId;
  final String userToken;
  // final String clear;

  const WeatherPage({
    Key key,
    this.userId,
    this.userToken,
    // this.clear,
  }) : super(key: key);
  @override
  WeatherPageState createState() => WeatherPageState();
}

class WeatherPageState extends State<WeatherPage> {
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
    // "Report",
  ];
  // GetLocation getLoc = GetLocation();

  String assetPDFPath = "";

  @override
  void initState() {
    getData();
    super.initState();
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
      Image.asset(
        'assets/DashboardIcons/Blogs.jpg',
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
        // backgroundColor: appBarColor,
        title: Text(
          'Weather',
          style: TextStyle(
              // color: titleColor,
              ),
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
                                            fontWeight: FontWeight.w600,
                                          ),
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
                    : Padding(
                        padding: EdgeInsets.only(
                          top: cHeight * 0.07,
                          bottom: cHeight * 0.07,
                        ),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
              ),
              data != null
                  ? Card(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                              left: cWidth * 0.02,
                              right: cWidth * 0.02,
                              top: cHeight * 0.03,
                              bottom: cHeight * 0.03,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Humidiy",
                                  style: TextStyle(
                                    fontSize: cHeight * 0.02,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue[700],
                                  ),
                                ),
                                Text(
                                  "${data.responseData.currentObservation.atmosphere.humidity} %",
                                  style: TextStyle(
                                      fontSize: cHeight * 0.02,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: cWidth * 0.02,
                              right: cWidth * 0.02,
                              top: cHeight * 0.03,
                              bottom: cHeight * 0.03,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Visibility",
                                  style: TextStyle(
                                    fontSize: cHeight * 0.02,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue[700],
                                  ),
                                ),
                                Text(
                                  "${data.responseData.currentObservation.atmosphere.visibility} %",
                                  style: TextStyle(
                                      fontSize: cHeight * 0.02,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: cWidth * 0.02,
                              right: cWidth * 0.02,
                              top: cHeight * 0.03,
                              bottom: cHeight * 0.03,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Sunrise",
                                  style: TextStyle(
                                    fontSize: cHeight * 0.02,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue[700],
                                  ),
                                ),
                                Text(
                                  data.responseData.currentObservation.astronomy
                                      .sunrise
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: cHeight * 0.02,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: cWidth * 0.02,
                              right: cWidth * 0.02,
                              top: cHeight * 0.03,
                              bottom: cHeight * 0.03,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Sunset",
                                  style: TextStyle(
                                    fontSize: cHeight * 0.02,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue[700],
                                  ),
                                ),
                                Text(
                                  data.responseData.currentObservation.astronomy
                                      .sunset
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: cHeight * 0.02,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.all(0),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
