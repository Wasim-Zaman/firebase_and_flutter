import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../services/splash_screen_services.dart';

import '../utilities/utilities.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashServices _splashServices = Get.put(SplashServices());

  initState() {
    super.initState();
    _splashServices.isLogin();
    // Future.delayed(
    //   const Duration(seconds: 3),
    //   () {
    //     Navigator.pushReplacementNamed(context, '/login');
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      // backgroundColor: Colors.black,
      body: Center(
        child: Utilities.showShimmer(
            Colors.teal, Colors.tealAccent, "Flutter Firebase"),
      ),
    );
  }
}
