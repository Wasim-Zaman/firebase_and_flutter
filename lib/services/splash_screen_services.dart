import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../pages/post_page.dart';
import '../pages/login_page.dart';

class SplashServices {
  void isLogin() {
    Timer(
      const Duration(seconds: 3),
      () {
        if (FirebaseAuth.instance.currentUser != null) {
          Get.offAllNamed(PostPage.pageName);
        } else {
          Get.offAllNamed(LoginPage.pageName);
        }
      },
    );
  }
}
