import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';

// import './login_with_phone_page.dart';
import './signup_page.dart';
import './post_page.dart';

import '../common/widgets/custom_row_button.dart';
import '../services/auth_services.dart';
import '../widgets/shimmer_button.dart';
import '../utilities/utilities.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const String pageName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation? _animation;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;

  var isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween(begin: 0.7, end: 1.0).animate(_animationController!);
  }

  void saveForm() async {
    if (_formKey.currentState!.validate()) {
      Utilities.showGoodToast("Logging in...");
      AuthServices()
          .login(_emailController.text, _passwordController.text)
          .then((value) {
        Utilities.showGoodToast("Logged in successfully.");
        Future.delayed(const Duration(seconds: 2))
            .then((value) => Get.offAllNamed(PostPage.pageName));
      }).catchError((error) {
        if (error.code == 'user-not-found') {
          print('No user found for that email.');
          Utilities.showBadToast("No user found for that email.");
        } else if (error.code == 'wrong-password') {
          print('Wrong password provided for that user.');
          Utilities.showBadToast("Wrong password provided for that user.");
        } else {
          Utilities.showBadToast(error.toString());
        }
        setState(() {
          isPressed = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _formKey.currentState?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Utilities.getSystemUIOverlayStyle(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.teal,
                        highlightColor: Colors.tealAccent,
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (EmailValidator.validate(value) == false) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Password',
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      isPressed
                          ? ShimmerButton(
                              text: 'Login',
                              onPressed: saveForm,
                            )
                          : FadeTransition(
                              opacity: _animation as Animation<double>,
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      // Perform login
                                      setState(() {
                                        isPressed = true;
                                      });
                                      _animationController!.forward();
                                      saveForm();
                                    }
                                  },
                                  child: const Text('Log In'),
                                ),
                              ),
                            ),
                      const SizedBox(height: 30.0),
                      CustomRowButton(
                        text: 'Don\'t have an account?',
                        onPressed: () {
                          // Navigate to sign up page
                          Get.offAndToNamed(SignupPage.pageName);
                        },
                        buttonText: 'Sign Up',
                      ),
                      const SizedBox(height: 30),
                      // GestureDetector(
                      //   onTap: () {
                      //     // Navigate to forgot password page
                      //     Get.toNamed(LoginWithPhonePage.pageName);
                      //   },
                      //   child: Container(
                      //     height: 50,
                      //     width: double.infinity,
                      //     decoration: BoxDecoration(
                      //       // color: Colors.grey[200],
                      //       borderRadius: BorderRadius.circular(10),
                      //       border: Border.all(
                      //         color: Colors.teal,
                      //         width: 2,
                      //       ),
                      //     ),
                      //     child: const Center(
                      //       child: Text('Login using phone'),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
