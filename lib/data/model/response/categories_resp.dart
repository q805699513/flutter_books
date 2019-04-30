import 'package:json_annotation/json_annotation.dart';

part 'categories_resp.g.dart';


@JsonSerializable()
class CategoriesResp{

  @JsonKey(name: 'books')
  List<Books> books;

  @JsonKey(name: 'ok')
  bool ok;

  @JsonKey(name: 'total')
  int total;

  CategoriesResp(this.books,this.ok,this.total,);

  factory CategoriesResp.fromJson(Map<String, dynamic> srcJson) => _$CategoriesRespFromJson(srcJson);

  Map<String, dynamic> toJson(CategoriesResp instance) => _$CategoriesRespToJson(instance);

}


@JsonSerializable()
class Books{

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'allowMonthly')
  bool allowMonthly;

  @JsonKey(name: 'author')
  String author;

  @JsonKey(name: 'banned')
  int banned;

  @JsonKey(name: 'contentType')
  String contentType;

  @JsonKey(name: 'cover')
  String cover;

  @JsonKey(name: 'lastChapter')
  String lastChapter;

  @JsonKey(name: 'latelyFollower')
  int latelyFollower;

  @JsonKey(name: 'majorCate')
  String majorCate;

  @JsonKey(name: 'minorCate')
  String minorCate;

  @JsonKey(name: 'retentionRatio')
  double retentionRatio;

  @JsonKey(name: 'shortIntro')
  String shortIntro;

  @JsonKey(name: 'site')
  String site;

  @JsonKey(name: 'sizetype')
  int sizetype;

  @JsonKey(name: 'superscript')
  String superscript;

  @JsonKey(name: 'tags')
  List<String> tags;

  @JsonKey(name: 'title')
  String title;

  Books(this.id,this.allowMonthly,this.author,this.banned,this.contentType,this.cover,this.lastChapter,this.latelyFollower,this.majorCate,this.minorCate,this.retentionRatio,this.shortIntro,this.site,this.sizetype,this.superscript,this.tags,this.title,);

  factory Books.fromJson(Map<String, dynamic> srcJson) => _$BooksFromJson(srcJson);

}


