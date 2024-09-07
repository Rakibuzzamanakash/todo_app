import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize SplashController to start the login check
    final SplashController splashController = Get.put(SplashController());

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Can customize the splash screen UI
      ),
    );
  }
}
