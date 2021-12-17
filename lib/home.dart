import 'package:nazar_capstone/object.dart';
import 'package:nazar_capstone/ocr.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nazar_capstone/eyemode.dart';
import 'package:nazar_capstone/register.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'face.dart';


class Home extends StatefulWidget {
  final Details details;

  Home({Key? key, required this.details}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {
  String name = " ";
  String url = details.key;
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initSpeech();
    getPref();

  }

  /// This has to happen only once per app
  void _initSpeech() async {
    print("hello");
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    print("22");
    command();
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  void command(){
    switch(_lastWords.toLowerCase()) {
      case 'i mode': {
        // statements;
        Navigator.push(context,
            MaterialPageRoute(
                builder: (context){
                  return ObjectDetect(u: url);
                }
            )
        );
      }
      break;

      case 'imode': {
        // statements;
        Navigator.push(context,
            MaterialPageRoute(
                builder: (context){
                  return ObjectDetect(u: url);
                }
            )
        );
      }
      break;

      case 'eyemode': {
        // statements;
        Navigator.push(context,
            MaterialPageRoute(
                builder: (context){
                  return ObjectDetect(u: url);
                }
            )
        );
      }
      break;

      case 'eye mode': {
        // statements;
        Navigator.push(context,
            MaterialPageRoute(
                builder: (context){
                  return ObjectDetect(u: url);
                }
            )
        );
      }
      break;

      case 'text reader': {
        // statements;
        Navigator.push(context,
            MaterialPageRoute(
                builder: (context){
                  return TextReader(u: url);
                }
            )
        );
      }
      break;

      case 'textreader': {
        // statements;
        Navigator.push(context,
            MaterialPageRoute(
                builder: (context){
                  return TextReader(u: url);
                }
            )
        );
      }
      break;

      case 'face mode': {
        // statements;
        Navigator.push(context,
            MaterialPageRoute(
                builder: (context){
                  return FaceDetect(u: url);
                }
            )
        );
      }
      break;

      case 'facemode': {
        // statements;
        Navigator.push(context,
            MaterialPageRoute(
                builder: (context){
                  return FaceDetect(u: url);
                }
            )
        );
      }
      break;

      default: {
        //statements;
        print('Not Valid Arguments');
      }
      break;
    }
  }

  getPref() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    setState(() {
      name =  (prefs.getString('names')??'');
    });
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
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context){
                                return Eyemode(url: url);
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
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context){
                                return FaceDetect(u: url,);
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
        floatingActionButton: FloatingActionButton(
          onPressed:
          // If not yet listening for speech start, otherwise stop
          _speechToText.isNotListening ? _startListening : _stopListening,
          // If not yet listening for speech start, otherwise stop

          tooltip: 'Listen',
          child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
        ),
      ),
    );
  }
}
