import 'dart:convert' show json;

import 'package:json_annotation/json_annotation.dart';

class FuzzySearchResp {

  int total;
  bool ok;
  List<FuzzySearchList> books;

  FuzzySearchResp.fromParams({this.total, this.ok, this.books});

  factory FuzzySearchResp(jsonStr) => jsonStr == null ? null : jsonStr is String ? new FuzzySearchResp.fromJson(json.decode(jsonStr)) : new FuzzySearchResp.fromJson(jsonStr);

  FuzzySearchResp.fromJson(jsonRes) {
    total = jsonRes['total'];
    ok = jsonRes['ok'];
    books = jsonRes['books'] == null ? null : [];

    for (var booksItem in books == null ? [] : jsonRes['books']){
      books.add(booksItem == null ? null : new FuzzySearchList.fromJson(booksItem));
    }
  }

  @override
  String toString() {
    return '{"total": $total,"ok": $ok,"books": $books}';
  }
}

class FuzzySearchList {

  int wordCount;
  @JsonKey(name: "_id")
  String id;
  String author;
  String cat;
  String cover;
  String title;

  FuzzySearchList.fromParams({this.wordCount, this.id, this.author, this.cat, this.cover, this.title});

  FuzzySearchList.fromJson(jsonRes) {
    wordCount = jsonRes['wordCount'];
    id = jsonRes['_id'];
    author = jsonRes['author'];
    cat = jsonRes['cat'];
    cover = jsonRes['cover'];
    title = jsonRes['title'];
  }

  @override
  String toString() {
    return '{"wordCount": $wordCount,"_id": ${id != null?'${json.encode(id)}':'null'},"author": ${author != null?'${json.encode(author)}':'null'},"cat": ${cat != null?'${json.encode(cat)}':'null'},"cover": ${cover != null?'${json.encode(cover)}':'null'},"title": ${title != null?'${json.encode(title)}':'null'}}';
  }
}

