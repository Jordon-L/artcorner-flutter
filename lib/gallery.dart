import 'package:flutter/material.dart';
import 'package:artcorner/dto.dart';
import 'package:artcorner/db.dart';
import 'package:artcorner/post.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  final results = DB.getPost();
  @override
  Widget build(BuildContext context) {
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

          return GridView.count(
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
                          builder: (BuildContext context) => Post(post: post),
                        ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(post.thumbnailUrl!,
                            ),
                      ),
                    ),
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}
