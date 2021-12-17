import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:nazar_capstone/recognition.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiver/collection.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:dio/dio.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class ObjectDetect extends StatefulWidget {
  final String u;
  ObjectDetect({Key? key,required this.u}) : super(key: key);

  @override
  _ObjectDetectState createState() => _ObjectDetectState();
}

class _ObjectDetectState extends State<ObjectDetect> {
  late Interpreter interpreter;
  late List<String> labels=[];
  final int _labelsLength = 91;
  var imageProcessor;
  late int padSize;
  List<List<int>> _outputShapes=[];
  List<TfLiteType> _outputTypes=[];
  static const int INPUT_SIZE = 300;
  static const int NUM_RESULTS = 10;
  static const double THRESHOLD = 0.5;
  late img.Image myImage;
  FlutterTts tts = FlutterTts();
  //String url='https://thumbor.forbes.com/thumbor/fit-in/1200x0/filters%3Aformat%28jpg%29/https%3A%2F%2Fspecials-images.forbesimg.com%2Fimageserve%2F5d35eacaf1176b0008974b54%2F0x0.jpg%3FcropX1%3D790%26cropX2%3D5350%26cropY1%3D784%26cropY2%3D3349';
  late Map<String, dynamic> result;
  static const duration1= const Duration(seconds: 1);
  static const duration= const Duration(seconds: 3);
  static const duration2= const Duration(seconds: 10);
  late double ratioX,ratioY,transX,transY,transWidth,transHeight;
  var response;
  late File imag;
  late Directory tempDir;
  var dio = Dio();
  late Image pict;
  String depth='0';
  var dist = {
    '-1':'very near',
    '0':'near',
    '1':'far'
  };
  bool _load=false;
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  bool pic_load=false;
  bool result_load = false;

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

