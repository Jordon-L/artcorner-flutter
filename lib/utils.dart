import 'package:pocketbase/pocketbase.dart';
import 'package:artcorner/config.dart';

String pbFileUrl({
  required String collectionIdOrName,
  required String recordId,
  required String filename,
  required bool thumbnail,
  String baseUrl = Config.baseUrl,
  
}) {
  if(thumbnail){
    return '$baseUrl/api/files/$collectionIdOrName/$recordId/$filename?thumb=200x200';
  }
  else{
    return '$baseUrl/api/files/$collectionIdOrName/$recordId/$filename?thumb=400x400f';
  }
  
}


extension RecordModelX on RecordModel {
  String? resolveFileUrl(String fieldKey, bool isThumbnail) {
    if(data[fieldKey] == ''){
      return null;
    }
    return pbFileUrl(
      collectionIdOrName: collectionId,
      recordId: id,
      filename: data[fieldKey],
      thumbnail: isThumbnail,
    );
  }
}


extension RecordMapX on Map<String, dynamic> {
  String resolveFileUrl(String fieldKey) {
    return pbFileUrl(
      collectionIdOrName: this['collectionId'],
      recordId: this['id'],
      filename: this[fieldKey],
      thumbnail: false,
    );
  }
}