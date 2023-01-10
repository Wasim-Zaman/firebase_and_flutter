import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utilities/utilities.dart';
import './login_page.dart';

class PostPage extends StatefulWidget {
  PostPage({Key? key}) : super(key: key);
  static const pageName = '/post-page';

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _dbRef = FirebaseDatabase.instance.ref("posts");

  @override
  dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _signOut() async {
    try {
      Utilities.showNeutralToast('Logging out...');
      await _auth.signOut();
      Utilities.showNeutralToast('Logged out');
      Get.offAllNamed(LoginPage.pageName);
    } catch (error) {
      Utilities.showBadToast(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Utilities.getSystemUIOverlayStyle(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Page'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Logo(),
            ),
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.logout),
              ),
              title: const Text('Log out'),
              onTap: _signOut,
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Post Page'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isDismissible: true,
            builder: (ctx) {
              return BottomSheet(
                onClosing: () {},
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: Form(
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Title',
                                border: OutlineInputBorder(),
                              ),
                              controller: _titleController,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Content',
                                border: OutlineInputBorder(),
                              ),
                              controller: _contentController,
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                final userId = _auth.currentUser?.uid;
                                _dbRef
                                    .child(userId!)
                                    .child(
                                        DateTime.now().microsecond.toString())
                                    .set({
                                  'title': _titleController.text,
                                  'content': _contentController.text,
                                }).then((_) {
                                  _contentController.clear();
                                  _titleController.clear();
                                  Utilities.showGoodToast('Posted');
                                  Get.back();
                                }).onError((error, stackTrace) {
                                  Utilities.showBadToast(error.toString());
                                });
                              },
                              child: const Text('Post'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        text: 'Flutter',
        style: TextStyle(
          color: Colors.teal,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: '\nFirebase',
            style: TextStyle(
              color: Colors.tealAccent,
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
