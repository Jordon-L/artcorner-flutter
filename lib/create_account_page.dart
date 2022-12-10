import 'package:flutter/material.dart';
import 'package:artcorner/db.dart';
import 'package:artcorner/profile_page.dart';

import 'main.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool successLogin = false;
  @override
  void initState() {
    super.initState();
    if (pb.authStore.isValid) {
      Navigator.pop(context, const ProfilePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Create Account"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Art Corner',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 30),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: userNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm Password',
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: const Text('Submit'),
                onPressed: () async {
                  try {
                    final body = <String, dynamic>{
                      "name": userNameController.text,
                      "email": nameController.text,
                      "emailVisibility": false,
                      "password": passwordController.text,
                      "passwordConfirm": confirmPasswordController.text,
                    };
                    await pb.collection('users').create(body: body);

                    await pb.collection('users').authWithPassword(
                        nameController.text, passwordController.text);
                    setState(() {
                      loggedIn = true;
                      successLogin = true;
                    });

                    if (mounted) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Account Created'),
                          content: const Text('Account successfully created'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const RootPage()),
                                    (Route<dynamic> route) => false)
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('An Error has occurred'),
                        content: const Text(
                            'Invalid email or passwords not matching'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
