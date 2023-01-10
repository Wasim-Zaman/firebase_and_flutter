import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import './login_page.dart';
import './post_page.dart';
import '../widgets/shimmer_button.dart';
import '../common/widgets/custom_row_button.dart';
import '../utilities/utilities.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();

  static const String pageName = '/signup';
}

class _SignupPageState extends State<SignupPage>
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
      try {
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        Utilities.showGoodToast("Account created successfully.");
        Future.delayed(const Duration(seconds: 2))
            .then((value) => Get.offAllNamed(PostPage.pageName));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Utilities.showBadToast('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          Utilities.showBadToast('The account already exists for that email.');
        }
        setState(() {
          isPressed = false;
        });
      } catch (e) {
        Utilities.showBadToast('Something went wrong.');
        setState(() {
          isPressed = false;
        });
      }
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
                          'Sign Up',
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
                        keyboardType: TextInputType.visiblePassword,
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
                          ? ShimmerButton(text: 'Sign up', onPressed: saveForm)
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
                                    // Perform login
                                  },
                                  child: const Text('Sign up'),
                                ),
                              ),
                            ),
                      const SizedBox(height: 30.0),
                      CustomRowButton(
                        text: 'Don\'t have an account',
                        onPressed: () {
                          Get.offAndToNamed(LoginPage.pageName);
                        },
                        buttonText: 'Log In',
                      ),
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
