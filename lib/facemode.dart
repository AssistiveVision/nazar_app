import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nazar_capstone/live_detect.dart';
import 'package:nazar_capstone/main.dart';


class Facemode extends StatefulWidget {
  //const Facemode({Key key}) : super(key: key);

  @override
  _FacemodeState createState() => _FacemodeState();
}

class _FacemodeState extends State<Facemode> {


  @override
  void initState(){
    // TODO: implement initState
    super.initState();

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
                                    "Face Detector",
                                    style: GoogleFonts.jockeyOne(
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width-190,
                                  child: Text(
                                    "The headset will recognize person.",

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
                                    "Add face",
                                    style: GoogleFonts.jockeyOne(
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width-190,
                                  child: Text(

                                    "Add face of new person in library",
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