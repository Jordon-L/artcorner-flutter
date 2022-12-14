import 'package:flutter/material.dart';
import 'package:artcorner/login_page.dart';
import 'package:artcorner/db.dart';
import 'package:artcorner/dto.dart';
import 'package:artcorner/post.dart';

const int itemCount = 20;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
    final author = DB.getProfile();
    final results = DB.getAuthorPost(page: 1, authorId: author.id);
    return Scaffold(
      body: FutureBuilder(
        future: results,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final posts =
              snapshot.data!.items.map((it) => PostDto.fromRecord(it));
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 30,
                      backgroundImage: author.avatar != null
                          ? NetworkImage(author.avatar!)
                          : const AssetImage('images/account.png')
                              as ImageProvider,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        author.name != "" ? author.name: "no name",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(0),
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  crossAxisCount: MediaQuery.of(context).size.width > 700 ? 4 : 2,
                  children: [
                    for (final post in posts)
                      GestureDetector(
                        onTap: () {
                          Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    Post(post: post),
                              ));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                post.thumbnailUrl!,
                              ),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
