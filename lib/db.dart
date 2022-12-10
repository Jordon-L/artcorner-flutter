import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image/image.dart';
import 'package:pocketbase/pocketbase.dart';

import 'dto.dart';

final pb = PocketBase('https://artcorner.jordonlee.com');
bool loggedIn = false;

class DB {
  static Future<ResultList<RecordModel>> getPost({int page = 1}) {
    return pb.collection('posts').getList(
        page: page,
        perPage: 20,
        filter: 'created >= "2022-01-01 00:00:00" ',
        sort: '-created',
        expand: 'author');
  }

  static Future<ResultList<RecordModel>> getAuthorPost(
      {int page = 1, String authorId = ''}) {
    return pb.collection('posts').getList(
        page: page,
        perPage: 20,
        filter: 'author = "$authorId"',
        sort: '-created',
        expand: 'author');
  }

  static Future<RecordAuth> login(String email, String password) async {
    final authData =
        await pb.collection('users').authWithPassword(email, password);
    return authData;
  }

  static Future<RecordModel> postUpload(
      String title, String summary, File? file) async {
    final image = decodeImage(file!.readAsBytesSync())!;
    final imageJpg = encodeJpg(image);
    final multipartFile =
        http.MultipartFile.fromBytes('file', imageJpg, filename: '$title.jpg');
    final body = <String, dynamic>{
      "title": title,
      "summary": summary,
      "author": pb.authStore.model?.id,
    };
    final record = await pb.collection('posts').create(
      body: body,
      files: [multipartFile],
    );
    return record;
  }

  static ProfileDto getProfile() {
    late final ProfileDto author = ProfileDto.fromJson(pb.authStore.model);
    return author;
  }
}
