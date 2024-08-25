import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:volume_controller/volume_controller.dart';

class Audioplayer {
  static final AudioPlayer player = AudioPlayer();
  static final VolumeController volumeCon = VolumeController();
  static late double volumeVal;
  static PlayerState? playerstate;

  static Future<void> init() async {
    playerstate = player.state;

    player.setReleaseMode(ReleaseMode.loop);

    await player.setSourceAsset("sounds/alert.mp3"); 
  }

  static Future<void> playSound() async {
    // volumeVal = await volumeCon.getVolume();
    // volumeCon.setVolume(1);
    await player.resume();
  }

  static Future<void> stopSound() async {
    // volumeCon.setVolume(volumeVal);
    await player.stop();
  }

  static void dispose() {
    player.dispose();
  }
}