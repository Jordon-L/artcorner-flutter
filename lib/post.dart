import 'package:artcorner/author_page.dart';
import 'package:flutter/material.dart';

import 'package:artcorner/dto.dart';

class Post extends StatefulWidget {
  const Post({super.key, required this.post});

  final PostDto post;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    dynamic author = widget.post.author;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Post'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 30,
                      backgroundImage: author.avatar != null
                          ? NetworkImage(author.avatar)
                          : const AssetImage('images/account.png')
                              as ImageProvider,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: GestureDetector(
                        onTap: (() {
                          Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    AuthorPage(author: author.id),
                              ));
                        }),
                        child: Text(author.name != "" ? author.name: "no name",
                            style: const TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(0),
                color: Colors.black,
                height: MediaQuery.of(context).size.width,
                child: Image.network(
                  widget.post.imageUrl!,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    widget.post.title,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    widget.post.summary,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
