import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_books/data/model/response/book_content_resp.dart';
import 'package:flutter_books/data/repository/repository.dart';
import 'package:flutter_books/res/colors.dart';
import 'package:flutter_books/res/dimens.dart';

class BookContentPage extends StatefulWidget {
  final String _bookUrl;

  BookContentPage(this._bookUrl);

  @override
  State<StatefulWidget> createState() {
    return BookContentPageState();
  }
}

class BookContentPageState extends State<BookContentPage> {
  String _content = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
              Dimens.leftMargin, 16, Dimens.rightMargin, 16),
          child: Text(
            _content,
            textAlign: TextAlign.left,
            style: TextStyle(
                color: MyColors.textBlack3, fontSize: Dimens.textSizeM),
          ),
        ),
      ),
    );
  }

//  Text(_content)
  void getData() async {
    await Repository()
        .getBookChaptersContent(this.widget._bookUrl)
        .then((json) {
      BookContentResp bookContentResp = BookContentResp(json);
      setState(() {
        _content = bookContentResp.chapter.cpContent;
      });
    }).catchError((e) {
      //请求出错
      print(e.toString());
    });
  }
}
