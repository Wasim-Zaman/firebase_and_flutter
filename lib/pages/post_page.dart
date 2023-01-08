import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utilities/utilities.dart';
import './login_page.dart';

class PostPage extends StatelessWidget {
  PostPage({Key? key}) : super(key: key);
  static const pageName = '/post-page';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Page'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text(
                'Flutter & Firebase',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.teal,
                ),
              ),
            ),
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.logout),
              ),
              title: const Text('Log out'),
              onTap: () async {
                try {
                  Utilities.showNeutralToast('Logging out...');
                  await _auth.signOut();
                  Utilities.showNeutralToast('Logged out');
                  Get.offAllNamed(LoginPage.pageName);
                } catch (error) {
                  Utilities.showBadToast(error.toString());
                }
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Post Page'),
      ),
    );
  }
}
