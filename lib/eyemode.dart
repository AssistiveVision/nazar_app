import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nazar_capstone/object.dart';
import 'package:nazar_capstone/ocr.dart';


class Eyemode extends StatefulWidget {
  final String url;
  Eyemode({Key? key, required this.url}) : super(key: key);

  @override
  _EyemodeState createState() => _EyemodeState();
}

class _EyemodeState extends State<Eyemode> {
  late List<CameraDescription> cameras;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    initCamera();
  }
  Future<void> initCamera() async{
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  }
  @override
  Widget build(BuildContext context) {
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
        body: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: (){

                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context){
                                return ObjectDetect(u: widget.url);
                              }
                          )
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                      child: Row(
                        children: [
                          Container(
                            height: 160,
                            child: Column(
                              children: [
                                Container(

                                  child: Text(
                                    "Obstacle Detection",
                                    style: GoogleFonts.jockeyOne(
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width-190,
                                  child: Text(
                                    "The headset will recognize the objects around.",

                                    style: GoogleFonts.pattaya(
                                        fontSize: 18
                                    ),
                                    overflow: TextOverflow.fade,
                                  ),
                                )

                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                              width: 100,
                              height:140,
                              child: SvgPicture.asset('images/eye.svg')
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      thickness: 2,
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context){
                                return TextReader(u: widget.url);
                              }
                          )
                      );

                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                      child: Row(
                        children: [
                          Container(
                              width: 140,
                              height:140,
                              child: SvgPicture.asset('images/meet.svg')
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 150,
                            child: Column(
                              children: [
                                Container(

                                  child: Text(
                                    "Text Reader",
                                    style: GoogleFonts.jockeyOne(
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width-190,
                                  child: Text(

                                    "The headset will convert the textual material to audio.",
                                    style: GoogleFonts.pattaya(
                                        fontSize: 18
                                    ),
                                    overflow: TextOverflow.fade,
                                  ),
                                )

                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
}