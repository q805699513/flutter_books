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
  double _padding = 0;
  double _imagePadding = 0;
  int _duration = 249;
  double _spaceValue = 1.2;
  double _textSizeValue = 18;

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
            GestureDetector(
              onTap: () {
                setState(() {
//                  _isSettingGone = !_isSettingGone;
                  _padding == 0 ? _padding = 48 : _padding = 0;
                  _imagePadding == 0 ? _imagePadding = 18 : _imagePadding = 0;
                });
              },
              child: SingleChildScrollView(
                reverse: false,
                padding: EdgeInsets.fromLTRB(
                    Dimens.leftMargin, 16, Dimens.rightMargin, 16),
                child: Text(
                  _content,
                  style: TextStyle(
                    color: MyColors.textBlack3,
                    fontSize: _textSizeValue,
                    letterSpacing: 1,
                    wordSpacing: 1,
                    height: _spaceValue,
                  ),
                ),
              ),
            ),
            settingView(),
          ],
        ),
      ),
    );
  }

  Widget settingView() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 48,
          child: AnimatedPadding(
            duration: Duration(milliseconds: _duration),
            padding: EdgeInsets.fromLTRB(0, 0, 0, _padding),
            child: Container(
              height: 48,
              color: Color(0xF6333333),
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
                          color: MyColors.contentColor,
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
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Image.asset(
                          'images/icon_bookshelf_more.png',
                          width: 3.0,
                          height: Dimens.titleHeight,
                          color: MyColors.contentColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(child: SizedBox()),
        Container(
          margin: EdgeInsets.fromLTRB(Dimens.leftMargin, 0, 0, 0),
          width: 36,
          height: 36,
          child: AnimatedPadding(
            duration: Duration(milliseconds: _duration),
            padding: EdgeInsets.fromLTRB(
                _imagePadding, _imagePadding, _imagePadding, _imagePadding),
            child: InkWell(
              onTap: () {},
              child: Image.asset(
                "images/icon_content_nighttime.png",
                height: 36,
                width: 36,
              ),
            ),
          ),
        ),
        Container(
          color: Color(0xF6333333),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "字号",
                    style: TextStyle(color: MyColors.contentColor),
                  ),
                  Slider(
                    value: _textSizeValue,
                    label: "字号：$_textSizeValue",
                    divisions: 20,
                    min: 10,
                    max: 30,
                    onChanged: (double value) {
                      setState(() {
                        _textSizeValue = value;
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "间距",
                    style: TextStyle(color: MyColors.contentColor),
                  ),
                  Slider(
                    value: _spaceValue,
                    label: "字间距：$_spaceValue",
                    min: 1.0,
                    divisions: 40,
                    max: 5.0,
                    onChanged: (double value) {
                      setState(() {
                        _spaceValue = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
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
