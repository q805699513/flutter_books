class BookChaptersReq{
  String view;
  BookChaptersReq(this.view);

  Map<String, dynamic> toJson() {
    return {
      'view': view,
    };
  }


}