import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utilities/utilities.dart';
import './login_page.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);
  static const pageName = '/post-page';

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _auth = FirebaseAuth.instance;

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
    final _userId = _auth.currentUser?.uid;
    final _dbRef = FirebaseDatabase.instance.ref("Entries");
    print('***** user id ${_userId.toString()} ******');
    Utilities.getSystemUIOverlayStyle(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contents Page'),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: FirebaseAnimatedList(
                query: _dbRef.child(_userId.toString()),
                defaultChild: const Center(
                  child: CircularProgressIndicator(),
                ),
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  var data = snapshot.children.toList().firstWhere(
                      (element) => element.hasChild(_userId.toString()));

                  if (snapshot.children.isEmpty) {
                    return const Center(
                      child: Text('Nothing to show'),
                    );
                  } else {
                    return Card(
                      child: ListTile(
                        title: Text(data.child('Application').value.toString()),
                        subtitle: Text(_userId.toString()),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: true,
            builder: (ctx) {
              return BottomSheet(
                enableDrag: false,
                onClosing: () {},
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.only(
                        top: 20,
                        left: 20,
                        right: 20,
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Form(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Application',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 3,
                              controller: _titleController,
                              keyboardType: TextInputType.multiline,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.visiblePassword,
                              controller: _contentController,
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                _dbRef
                                    .child(_userId!)
                                    .child(
                                        DateTime.now().microsecond.toString())
                                    .set({
                                  'Application': _titleController.text,
                                  'Password': _contentController.text,
                                }).then((_) {
                                  _contentController.clear();
                                  _titleController.clear();
                                  Utilities.showGoodToast('New Entry Added');
                                  Get.back();
                                }).onError((error, stackTrace) {
                                  Utilities.showBadToast(error.toString());
                                });
                              },
                              child: const Text('Add'),
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
    // return RichText(
    //   text: const TextSpan(
    //     text: 'Flutter',
    //     style: TextStyle(
    //       color: Colors.teal,
    //       fontSize: 40,
    //       fontWeight: FontWeight.bold,
    //     ),
    //     children: [
    //       TextSpan(
    //         text: '\nFirebase',
    //         style: TextStyle(
    //           color: Colors.tealAccent,
    //           fontSize: 50,
    //           fontWeight: FontWeight.bold,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Flutter',
          style: TextStyle(
            color: Colors.teal,
            fontSize: 50,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 10),
        Utilities.showShimmer(Colors.tealAccent, Colors.teal, 'Firebase'),
      ],
    );
  }
}
