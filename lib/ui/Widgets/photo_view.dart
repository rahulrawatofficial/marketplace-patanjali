import 'package:flutter/material.dart';
import 'package:marketplace_patanjali/LanguageSetup/localizations.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewScreen extends StatefulWidget {
  final String imageUrl;

  const PhotoViewScreen({Key key, this.imageUrl}) : super(key: key);
  @override
  _PhotoViewScreenState createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  Color titleColor = Color(0xFF009D37);
  Color textColor = Color(0xFF0047C4);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: Container(
          child: PhotoView(
        imageProvider: NetworkImage(widget.imageUrl),
      )),
    );
  }
}
