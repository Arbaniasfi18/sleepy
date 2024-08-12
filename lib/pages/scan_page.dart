import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sleepy/partials/notification.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String textButton = "OFF";
  Alignment align = Alignment.centerLeft;
  late CameraController camCon;
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  void dispose() {
    camCon.dispose();
    super.dispose();
  }

  init() async {
    List<CameraDescription> cameras = await availableCameras();
    camCon = CameraController(cameras[1], ResolutionPreset.high);
    camCon.initialize().then((value) {
      setState(() {
        loading = false;
      });
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
                  aspectRatio: 2 / 3,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: loading
                        ? const Center(
                            child:
                                CircularProgressIndicator(color: Colors.green))
                        : CameraPreview(camCon),
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
                      onPressed: () {
                        if (textButton == "OFF") {
                          setState(() {
                            textButton = "ON";
                            align = Alignment.centerRight;
                          });
                        } else {
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
