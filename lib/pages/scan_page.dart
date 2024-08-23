import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sleepy/model/camera.dart';
import 'package:sleepy/model/flutter_vision.dart';
import 'package:sleepy/model/push_notification.dart';
// import 'package:sleepy/partials/notification.dart';

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
                              : textButton == "ON"
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
                                              color: Colors.grey, fontSize: 25),
                                        )
                                      ],
                                    )
                                  : CameraPreview(Camera.camCon),
                          ...yoloRes.map((value) {
                            var iw = Camera.camCon.value.previewSize!.height;
                            var ih = Camera.camCon.value.previewSize!.width;
                            var fx = boxConst.maxWidth / iw;
                            var fy = (iw * fx / (iw / ih)) / ih;

                            // Tampilkan Box
                            return Positioned(
                              left: value["box"][0] * fx,
                              top: value["box"][1] * fy,
                              width: (value["box"][2] - value["box"][0]) * fx,
                              height: (value["box"][3] - value["box"][1]) * fy,
                              child: Container(
                                decoration: BoxDecoration(border: Border.all(color: Colors.pink, width: 2)),
                              ),
                            );
                          }).toList(),
                          ...yoloRes.map((value) {
                            var iw = Camera.camCon.value.previewSize!.height;
                            var ih = Camera.camCon.value.previewSize!.width;
                            var fx = boxConst.maxWidth / iw;
                            var fy = (iw * fx / (iw / ih)) / ih;

                            // Tampilkan Box
                            return Positioned(
                              left: value["box"][0] * fx,
                              top: value["box"][1] * fy - 14,
                              child: Text("${(value["tag"]).split("_").join(" ")} ${(value["box"][4] * 100).toStringAsFixed(0)}%", style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                background: Paint()..color = Colors.pink,
                              ),)
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
                            yoloRes.clear();
                            textButton = "ON";
                            align = Alignment.centerRight;
                          });
                          print("##############################");
                          print(yoloRes);
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