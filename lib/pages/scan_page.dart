import 'package:flutter/material.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String textButton = "OFF";
  Alignment align = Alignment.centerLeft;


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
            Container(
              height: 452,
              decoration: BoxDecoration(
                  color: Colors.pink, borderRadius: BorderRadius.circular(20)),
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
                      }else {
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
                    child: Text(textButton)
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
