import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_books/data/model/response/book_content_resp.dart';
import 'package:flutter_books/data/repository/repository.dart';
import 'package:flutter_books/res/colors.dart';
import 'package:flutter_books/res/dimens.dart';

///@author longshaohua
///小说内容浏览页

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
  bool _isSettingGone = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              reverse: false,
              padding: EdgeInsets.fromLTRB(
                  Dimens.leftMargin, 16, Dimens.rightMargin, 16),
              child: Text(
                _content,
                style: TextStyle(
                  color: MyColors.textBlack3,
                  fontSize: Dimens.textSizeM,
                  letterSpacing: 2,
                  wordSpacing: 2,
                  height: 1.1,
                ),
              ),
            ),
            Offstage(
              child: settingView(),
              offstage: _isSettingGone,
            )
          ],
        ),
      ),
    );
  }

  Widget settingView() {
    return Stack(
      children: <Widget>[
        Container(
          color: Color(0xFF3B3B3A),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        Dimens.leftMargin, 0, Dimens.rightMargin, 0),
                    child: Image.asset(
                      'images/icon_title_back.png',
                      width: 20,
                      height: Dimens.titleHeight,
                    ),
                  ),
                ),
              ),
              Expanded(child: SizedBox()),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        Dimens.leftMargin, 0, Dimens.rightMargin, 0),
                    child: Text("详情",style: TextStyle(fontSize: Dimens.textSizeL),),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void getData() async {
    await Repository()
        .getBookChaptersContent(this.widget._bookUrl)
        .then((json) {
      BookContentResp bookContentResp = BookContentResp(json);
      setState(() {
        ///部分小说文字有问题，需要特殊处理
        _content = bookContentResp.chapter.cpContent
            .replaceAll("\t", "\n")
            .replaceAll("\n\n\n\n", "\n\n");
      });
    }).catchError((e) {
      //请求出错
      print(e.toString());
    });
  }
}
