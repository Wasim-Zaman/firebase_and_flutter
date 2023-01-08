import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import './pages/signup_page.dart';
import './pages/login_page.dart';
import './pages/splash_page.dart';
import 'pages/post_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        // scaffoldBackgroundColor: ThemeData.dark().scaffoldBackgroundColor,
      ),

      // home: const HomePage(),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const SplashScreen(),
        ),
        GetPage(
          name: LoginPage.pageName,
          page: () => const LoginPage(),
        ),
        GetPage(
          name: SignupPage.pageName,
          page: () => const SignupPage(),
        ),
        GetPage(
          name: PostPage.pageName,
          page: () => PostPage(),
        ),
      ],
    );
  }
}
