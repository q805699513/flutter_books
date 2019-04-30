class CategoriesReq {
  ///  gender=male&type=hot&major=奇幻&minor=&start=0&limit=20
  String gender;
  String type;
  String major;
  int start;
  int limit;

  Map<String, dynamic> toJson() {
    return {
        'gender': gender,
        'type': type,
        'major': major,
        'start': start,
        'limit': limit,
      };
  }
}
