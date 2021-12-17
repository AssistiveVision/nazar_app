import 'dart:async';
import 'dart:convert';
//import 'dart:html';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiver/collection.dart';
import 'package:nazar_capstone/detector_painters.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class FaceDetect extends StatefulWidget {
  final String u;
  FaceDetect({Key? key,required this.u}) : super(key: key);

  @override
  _FaceDetectState createState() => _FaceDetectState();
}

class _FaceDetectState extends State<FaceDetect> {
  late File jsonFile;
  dynamic _scanResults;
  //String url="https://www.deccanherald.com/sites/dh/files/article_images/2019/03/21/narendra%20modi%20afp-1553136851.jpg";
  var inputImage;
  //var inputImageData;
  late img.Image myImage;
  final faceDetector = GoogleMlKit.vision.faceDetector();
  //DataBaseService _dataBaseService = DataBaseService();
  var interpreter;
  double threshold = 1.0;
  late List _predictedData;
  List get predictedData => this._predictedData;
  //  saved users data
  dynamic data = {};
  late Directory tempDir;
  List e1=[];
  bool _faceFound = false;
  String _name='';
  bool _loading = false;
  static const duration1= const Duration(seconds: 2);
  //late List<Face> faces;
  bool done = false;
  late File imag;
  FlutterTts tts = FlutterTts();
  static const duration= const Duration(seconds: 1);
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  late Image pict;
  bool pic_load=false;

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


  Future loadModel() async {
    //Delegate delegate;
    try {

      interpreter = await Interpreter.fromAsset('mobilefacenet.tflite');
      print('model loaded successfully');
    } catch (e) {
      print('Failed to load model.');
      print(e);
    }
  }

  void faceDet() async{
    await loadModel();
    tempDir = await getApplicationDocumentsDirectory();
    String _embPath = tempDir.path + '/emb.json';
    jsonFile = new File(_embPath);
    if (jsonFile.existsSync()) data = json.decode(jsonFile.readAsStringSync());
    await faceDetector.processImage(inputImage).then((faces) {
      if(faces.isNotEmpty){
        print("22");
      }else{
        print("no");
      }
      String res;
      dynamic finalResult = Multimap<String, Face>();

      Face _face;
      for(_face in faces){
        double x, y, w, h;
        x = (_face.boundingBox.left - 10);
        x = myImage.width.toDouble()-x;
        y = (_face.boundingBox.top - 10);
        w = (_face.boundingBox.width + 10);
        h = (_face.boundingBox.height + 10);
        img.Image croppedImage = img.copyCrop(
            myImage, x.round(), y.round(), w.round(), h.round());
        croppedImage = img.copyResizeCropSquare(croppedImage, 112);
        res = _recog(croppedImage);
        finalResult.add(res, _face);
      }
      setState(() {
        _scanResults=finalResult;
        _loading=true;
      });
      print(_scanResults.keys);
    }
    );
  }


  String _recog(img.Image img) {
    List input = imageToByteListFloat32(img, 112, 128, 128);
    input = input.reshape([1, 112, 112, 3]);
    List output = List.filled(1 * 192,0).reshape([1, 192]);
    interpreter.run(input, output);
    output = output.reshape([192]);
    e1 = List.from(output);
    return compare(e1).toUpperCase();
  }

  Float32List imageToByteListFloat32(
      img.Image image, int inputSize, double mean, double std) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (img.getRed(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getGreen(pixel) - mean) / std;
        buffer[pixelIndex++] = (img.getBlue(pixel) - mean) / std;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }

  String compare(List currEmb) {
    if (data.length == 0) return "No Face saved";
    double minDist = 999;
    double currDist = 0.0;
    String predRes = "NOT RECOGNIZED";
    for (String label in data.keys) {
      currDist = euclideanDistance(data[label], currEmb);
      if (currDist <= threshold && currDist < minDist) {
        minDist = currDist;
        predRes = label;
      }
    }
    print(minDist.toString() + " " + predRes);
    return predRes;
  }

  double euclideanDistance(List e1, List e2) {
    double sum = 0.0;
    for (int i = 0; i < e1.length; i++) {
      sum += pow((e1[i] - e2[i]), 2);
    }
    return sqrt(sum);
  }

  Future<void> getData() async{
    http.Response request = await http.get(widget.u+'/jpg');
    if(request.contentLength!=0){
      //print("wow");
      var rng = new Random();
      myImage=img.decodeImage(request.bodyBytes)!;
      pict = Image.memory(request.bodyBytes);
      tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      imag=File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
      await imag.writeAsBytes(request.bodyBytes);

      inputImage=InputImage.fromFilePath(imag.path);
      print("1");
      //print(inputImage.toString());
      setState(() {
        pic_load=true;
      });
    }

    //List<Face> faces = await faceDetector.processImage(inputImage);
  }

  void _handle(String text) {
    data[text] = e1;
    jsonFile.writeAsStringSync(json.encode(data));
    faceDet();
  }

  void _resetFile() {
    data = {};
    jsonFile.deleteSync();
  }

  Widget _buildResults() {
    const Text noResultsText = const Text('');
    if (_scanResults == null ) {
      return noResultsText;
    }
    CustomPainter painter;

    final Size imageSize = Size(
      myImage.height.toDouble(),
      myImage.width.toDouble(),
    );
    painter = FaceDetectorPainter(imageSize, _scanResults);
    return CustomPaint(
      painter: painter,
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initSpeech();
    if(mounted){
      Timer.periodic(duration, (timer) {
        getData().then((value) =>faceDet());
      });

      Timer.periodic(duration1, (timer) {
        if(_scanResults!=null){
          for(String label in _scanResults.keys){
            tts.speak(label);
          }
        }
      });
    }

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
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 320,
                    child: !pic_load?Container(child: Text("face image here")):Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        pict,
                        _buildResults(),
                      ],
                    ),

                  ),
                  !_loading?Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text("face not found"),
                  ):Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text("face found"),
                  ),

                  TextField(
                    decoration: InputDecoration(

                        prefixIcon: Icon(Icons.phone_android_rounded),
                        hintText: 'Enter Name',
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
                      _name=value.toString();
                    },
                  ),
                  ElevatedButton(
                    onPressed:(){
                      _handle(_name.toUpperCase());

                    },
                    child: Text("ADD FACE"),
                  ),
                  ElevatedButton(
                    onPressed:(){
                      _resetFile();

                    },
                    child: Text("Reset"),
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
