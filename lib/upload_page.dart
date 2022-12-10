import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:artcorner/login_page.dart';
import 'package:artcorner/db.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'main.dart';

const int itemCount = 20;

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? imagePath;
  TextEditingController titleController = TextEditingController();
  TextEditingController summaryController = TextEditingController();
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => imagePath = imageTemp);
      debugPrint("upload");
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
  }

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
    return SingleChildScrollView(
      child: Column(
        children: [
          imagePath == null
              ? Center(
                  child: ElevatedButton(
                    child: const Text('Pick a image'),
                    onPressed: () async {
                      await pickImage();
                    },
                  ),
                )
              : Image.file(imagePath!,
                  width: MediaQuery.of(context).size.width, height: 200),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 6,
              controller: summaryController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Summary',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.topRight,
            child: ElevatedButton(
              child: const Text('Upload'),
              onPressed: () async {
                if (titleController.text.length < 3 || imagePath == null) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: const Text('An Error has occurred'),
                            content: const Text(
                                'Title must be 3 character long and image must be selected.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ));
                  return;
                }
                await DB.postUpload(
                    titleController.text, summaryController.text, imagePath);
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => const RootPage()),
                      (Route<dynamic> route) => false);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
