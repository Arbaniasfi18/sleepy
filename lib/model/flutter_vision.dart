import 'dart:ffi';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:sleepy/partials/notification.dart';

class FlutVission {

  static final FlutterVision vision = FlutterVision();  

  static Future<void> loadModel() async {
    await vision.loadYoloModel(
      modelPath: "assets/tflite/yolo_model.tflite",
      labels: "assets/tflite/labels.txt",
      modelVersion: "yolov8",
      numThreads: 1,
      useGpu: false,
    );

    print("Success Load Model");
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

  static Future<void> startDetection(BuildContext context,{
    required CameraController camCon, 
    CameraImage? camImg, 
    required Function yoloResCallback
  }) async {
    await camCon.startImageStream((value) async {
      print(value.height);
      print(value.width);
      camImg = value;

      final res = await FlutVission.onFrame(value);

      if (res.isNotEmpty) {
        yoloResCallback(res);
      }
      print("######################################");
      print("Res = $res");

    }).catchError((error) {
      if (error is CameraException) {
        switch (error.code) {
          case 'CameraAccessDenied':
            cameraAccessNotifDeclined(context);
            break;
          default:
            cameraAccessNotifDeclined(context);
            break;
        }
      }
    });
  }

  static Future<void> stopDetection({
    required CameraController camCon,
    required Function setStateCallback,
    required Function yoloResCallback
  }) async {
    if (camCon.value.isStreamingImages) {
      setStateCallback(camCon.stopImageStream());
    }
    List<Map<String, dynamic>> res = [];
    yoloResCallback(res);
  }

  static Future<void> closeYolo() async {
    await vision.closeYoloModel();
  }

}