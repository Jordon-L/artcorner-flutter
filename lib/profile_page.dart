import 'package:flutter/material.dart';
import 'package:artcorner/login_page.dart';
import 'package:artcorner/db.dart';
const int itemCount = 20;


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!loggedIn) {
      return Center(
        child: ElevatedButton(
          child: const Text('Login'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
        ),
      );
    }

    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
            title: Text('Item ${(index + 1)}'),
            leading: const Icon(Icons.person),
            trailing: const Icon(Icons.select_all),
            onTap: () {
              debugPrint('Item ${(index + 1)} selected');
            });
      },
    );
  }
}
