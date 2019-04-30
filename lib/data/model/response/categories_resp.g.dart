// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoriesResp _$CategoriesRespFromJson(Map<String, dynamic> json) {
  return CategoriesResp(
      (json['books'] as List)
          ?.map((e) =>
              e == null ? null : Books.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['ok'] as bool,
      json['total'] as int);
}

Map<String, dynamic> _$CategoriesRespToJson(CategoriesResp instance) =>
    <String, dynamic>{
      'books': instance.books,
      'ok': instance.ok,
      'total': instance.total
    };

Books _$BooksFromJson(Map<String, dynamic> json) {
  return Books(
      json['_id'] as String,
      json['allowMonthly'] as bool,
      json['author'] as String,
      json['banned'] as int,
      json['contentType'] as String,
      json['cover'] as String,
      json['lastChapter'] as String,
      json['latelyFollower'] as int,
      json['majorCate'] as String,
      json['minorCate'] as String,
      (json['retentionRatio'] as num)?.toDouble(),
      json['shortIntro'] as String,
      json['site'] as String,
      json['sizetype'] as int,
      json['superscript'] as String,
      (json['tags'] as List)?.map((e) => e as String)?.toList(),
      json['title'] as String);
}

Map<String, dynamic> _$BooksToJson(Books instance) => <String, dynamic>{
      '_id': instance.id,
      'allowMonthly': instance.allowMonthly,
      'author': instance.author,
      'banned': instance.banned,
      'contentType': instance.contentType,
      'cover': instance.cover,
      'lastChapter': instance.lastChapter,
      'latelyFollower': instance.latelyFollower,
      'majorCate': instance.majorCate,
      'minorCate': instance.minorCate,
      'retentionRatio': instance.retentionRatio,
      'shortIntro': instance.shortIntro,
      'site': instance.site,
      'sizetype': instance.sizetype,
      'superscript': instance.superscript,
      'tags': instance.tags,
      'title': instance.title
    };
