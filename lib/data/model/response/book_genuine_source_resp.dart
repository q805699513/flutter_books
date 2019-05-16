import 'dart:convert' show json;

import 'package:json_annotation/json_annotation.dart';

class BookGenuineSourceResp {

  List<BookGenuineSourceList> data;

  BookGenuineSourceResp.fromParams({this.data});

  factory BookGenuineSourceResp(jsonStr) => jsonStr == null ? null : jsonStr is String ? new BookGenuineSourceResp.fromJson(json.decode(jsonStr)) : new BookGenuineSourceResp.fromJson(jsonStr);

  BookGenuineSourceResp.fromJson(jsonRes) {
    data = jsonRes['data'] == null ? null : [];

    for (var dataItem in data == null ? [] : jsonRes['data']){
      data.add(dataItem == null ? null : new BookGenuineSourceList.fromJson(dataItem));
    }
  }

  @override
  String toString() {
    return '{"data": $data}';
  }
}

class BookGenuineSourceList {

  int chaptersCount;
  bool isCharge;
  bool starting;
  @JsonKey(name: "_id")
  String id;
  String host;
  String lastChapter;
  String link;
  String name;
  String source;
  String updated;

  BookGenuineSourceList.fromParams({this.chaptersCount, this.isCharge, this.starting, this.id, this.host, this.lastChapter, this.link, this.name, this.source, this.updated});

  BookGenuineSourceList.fromJson(jsonRes) {
    chaptersCount = jsonRes['chaptersCount'];
    isCharge = jsonRes['isCharge'];
    starting = jsonRes['starting'];
    id = jsonRes['_id'];
    host = jsonRes['host'];
    lastChapter = jsonRes['lastChapter'];
    link = jsonRes['link'];
    name = jsonRes['name'];
    source = jsonRes['source'];
    updated = jsonRes['updated'];
  }

  @override
  String toString() {
    return '{"chaptersCount": $chaptersCount,"isCharge": $isCharge,"starting": $starting,"_id": ${id != null?'${json.encode(id)}':'null'},"host": ${host != null?'${json.encode(host)}':'null'},"lastChapter": ${lastChapter != null?'${json.encode(lastChapter)}':'null'},"link": ${link != null?'${json.encode(link)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'},"source": ${source != null?'${json.encode(source)}':'null'},"updated": ${updated != null?'${json.encode(updated)}':'null'}}';
  }
}

