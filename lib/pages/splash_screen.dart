import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sleepy/pages/scan_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  double circleSize = 10;
  Color color = Colors.blue;

  late Timer timer;
  late Timer timer2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer2 = Timer(const Duration(milliseconds: 500), () async {
      setState(() {
        circleSize = 258;
        color = Colors.pink;
      });
    });
    timer = Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ScanPage()));
    });
  }
  

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(seconds: 1),
            curve: Curves.bounceOut,
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(1000),
            )
          ),
        )
      ),
    );
  }
}