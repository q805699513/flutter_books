import 'dart:convert' show json;

import 'package:json_annotation/json_annotation.dart';

class BookChaptersResp {
  @JsonKey(name: "_id")
  String id;
  String book;
  String host;
  String link;
  String name;
  String source;
  String updated;
  List<BookChaptersBean> chapters;

  BookChaptersResp.fromParams({this.id, this.book, this.host, this.link, this.name, this.source, this.updated, this.chapters});

  factory BookChaptersResp(jsonStr) => jsonStr == null ? null : jsonStr is String ? new BookChaptersResp.fromJson(json.decode(jsonStr)) : new BookChaptersResp.fromJson(jsonStr);

  BookChaptersResp.fromJson(jsonRes) {
    id = jsonRes['_id'];
    book = jsonRes['book'];
    host = jsonRes['host'];
    link = jsonRes['link'];
    name = jsonRes['name'];
    source = jsonRes['source'];
    updated = jsonRes['updated'];
    chapters = jsonRes['chapters'] == null ? null : [];

    for (var chaptersItem in chapters == null ? [] : jsonRes['chapters']){
      chapters.add(chaptersItem == null ? null : new BookChaptersBean.fromJson(chaptersItem));
    }
  }

  @override
  String toString() {
    return '{"_id": ${id != null?'${json.encode(id)}':'null'},"book": ${book != null?'${json.encode(book)}':'null'},"host": ${host != null?'${json.encode(host)}':'null'},"link": ${link != null?'${json.encode(link)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'},"source": ${source != null?'${json.encode(source)}':'null'},"updated": ${updated != null?'${json.encode(updated)}':'null'},"chapters": $chapters}';
  }
}

class BookChaptersBean {

  int currency;
  int order;
  int partsize;
  int time;
  int totalpage;
  bool isVip;
  bool unreadble;
  String chapterCover;
  String id;
  String link;
  String title;

  BookChaptersBean.fromParams({this.currency, this.order, this.partsize, this.time, this.totalpage, this.isVip, this.unreadble, this.chapterCover, this.id, this.link, this.title});

  BookChaptersBean.fromJson(jsonRes) {
    currency = jsonRes['currency'];
    order = jsonRes['order'];
    partsize = jsonRes['partsize'];
    time = jsonRes['time'];
    totalpage = jsonRes['totalpage'];
    isVip = jsonRes['isVip'];
    unreadble = jsonRes['unreadble'];
    chapterCover = jsonRes['chapterCover'];
    id = jsonRes['id'];
    link = jsonRes['link'];
    title = jsonRes['title'];
  }

  @override
  String toString() {
    return '{"currency": $currency,"order": $order,"partsize": $partsize,"time": $time,"totalpage": $totalpage,"isVip": $isVip,"unreadble": $unreadble,"chapterCover": ${chapterCover != null?'${json.encode(chapterCover)}':'null'},"id": ${id != null?'${json.encode(id)}':'null'},"link": ${link != null?'${json.encode(link)}':'null'},"title": ${title != null?'${json.encode(title)}':'null'}}';
  }
}

