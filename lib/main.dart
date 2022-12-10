import 'package:artcorner/upload_page.dart';
import 'package:flutter/material.dart';
import 'package:artcorner/home_page.dart';
import 'package:artcorner/profile_page.dart';
import 'package:artcorner/login_page.dart';
import 'package:artcorner/db.dart';

enum Menu { home, profile, login, itemFour }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;
  List<Widget> pages = const [
    HomePage(),
    UploadPage(),
    ProfilePage(),
  ];
  void logout() {
    pb.authStore.clear();
    setState(() {
      loggedIn = false;
    });
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Logged out'),
              content: const Text('Succesfully logged out'),
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
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Art Corner'),
        actions: [
          IconButton(
            icon: loggedIn ? const Icon(Icons.logout) : const Icon(Icons.login),
            tooltip: loggedIn ? 'Log out' : 'Log in',
            onPressed: () {
              loggedIn
                  ? logout()
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
            },
          ),
        ],
      ),
      body: pages[currentPage],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.add), label: 'Upload'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}
