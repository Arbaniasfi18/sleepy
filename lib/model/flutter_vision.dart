import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';

class FlutVission {

  static final FlutterVision vision = FlutterVision();  

  static Future<void> loadModel() async {
    await vision.loadYoloModel(
      modelPath: "assets/tflite/yolo_model.tflite",
      labels: "assets/tflite/labels.txt",
      modelVersion: "yolov8",
      numThreads: 2,
      useGpu: false,
    );
    print("success load model");
  }

  static Future<List<Map<String, dynamic>>> onFrame(CameraImage camImg) async {
    final result = await vision.yoloOnFrame(
      bytesList: camImg.planes.map((plane) => plane.bytes).toList(), 
      imageHeight: camImg.height, 
      imageWidth: camImg.width,
      iouThreshold: 0.4,
      confThreshold: 0.4,
      classThreshold: 0.5
    );

    return result;
  }

}