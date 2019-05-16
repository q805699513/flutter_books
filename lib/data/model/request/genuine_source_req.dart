class GenuineSourceReq {
  String view;
  String book;

  GenuineSourceReq(this.view, this.book);

  Map<String, dynamic> toJson() {
    return {
      'view': view,
      'book': book,
    };
  }
}