      interpreter = await Interpreter.fromAsset('detect.tflite');
      var outputTensors = interpreter.getOutputTensors();
      _outputShapes = [];
      _outputTypes = [];
      outputTensors.forEach((tensor) {
        _outputShapes.add(tensor.shape);
        _outputTypes.add(tensor.type);
      });
      print('model loaded successfully');
    } catch (e) {
      print('Failed to load model.');
      print(e);
    }
  }

  Future<void> loadLabels() async {
    labels = await FileUtil.loadLabels('assets/labelmap.txt');
    if (labels.length == _labelsLength) {
      print('Labels loaded successfully');
    } else {
      print('Unable to load labels');
    }
  }

  TensorImage getProcessedImage(TensorImage inputImage) {
    padSize = max(inputImage.height, inputImage.width);
    if (imageProcessor == null) {
      imageProcessor = ImageProcessorBuilder()
          .add(ResizeWithCropOrPadOp(padSize, padSize))
          .add(ResizeOp(INPUT_SIZE, INPUT_SIZE, ResizeMethod.BILINEAR))
          .build();
    }
    inputImage = imageProcessor.process(inputImage);
    return inputImage;
  }

  Map<String, dynamic> predict(img.Image image) {
    var predictStartTime = DateTime.now().millisecondsSinceEpoch;

    if (interpreter == null) {
      print("Interpreter not initialized");
      //return null;
    }

    var preProcessStart = DateTime.now().millisecondsSinceEpoch;

    // Create TensorImage from image
    TensorImage inputImage = TensorImage.fromImage(image);

    // Pre-process TensorImage
    inputImage = getProcessedImage(inputImage);

    var preProcessElapsedTime =
        DateTime.now().millisecondsSinceEpoch - preProcessStart;

    // TensorBuffers for output tensors
    TensorBuffer outputLocations = TensorBufferFloat(_outputShapes[0]);
    TensorBuffer outputClasses = TensorBufferFloat(_outputShapes[1]);
    TensorBuffer outputScores = TensorBufferFloat(_outputShapes[2]);
    TensorBuffer numLocations = TensorBufferFloat(_outputShapes[3]);

    // Inputs object for runForMultipleInputs
    // Use [TensorImage.buffer] or [TensorBuffer.buffer] to pass by reference
    List<Object> inputs = [inputImage.buffer];

    // Outputs map
    Map<int, Object> outputs = {
      0: outputLocations.buffer,
      1: outputClasses.buffer,
      2: outputScores.buffer,
      3: numLocations.buffer,
    };

    var inferenceTimeStart = DateTime.now().millisecondsSinceEpoch;

    // run inference
    interpreter.runForMultipleInputs(inputs, outputs);

    var inferenceTimeElapsed =
        DateTime.now().millisecondsSinceEpoch - inferenceTimeStart;

    // Maximum number of results to show
    int resultsCount = min(NUM_RESULTS, numLocations.getIntValue(0));

    // Using labelOffset = 1 as ??? at index 0
    int labelOffset = 1;

    // Using bounding box utils for easy conversion of tensorbuffer to List<Rect>
    List<Rect> locations = BoundingBoxUtils.convert(
      tensor: outputLocations,
      valueIndex: [1, 0, 3, 2],
      boundingBoxAxis: 2,
      boundingBoxType: BoundingBoxType.BOUNDARIES,
      coordinateType: CoordinateType.RATIO,
      height: INPUT_SIZE,
      width: INPUT_SIZE,
    );

    List<Recognition> recognitions = [];

    for (int i = 0; i < resultsCount; i++) {
      // Prediction score
      var score = outputScores.getDoubleValue(i);

      // Label string
      var labelIndex = outputClasses.getIntValue(i) + labelOffset;
      var label = labels.elementAt(labelIndex);

      if (score > THRESHOLD) {
        // inverse of rect
        // [locations] corresponds to the image size 300 X 300
        // inverseTransformRect transforms it our [inputImage]
        Rect transformedRect = imageProcessor.inverseTransformRect(
            locations[i], image.height, image.width);
        Size screenSize = MediaQuery.of(context).size;

        ratioX= screenSize.width/300;
        ratioY = ratioX;
        transX=((transformedRect.left+transformedRect.width)/2)*ratioX;
        transY=((transformedRect.right+transformedRect.height)/2)*ratioY;
        transWidth = min(
            transformedRect.width * ratioX, screenSize.width);
        transHeight = min(
            transformedRect.height * ratioY, screenSize.width*ratioX);
        recognitions.add(
          Recognition(i, label, score,transformedRect,screenSize),

        );
      }
    }

    var predictElapsedTime =
        DateTime.now().millisecondsSinceEpoch - predictStartTime;

    return {
      "recognitions": recognitions,
    };

  }

  Future<void> getData() async{
    http.Response request = await http.get(widget.u+'/jpg');
    if(request.contentLength!=0){
      //print("wow");
      var rng = new Random();
      myImage=img.decodeImage(request.bodyBytes)!;
      pict=Image.memory(request.bodyBytes);
      tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      imag=File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
      await imag.writeAsBytes(request.bodyBytes);

      setState(() {
        pic_load=true;
      });
    }}

  Future<void> getDepth() async{

    var formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(imag.path,filename: 'car.jpg'),
      'x':transX.toInt(),
      'y':transY.toInt(),
      'w':transWidth.toInt(),
      'h':transHeight.toInt()
    });
    var request = await dio.post('http://172.105.59.194:8000/api/depth_perception/',data: formData);
    print("ok");
    print(request.data);
    if(mounted){
      setState(() {
        depth=request.data.toString();
        _load=true;
      });

    }

    //print(json.decode(request.body));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initSpeech();
    loadModel().then((value) => loadLabels());
    if(mounted){
      Timer.periodic(duration1, (timer) {
        getData().then((value) {
          result=predict(myImage);
          print(result["recognitions"][0].label);
          setState(() {
            result_load=true;
          });

        });
      });
      Timer.periodic(duration2, (timer) {getDepth(); });

      Timer.periodic(duration, (timer) {
        if(_load){
          tts.speak(result["recognitions"][0].label.toString()+'is'+dist[depth]!);
        }else{
          tts.speak(result["recognitions"][0].label.toString());
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
                  !pic_load?Container(child: Text("image here")):
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 320,
                    child: pict,
                  ),
                  result_load?
                      Container(
                        child: Text(result["recognitions"][0].label.toString()),
                      ):Container(
                    child: Text("label here"),
                  ),

                  ElevatedButton(
                    onPressed:(){
                     tts.stop();

                    },
                    child: Text("STOP"),
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
