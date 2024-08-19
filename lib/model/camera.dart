import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sleepy/model/flutter_vision.dart';
import 'package:sleepy/partials/notification.dart';

class Camera {

  static late CameraController camCon;
  
  static Future<void> init(BuildContext context) async {

    List<CameraDescription> cameraDesc = await availableCameras();

    camCon = CameraController(cameraDesc[0], ResolutionPreset.high);

    camCon.initialize().then((value) {

    }).catchError((err) {
       if (err is CameraException) {
        switch (err.code) {
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


}
