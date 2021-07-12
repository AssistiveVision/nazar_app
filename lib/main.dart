import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:nazar_capstone/register.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xFFF4717F),
        accentColor: Color(0xFF544E50),
        primarySwatch: Colors.blue,
      ),
      home: Transition(),
    );
  }
}

class Transition extends StatefulWidget {

  @override
  _TransitionState createState() => _TransitionState();
}

class _TransitionState extends State<Transition> with TickerProviderStateMixin
{

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 5),
    vsync: this,
  )..forward();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Material(
      child: Container(
        color: Color(0xFFE7004C),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 150,horizontal: 20),
          child: Center(
            child: Stack(
                fit: StackFit.loose,
                children:[
                  SpinKitRipple(
                    duration: Duration(seconds: 5),
                    size: 400,
                    color: Colors.white70,
                  ),
                  Center(
                    child: Hero(
                      tag: 'logo',
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MyRoute(builder: (context,){return Register();}));
                        },
                        child: ScaleTransition(
                          scale: _animation,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 80,

                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Image.asset('images/nazar_logo.png')),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(

                      child:Align(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedTextKit(
                            animatedTexts:[
                              FadeAnimatedText(
                                  "Let's GO",
                                textStyle: GoogleFonts.carterOne(
                                  fontSize: 30,

                                  fontStyle: FontStyle.italic,
                                  color: Colors.white70
                                )
                              )
                            ],
                          repeatForever: true,
                        ),
                      )
                  )
                ]
            ),
          ),
        ),
      ),
    );
  }
}
class MyRoute extends MaterialPageRoute {

  MyRoute({required WidgetBuilder builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => Duration(seconds: 2);
}

