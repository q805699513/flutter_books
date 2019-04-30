import 'dart:async';

import 'package:flutter_books/data/net/dio_utils.dart';

class Repository {
  Future<Map> getCategories(queryParameters) async {
    return await DioUtils().request<String>(
      "/book/by-categories",
      queryParameters: queryParameters,
    );
  }

  Future<Map> getBookInfo(bookId) async {
    return await DioUtils().request<String>(
      "/book/$bookId",
    );
  }

}
