import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nazar_capstone/register.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Home extends StatefulWidget {
  final Details details;

  Home({Key? key, required this.details}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {
  String name = " ";

  getPref() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    setState(() {
      name =  (prefs.getString('names')??'');
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context){
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

                  Container(
                    color: Color(0xFFFEC8C1),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children:[
                          Container(
                              width: 120,
                              height:100,
                              child: SvgPicture.asset('images/avatar.svg')
                          ),

                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 100,
                            child: Column(
                              children: [
                                Expanded(
                                  child:
                                  Text(
                                    "Hey ${name}!",
                                    style: GoogleFonts.changaOne(
                                      fontSize: 30
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child:
                                  Text(
                                    "Welcome.",
                                    style: GoogleFonts.changaOne(
                                        fontSize: 40
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ]
                      ),
                    ),
                  ),
                  SizedBox(

                    width: 200,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(
                        thickness: 4,
                        color: Color(0xFF1D3ACC),
                      ),
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
                            height: 160,
                            child: Column(
                              children: [
                                 Container(

                                   child: Text(
                                     "Eye Mode",
                                      style: GoogleFonts.jockeyOne(
                                        fontSize: 30,
                                      ),
                                    ),
                                 ),
                                Container(
                                  width: MediaQuery.of(context).size.width-190,
                                  child: Text(
                                    "The headset will work as your eyes relaying all the information.",

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
                              width: 140,
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
                                    "Face Mode",
                                    style: GoogleFonts.jockeyOne(
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width-190,
                                  child: Text(

                                    "The headset will recognise faces.If new, you can save it for future interactions",
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
                            height: 160,

                            child: Column(
                              children: [
                                Container(

                                  child: Text(
                                    "Neutral Mode",
                                    style: GoogleFonts.jockeyOne(
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width-190,
                                  child: Text(
                                    "The headset won't send any outputs. Have your peace.",

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
                              width: 140,
                              height:140,
                              child: SvgPicture.asset('images/neutral.svg')
                          ),
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
