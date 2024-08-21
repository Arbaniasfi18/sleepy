import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sleepy/model/camera.dart';
import 'package:sleepy/model/flutter_vision.dart';
import 'package:sleepy/model/push_notification.dart';
import 'package:sleepy/partials/notification.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String textButton = "ON";
  Alignment align = Alignment.centerRight;
  bool loading = true;
  // late CameraController camCon;
  // late CameraImage camImg;
  List<Map<String, dynamic>> yoloRes = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
    Camera.camCon.dispose();
    FlutVission.closeYolo();
  }

  init() async {
    await Camera.init();
    await PushNotification.init();
    await FlutVission.loadModel();
  }

  void loadingCallback(bool loading) {
    setState(() {
      this.loading = loading;
    });
  }

  void setStateCallback(dynamic somethin) {
    setState(() {
      somethin;
    });
  }

  void yoloResCallback(List<Map<String, dynamic>> yoloRes) {
    if (yoloRes.isNotEmpty) {
      setState(() {
        this.yoloRes = yoloRes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 33.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Hello"),
                  Text("Hello"),
                ],
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25),
              ),
              child: Stack(
                children: [
                  AspectRatio(
                      aspectRatio: 2 / 3,
                      // aspectRatio: Camera.camCon.value.aspectRatio,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[350],
                        ),
                        child: loading
                            ? const Center(
                                child:
                                    CircularProgressIndicator(color: Colors.green))
                            : textButton == "ON"
                                ? const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey,
                                        size: 50,
                                      ),
                                      Text(
                                        "Camera Paused",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 25),
                                      )
                                    ],
                                  )
                                : CameraPreview(Camera.camCon),
                      )),
                  // ...displayBoxesAroundRecognizedObjects(MediaQuery.of(context).size),
                  //   Positioned(
                  //     bottom: 75,
                  //     width: MediaQuery.of(context).size.width,
                  //     child: Container(
                  //       height: 80,
                  //       width: 80,
                  //       decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         border: Border.all(
                  //             width: 5, color: Colors.white, style: BorderStyle.solid),
                  //       ),
                  //       child: isDetecting
                  //           ? IconButton(
                  //               onPressed: () async {
                  //                 stopDetection();
                  //               },
                  //               icon: const Icon(
                  //                 Icons.stop,
                  //                 color: Colors.red,
                  //               ),
                  //               iconSize: 50,
                  //             )
                  //           : IconButton(
                  //               onPressed: () async {
                  //                 await startDetection();
                  //               },
                  //               icon: const Icon(
                  //                 Icons.play_arrow,
                  //                 color: Colors.white,
                  //               ),
                  //               iconSize: 50,
                  //             ),
                  //     ),
                  //   ),
                ],
              ),
            ),
            const SizedBox(
              height: 28,
            ),
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                alignment: align,
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (textButton == "OFF") {
                          // await PushNotification.instantNotification(
                          //     "Ini Peringatan", "Ini Push Notification");
                          Camera.camStop(setStateCallback: setStateCallback);

                          FlutVission.stopDetection(
                              camCon: Camera.camCon,
                              setStateCallback: setStateCallback,
                              yoloResCallback: yoloResCallback);

                          setState(() {
                            textButton = "ON";
                            align = Alignment.centerRight;
                          });
                        } else {
                          await Camera.camStart(context,
                              loading: loadingCallback);

                          if (context.mounted) {
                            FlutVission.startDetection(context,
                                camCon: Camera.camCon,
                                camImg: Camera.camImg,
                                yoloResCallback: yoloResCallback);
                          }

                          setState(() {
                            textButton = "OFF";
                            align = Alignment.centerLeft;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(textButton)),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}


// List<Widget> displayBoxesAroundRecognizedObjects(Size size) {

// }