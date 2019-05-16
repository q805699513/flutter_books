import 'dart:convert' show json;

class BookContentResp {

  bool ok;
  BookChapterContent chapter;

  BookContentResp.fromParams({this.ok, this.chapter});

  factory BookContentResp(jsonStr) => jsonStr == null ? null : jsonStr is String ? new BookContentResp.fromJson(json.decode(jsonStr)) : new BookContentResp.fromJson(jsonStr);

  BookContentResp.fromJson(jsonRes) {
    ok = jsonRes['ok'];
    chapter = jsonRes['chapter'] == null ? null : new BookChapterContent.fromJson(jsonRes['chapter']);
  }

  @override
  String toString() {
    return '{"ok": $ok,"chapter": $chapter}';
  }
}

class BookChapterContent {

  int currency;
  bool isVip;
  String body;
  String cpContent;
  String id;
  String title;

  BookChapterContent.fromParams({this.currency, this.isVip, this.body, this.cpContent, this.id, this.title});

  BookChapterContent.fromJson(jsonRes) {
    currency = jsonRes['currency'];
    isVip = jsonRes['isVip'];
    body = jsonRes['body'];
    cpContent = jsonRes['cpContent'];
    id = jsonRes['id'];
    title = jsonRes['title'];
  }

  @override
  String toString() {
    return '{"currency": $currency,"isVip": $isVip,"body": ${body != null?'${json.encode(body)}':'null'},"cpContent": ${cpContent != null?'${json.encode(cpContent)}':'null'},"id": ${id != null?'${json.encode(id)}':'null'},"title": ${title != null?'${json.encode(title)}':'null'}}';
  }
}

