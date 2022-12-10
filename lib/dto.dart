
import 'package:pocketbase/pocketbase.dart';
import 'package:artcorner/utils.dart';

class PostDto {
  PostDto.fromRecord(this._record);

  final RecordModel _record;

  late final Map<String, dynamic> _data = _record.data;
  
  late final String title = _data['title'];
  late final String summary = _data['summary'];
  // late final String author = _data['author'];



  late final String? thumbnailUrl = _record.resolveFileUrl('file', true);

  late final String? imageUrl = _record.resolveFileUrl('file', false);

  late final ProfileDto author = ProfileDto.fromJson(_record.expand['author']![0]);
}

class ProfileDto {
  ProfileDto.fromJson(this._record);

  final RecordModel _record;

  late final Map<String, dynamic> _data = _record.data;

  late final String id = _record.id;

  late final String name = _data['name'];

  // late final String userId = _data['userId'];



  late final String? avatar = _record.resolveFileUrl('avatar', true);
}