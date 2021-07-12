import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nazar_capstone/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Details{
  String name = "name";
  String mobile = "mobile";
  String key = "key";

  Details(this.name,this.key,this.mobile);
}
var details = new Details(" ", " ", " ");

class Register extends StatefulWidget {

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {


  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
          child: Container(
            color: Color(0xFFE7004C),
            child: Stack(

              children:[
                Row(
                  children: [
                    Container(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Hero(
                          tag: 'logo',
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 60,
                            child: Padding(
                                padding:EdgeInsets.all(10),
                                child: Image.asset('images/nazar_logo.png')
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child:  Padding(
                          padding: EdgeInsets.all(10),
                          child: AnimatedTextKit(
                              animatedTexts: [
                                RotateAnimatedText(
                                    "Register Yourself",
                                  textStyle: GoogleFonts.sairaStencilOne(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                                RotateAnimatedText(
                                    "One Time Only",
                                    textStyle: GoogleFonts.sairaStencilOne(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold
                                    )
                                ),
                                RotateAnimatedText(
                                    "See The World Again!",
                                    textStyle: GoogleFonts.sairaStencilOne(
                                      fontSize: 35,
                                        fontWeight: FontWeight.bold
                                    )
                                ),
                              ],
                            repeatForever: true,
                          ),
                        )
                    )
                  ],
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.7,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(65),topRight: Radius.circular(65))
                    ),

                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 30,horizontal: 40),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              TextField(

                                decoration: InputDecoration(

                                  prefixIcon: Icon(Icons.account_circle),
                                  hintText: 'Enter your name',
                                  hintStyle: GoogleFonts.alatsi(
                                    fontWeight: FontWeight.bold
                                  ),

                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFFE7004C),width: 3),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(100)
                                    ),

                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100)
                                      ),
                                    borderSide: BorderSide(color: Color(0xFFE7004C),width: 3)
                                  )
                                )
                                ,

                                onChanged: (value){
                                  details.name = value.toString();
                                },
                                keyboardType: TextInputType.name,

                                
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                decoration: InputDecoration(

                                    prefixIcon: Icon(Icons.phone_android_rounded),
                                  hintText: 'Enter mobile number',
                                    hintStyle: GoogleFonts.alatsi(
                                        fontWeight: FontWeight.bold
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFE7004C),width: 3),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100)
                                      ),

                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)
                                        ),
                                        borderSide: BorderSide(color: Color(0xFFE7004C),width: 3)
                                    )
                                ),
                                onChanged: (value){
                                  details.mobile = value.toString();
                                },
                                keyboardType: TextInputType.phone,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                decoration: InputDecoration(

                                    prefixIcon: Icon(Icons.vpn_key_rounded),
                                  hintText: 'Enter Product key',
                                    hintStyle: GoogleFonts.alatsi(
                                        fontWeight: FontWeight.bold
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFE7004C),width: 3),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100)
                                      ),

                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)
                                        ),
                                        borderSide: BorderSide(color: Color(0xFFE7004C),width: 3)
                                    )
                                ),
                                onChanged: (value){
                                  details.key = value.toString();
                                },

                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Color(0xFFE7004C)),
                                overlayColor: MaterialStateProperty.all(Color(0xFF1D3ACC)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Color(0xFF1D3ACC))
                                ))),
                                  onPressed: () async{
                                  if(details.name==" "||details.mobile==" "||details.key==" ")
                                    {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "Can't leave the fields empty"
                                              ),
                                            backgroundColor: Color(0xFFE7004C),
                                          )
                                      );
                                    }
                                  else{
                                    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
                                    SharedPreferences prefs = await _prefs;
                                    prefs.setString('names', details.name);
                                    prefs.setString('key', details.key);
                                    Navigator.push(context, CustomRoute(
                                    )
                                    );
                                  }

                                  },
                                  child: Text('SUBMIT',
                                    style: GoogleFonts.anton(),
                                  )
                              ),
                            ],
                          ),

                          Container(
                            width: 450,
                              height: 160,
                              child: SvgPicture.asset(
                                  'images/vector.svg')
                          )

                        ],
                      ),
                    ),
                  ),
                ),

              ]
            ),
        )
      ),
    );
  }
}

class CustomRoute extends CupertinoPageRoute {
  CustomRoute()
      : super(builder: (BuildContext context) => new Home(details: details));

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: Home(details: details) );
  }
}
