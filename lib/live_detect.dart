import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:nazar_capstone/camera.dart';
import 'package:nazar_capstone/bounding_box.dart';
import 'package:tflite/tflite.dart';

//final cameras = await availableCameras();

class LiveFeed extends StatefulWidget {
  //const LiveFeed({Key key}) : super(key: key);
  final List<CameraDescription> cameras;
  LiveFeed(this.cameras);
  @override
  _LiveFeedState createState() => _LiveFeedState();
}

class _LiveFeedState extends State<LiveFeed> {
  late List<dynamic> _recognitions = [];
  int _imageHeight = 0;
  int _imageWidth = 0;
  initCameras() async {

  }
  loadTfModel() async {
    await Tflite.loadModel(
      model: "models/ssd_mobilenet.tflite",
      labels: "models/labels.txt",
    );
  }
  /*
  The set recognitions function assigns the values of recognitions, imageHeight and width to the variables defined here as callback
  */
  void setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTfModel();
  }
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFE7004C),
          title: Text(
            "NAZAR- See The World",
            style: GoogleFonts.merriweather(
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            CameraFeed(widget.cameras, setRecognitions),
            BoundingBox(
              // ignore: unnecessary_null_comparison
              _recognitions == null ? [] : _recognitions,
              math.max(_imageHeight, _imageWidth),
              math.min(_imageHeight, _imageWidth),
              screen.height,
              screen.width,
            ),

          ],
        ),
      ),
    );
  }
}