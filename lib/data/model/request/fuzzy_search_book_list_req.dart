class FuzzySearchReq{
  String query;
  FuzzySearchReq(this.query);

  Map<String, dynamic> toJson() {
    return {
      'query': query,
    };
  }
}