import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:carb_app/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

import 'main.dart';
class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  //Code borrowed from https://medium.flutterdevs.com/live-object-detection-app-with-flutter-and-tensorflow-lite-a6e7f7af3b07

  var cameraImage;
  var cameraController;
  var recognitionsList = [];

  Future loadModel() async {
    Tflite.close();
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt"
    );
  }

  initCamera() {
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((value) {
      if (!mounted) return;
      setState(() {
        cameraController.startImageStream((image) {
          cameraImage = image;
          runModel();
        });
      });
    });
  }

  runModel() async {
    recognitionsList = (await Tflite.detectObjectOnFrame(
        bytesList: List<Uint8List>.from(cameraImage.planes.map((plane) {
          return plane.bytes;
        })).toList(),
      imageHeight: cameraImage.height,
      imageWidth: cameraImage.width,
        imageMean: 127.5,
      imageStd: 127.5,
      numResultsPerClass: 1,
      threshold: 0.4,
    ))!;

    setState(() {
      cameraImage;
    });
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (recognitionsList == null) return [];

    double factorX = screen.width;
    double factorY = screen.height;

    Color colorPick = Colors.pink;

    return recognitionsList.map((result) {
      return Positioned(
        left: result["rect"]["x"] * factorX,
        top: result["rect"]["y"] * factorY,
        width: result["rect"]["w"] * factorX,
        height: result["rect"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: colorPick, width: 2.0),
          ),
          child: Text(
            "${result["detectedClass"]} ${result['confidenceInClass']}"
          ),
        ),
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();

    loadModel();
    initCamera();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> list = [];

    list.add(
      Positioned(
        top: 0.0,
        left: 0.0,
        width: size.width,
        height: size.height - 100,
        child: Container(
          height: size.height - 100,
          child: (!cameraController.value.isInitialized)
              ? new Container()
              : AspectRatio(
            aspectRatio: cameraController.value.aspectRatio,
            child: CameraPreview(cameraController),
          ),
        ),
      ),
    );

    if (cameraImage != null) {
      list.addAll(displayBoxesAroundRecognizedObjects(size));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Title"),
      ),
      body: Container(
        child: Stack(
          children: list
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          var push = Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        },
        child: Icon(Icons.square),
      )
    );
  }
}
