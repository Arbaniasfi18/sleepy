import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
// import 'package:sleepy/model/flutter_vision.dart';
import 'package:sleepy/partials/notification.dart';

class Camera {

  static late CameraController camCon;
  static CameraImage? camImg;


  static Future<void> init(int cameraID) async {

    List<CameraDescription> cameraDesc = await availableCameras();

    camCon = CameraController(cameraDesc[cameraID], ResolutionPreset.high);

  }

  static Future<void> camStart(BuildContext context, {
    required Function loading,
  }) async {

    if (camCon.value.isPreviewPaused) {
      camCon.resumePreview();
    }else {
      await camCon.initialize().then((value) {
        loading(false);
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
  
  static void camStop({
    required Function setStateCallback,
  }) {
    setStateCallback(camCon.pausePreview());
  }

  static void camConDispose() {
    camCon.dispose();
  }

}
