import 'dart:io';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marketplace_patanjali/LanguageSetup/localizations.dart';
import 'package:marketplace_patanjali/ui/Widgets/widget_methods.dart';

class SelectLocation extends StatefulWidget {
  final Future Function(LatLng) onLocationChange;

  const SelectLocation({
    Key key,
    this.onLocationChange,
  }) : super(key: key);
  @override
  _SelectLocationState createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  double latitude;
  double longitude;

  String title = "Annadata MarketPlace";
  Color titleColor = Color(0xFF009D37);
  Color textColor = Color(0xFF009D37);
  Color barColor = Colors.white;

  LatLng startPoint;
  Set<Marker> marker = Set();
  GoogleMapController mapController;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // addMarker();
    getLocation().then((value) {
      print(value.toString());
      setState(() {
        latitude = value['latitude'];
        longitude = value['longitude'];

        startPoint = LatLng(latitude, longitude);
      });
      print(value['latitude']);
      print(value['longitude']);
      super.initState();
    });
  }

  LatLng coord;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 1,
        // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
      ),
      body: latitude != null && longitude != null && startPoint != null
          ? Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.78,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    onTap: (val) {
                      setState(() {
                        marker.clear();
                        marker.add(Marker(
                          markerId: MarkerId('${val.latitude}${val.longitude}'),
                          // infoWindow: InfoWindow(title: "Store", snippet: "Main Branch"),
                          position: LatLng(val.latitude, val.longitude),
                        ));
                        coord = val;
                      });
                    },
                    markers: marker,
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                    },
                    mapType: MapType.satellite,
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: startPoint,
                      zoom: 20.0,
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          color: Colors.green,
                          child: Text(
                            MyLocalizations.of(context).word("save", "Save"),
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            print(coord);
                            widget.onLocationChange(coord);
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
