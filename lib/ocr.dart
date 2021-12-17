import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nazar_capstone/home.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class TextReader extends StatefulWidget {
  final String u;
  TextReader({Key? key, required this.u}) : super(key: key);

  //TextReader(this.u);

  @override
  _TextReaderState createState() => _TextReaderState();
}

class _TextReaderState extends State<TextReader> {
  bool _loading = false;
  String _extractText = '';
  late File imag;
  //String url = u;
  late Image img;
  late Directory tempDir;
  String finalText='';
  FlutterTts tts = FlutterTts();
  static const duration1= const Duration(seconds: 8);
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  void _initSpeech() async {
    print("hello");
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    print("22");
    command();
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  void command(){
    switch(_lastWords.toLowerCase()) {
      case 'home': {
        // statements;
        Navigator.pop(context);
      }
      break;

      default: {
        //statements;
        print('Not Valid Arguments');
      }
      break;
    }
  }


  Future<void> getData() async{
    var rng = new Random();
    http.Response request = await http.get(widget.u+'/highres-jpg');
    img=Image.memory(request.bodyBytes);
    tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    imag=File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
    await imag.writeAsBytes(request.bodyBytes);
    _extractText = await FlutterTesseractOcr.extractText(imag.path);
    setState(() {
      finalText=_extractText;
      _loading=true;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initSpeech();
    Timer.periodic(duration1, (timer) {
      getData().then((value) {
        if(_loading){
          tts.speak(finalText);
        }else{
          tts.speak("reading text");
        }
      });

    });

  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();

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
                  !_loading?Container(child: Text("image here")):Container(
                    width: MediaQuery.of(context).size.width,
                    height: 320,
                    child: img,
                  ),
                  !_loading?Container(child: Text("read text here"),):
                  Container(
                    child: Text(_extractText),
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