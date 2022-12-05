import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase('https://artcorner.jordonlee.com');
bool loggedIn = false;

class DB {
  static Future<ResultList<RecordModel>> getPost({int page = 1}) {
    return pb.collection('posts').getList(
      page: page,
      perPage: 20,
      filter: 'created >= "2022-01-01 00:00:00" ',
      expand: 'author'
    );
  }

  static Future<RecordAuth> login(String email, String password) async {
    final authData = await pb.collection('users').authWithPassword(email, password);
    return authData;
  }
}
