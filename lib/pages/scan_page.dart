import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sleepy/model/audioplayer.dart';
import 'package:sleepy/model/camera.dart';
import 'package:sleepy/model/flutter_vision.dart';
import 'package:sleepy/model/push_notification.dart';
import 'package:sleepy/partials/color.dart';
import 'package:sleepy/partials/notification.dart';
// import 'package:sleepy/partials/notification.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String textButton = "OFF";
  Alignment align = Alignment.centerRight;
  bool loading = true;
  bool sleepDetected = false;
  double left = 0;
  // late CameraController camCon;
  // late CameraImage camImg;
  List<Map<String, dynamic>> yoloRes = [];
  List<Map<String, dynamic>> temp = [];

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
    Audioplayer.dispose();
  }

  init() async {
    // await Camera.init();
    await PushNotification.init();
    await FlutVission.loadModel();
    await Audioplayer.init();
    setState(() {
      loading = false;
    });
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
    List<String> tes = [];

    setState(() {
      this.yoloRes = yoloRes;
    });
    if (temp.isEmpty) {
      temp = yoloRes;
      return;
    } else {
      // for (var i = 0; i < yoloRes.length; i++) {
      //   print(yoloRes[i]['tag']);
      // }
      for (var ylElement in yoloRes) {
        for (var tmpElement in temp) {
          if (ylElement['tag'] == tmpElement['tag']) {
            tes.add(ylElement['tag']);
          }
        }
      }

      temp = yoloRes;
    }

    bool mataClose = false;
    bool kepalaMiring = false;
    bool mulutOpen = false;

    for (var i = 0; i < tes.length; i++) {
      if (tes[i] == "mata_close") {
        mataClose = true;
      }
      if (tes[i] == "kepala_miring") {
        kepalaMiring = true;
      }
      if (tes[i] == "mulut_open") {
        mulutOpen = true;
      }
    }

    if (mataClose && !mulutOpen) {
      Audioplayer.playSound();
      setState(() {
        sleepDetected = true;
      });
      offCameraState();
    } else if (mataClose && mulutOpen) {
      Audioplayer.playSound();
      setState(() {
        sleepDetected = true;
      });
      offCameraState();
    } else if (mataClose && !kepalaMiring) {
      Audioplayer.playSound();
      setState(() {
        sleepDetected = true;
      });
      offCameraState();
    } else if (mataClose && kepalaMiring) {
      Audioplayer.playSound();
      setState(() {
        sleepDetected = true;
      });
      offCameraState();
    }
  }

  void offCameraState() {
    Camera.camStop(setStateCallback: setStateCallback);

    FlutVission.stopDetection(
        camCon: Camera.camCon,
        setStateCallback: setStateCallback,
        yoloResCallback: yoloResCallback);

    setState(() {
      yoloRes.clear();
      textButton = "OFF";
      align = Alignment.centerRight;
    });
  }

  Future<void> onCameraState(BuildContext context) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text(
              "Gunakan kamera ... ",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              TextButton(
                  onPressed: () async {
                    await Camera.init(1);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                    await Camera.camStart(context, loading: loadingCallback);

                    if (context.mounted) {
                      FlutVission.startDetection(context,
                          camCon: Camera.camCon,
                          camImg: Camera.camImg,
                          yoloResCallback: yoloResCallback);
                    }

                    setState(() {
                      textButton = "ON";
                      align = Alignment.centerLeft;
                    });
                  },
                  child: const Text("Depan")),
              TextButton(
                  onPressed: () async {
                    await Camera.init(0);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                    await Camera.camStart(context, loading: loadingCallback);

                    if (context.mounted) {
                      FlutVission.startDetection(context,
                          camCon: Camera.camCon,
                          camImg: Camera.camImg,
                          yoloResCallback: yoloResCallback);
                    }

                    setState(() {
                      textButton = "ON";
                      align = Alignment.centerLeft;
                    });
                  },
                  child: const Text("Belakang"))
            ],
          );
        });

    // await Camera.camStart(context, loading: loadingCallback);

    // if (context.mounted) {
    //   FlutVission.startDetection(context,
    //       camCon: Camera.camCon,
    //       camImg: Camera.camImg,
    //       yoloResCallback: yoloResCallback);
    // }

    // setState(() {
    //   textButton = "ON";
    //   align = Alignment.centerLeft;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 33.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 70,
                      height: 70,
                      child: Image.asset(
                        "assets/images/logo.png",
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                  ),
                  child: AspectRatio(
                      aspectRatio: 2 / 3.5,
                      // aspectRatio: Camera.camCon.value.aspectRatio,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[350],
                        ),
                        child: LayoutBuilder(builder: (context, boxConst) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              loading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                          color: Colors.green))
                                  : textButton == "OFF"
                                      ? const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.camera_alt,
                                              color: Colors.grey,
                                              size: 50,
                                            ),
                                            Text(
                                              "Camera Paused",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 25),
                                            )
                                          ],
                                        )
                                      : CameraPreview(Camera.camCon),
                              ...yoloRes.map((value) {
                                var iw =
                                    Camera.camCon.value.previewSize!.height;
                                var ih = Camera.camCon.value.previewSize!.width;
                                var fx = boxConst.maxWidth / iw;
                                var fy = (iw * fx / (iw / ih)) / ih;

                                // Tampilkan Box
                                return Visibility(
                                  visible: textButton == "ON" ? true : false,
                                  child: Positioned(
                                    left: value["box"][0] * fx,
                                    top: value["box"][1] * fy,
                                    width: (value["box"][2] - value["box"][0]) *
                                        fx,
                                    height:
                                        (value["box"][3] - value["box"][1]) *
                                            fy,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.pink, width: 2)),
                                    ),
                                  ),
                                );
                              }).toList(),
                              ...yoloRes.map((value) {
                                var iw =
                                    Camera.camCon.value.previewSize!.height;
                                var ih = Camera.camCon.value.previewSize!.width;
                                var fx = boxConst.maxWidth / iw;
                                var fy = (iw * fx / (iw / ih)) / ih;

                                // Tampilkan Box
                                return Visibility(
                                  visible: textButton == "ON" ? true : false,
                                  child: Positioned(
                                      left: value["box"][0] * fx,
                                      top: value["box"][1] * fy - 14,
                                      child: Text(
                                        "${(value["tag"]).split("_").join(" ")} ${(value["box"][4] * 100).toStringAsFixed(0)}%",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          background: Paint()
                                            ..color = Colors.pink,
                                        ),
                                      )),
                                );
                              }).toList(),
                            ],
                          );
                        }),
                      )),
                ),
                const SizedBox(
                  height: 28,
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.yellow[700]!, width: 3),
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 300),
                    alignment: align,
                    child: SizedBox(
                        width: 50,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (textButton == "ON") {
                                // await PushNotification.instantNotification(
                                //     "Ini Peringatan", "Ini Push Notification");
                                offCameraState();
                              } else {
                                onCameraState(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 3,
                              backgroundColor:
                                  textButton == "ON" ? primary : Colors.grey,
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(textButton,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)))),
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: sleepDetected,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color.fromARGB(221, 244, 67, 54),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning_rounded, color: primary, size: 150),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: DefaultTextStyle(
                        style: TextStyle(
                            fontSize: 30,
                            color: secondary,
                            fontWeight: FontWeight.w600),
                        child: const Text(
                          "Anda sedang mengantuk, harap segera menepi dan beristirahat!\nHentikan berkendara lebih lanjut!",
                          textAlign: TextAlign.center,
                        )),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const DefaultTextStyle(
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600),
                      child: Text("Matikan")),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      width: 280,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(color: Colors.grey[600]!, width: 5),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Positioned(
                            left: left,
                            child: Draggable(
                              onDragUpdate: (detail) async {
                                setState(() {
                                  left = detail.localPosition.dx - 84;
                                });

                                if (detail.localPosition.dx < 84) {
                                  setState(() {
                                    left = 0;
                                  });
                                }

                                if (detail.localPosition.dx > 272) {
                                  setState(() {
                                    left = 208;
                                  });
                                }

                                if (left == 208) {
                                  await Audioplayer.stopSound();
                                  left = 0;
                                  setState(() {
                                    sleepDetected = false;
                                  });
                                }
                              },
                              feedback: const SizedBox(),
                              // feedback: Container(
                              //   width: 60,
                              //   height: 60,
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(100),
                              //     color: Colors.blue,
                              //   ),
                              // ),
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.white,
                                ),
                                child: const Center(
                                  child: Icon(Icons.arrow_forward_rounded,
                                      color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}

// List<Widget> displayBoxesAroundRecognizedObjects(Size size) {

// }
