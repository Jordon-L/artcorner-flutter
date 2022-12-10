import 'package:flutter/material.dart';
import 'package:artcorner/db.dart';
import 'package:artcorner/dto.dart';
import 'package:artcorner/post.dart';

const int itemCount = 20;

class AuthorPage extends StatefulWidget {
  const AuthorPage({super.key, required this.author});
  final String author;
  @override
  State<AuthorPage> createState() => _AuthorPageState();
}

class _AuthorPageState extends State<AuthorPage> {
  
  @override

  Widget build(BuildContext context) {
    final results = DB.getAuthorPost(page: 1, authorId: widget.author);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Author'),
      ),
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
          ProfileDto author = posts.first.author;
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
