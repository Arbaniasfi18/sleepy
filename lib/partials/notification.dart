import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

cameraAccessNotifDeclined(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text(
              "Izinkan kamera agar dapat menggunakan aplikasi dengan lancar"),
          actions: [
            TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text("Kembali"),
            )
          ],
        );
      });
}
