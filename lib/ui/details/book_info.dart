import 'package:flutter/material.dart';
import 'package:flutter_books/data/model/response/book_info_resp.dart';
import 'package:flutter_books/data/repository/repository.dart';
import 'package:flutter_books/res/colors.dart';
import 'package:flutter_books/res/dimens.dart';
import 'package:flutter_books/ui/details/book_chapters.dart';
import 'package:flutter_books/util/utils.dart';
import 'package:flutter_books/widget/load_view.dart';
import 'package:flutter_books/widget/static_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

///@author longshaohua
///详情页
class BookInfo extends StatefulWidget {
  final String _bookId;

  BookInfo(this._bookId);

  @override
  State<StatefulWidget> createState() => BookInfoState();
}

class BookInfoState extends State<BookInfo> {
  LoadStatus _loadStatus = LoadStatus.LOADING;
  BookInfoResp _bookInfoResp;
  ScrollController _controller = new ScrollController();
  Color _iconColor = Color.fromARGB(255, 255, 255, 255);
  Color _titleBgColor = Color.fromARGB(0, 255, 255, 255);
  Color _titleTextColor = Color.fromARGB(0, 0, 0, 0);
  bool _isDividerGone = true;

  @override
  void initState() {
    super.initState();
    getData();
    _controller.addListener(() {
      print(_controller.offset);
      //170
      if (_controller.offset <= 170) {
        setState(() {
          double num = (1 - _controller.offset / 170) * 255;
          _iconColor =
              Color.fromARGB(255, num.toInt(), num.toInt(), num.toInt());
          _titleBgColor = Color.fromARGB(255 - num.toInt(), 255, 255, 255);
          if (_controller.offset > 90) {
            _titleTextColor = Color.fromARGB(255 - num.toInt(), 0, 0, 0);
          } else {
            _titleTextColor = Color.fromARGB(0, 0, 0, 0);
          }
          if (_controller.offset > 160) {
            _isDividerGone = false;
          } else {
            _isDividerGone = true;
          }
        });
      } else {
        setState(() {
          _isDividerGone = false;
          _iconColor = Color.fromARGB(255, 0, 0, 0);
          _titleTextColor = Color.fromARGB(255, 0, 0, 0);
          _titleBgColor = Color.fromARGB(255, 255, 255, 255);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      body: SafeArea(
        child: childLayout(),
      ),
    );
  }

  Widget childLayout() {
    if (_loadStatus == LoadStatus.LOADING) {
      return LoadingView();
    } else {
      return Stack(
        alignment: Alignment.topLeft,
        children: <Widget>[
          contentView(),
          titleView(),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: MaterialButton(
              height: 48,
              color: MyColors.textPrimaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0))),
              onPressed: () {},
              child: Text(
                "开始阅读",
                style: TextStyle(color: MyColors.white, fontSize: 16),
              ),
            ),
          )
        ],
      );
    }
  }

  Widget titleView() {
    return Container(
      color: _titleBgColor,
      constraints: BoxConstraints.expand(height: 48),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
              left: 0,
              child: Material(
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
                      color: _iconColor,
                      width: 20,
                      height: 48,
                    ),
                  ),
                ),
              )),
          Text(
            _bookInfoResp.title,
            style: TextStyle(
                fontSize: Dimens.titleTextSize, color: _titleTextColor),
            overflow: TextOverflow.ellipsis,
          ),
          Positioned(
              right: 0,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        Dimens.leftMargin, 0, Dimens.rightMargin, 0),
                    child: Image.asset(
                      'images/icon_share.png',
                      color: _iconColor,
                      width: 18,
                      height: 48,
                    ),
                  ),
                ),
              )),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Offstage(
              offstage: _isDividerGone,
              child: Divider(height: 1, color: MyColors.dividerDarkColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget contentView() {
    return SingleChildScrollView(
      controller: _controller,
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          coverView(),
          bodyView(),
          Container(
            height: 14,
            color: MyColors.dividerColor,
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(
                  Dimens.leftMargin, 20, Dimens.rightMargin, 20),
              child: Text(
                _bookInfoResp.longIntro,
                style: TextStyle(
                    fontSize: Dimens.textSizeM, color: MyColors.black),
              )),
          Container(
            height: 14,
            color: MyColors.dividerColor,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                Dimens.leftMargin, 12, Dimens.rightMargin, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "最新书评",
                  style: TextStyle(
                      fontSize: Dimens.textSizeM, color: MyColors.textBlackH),
                ),
                Expanded(
                  child: Container(),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 1, 3, 0),
                  child: Image.asset(
                    'images/icon_info_edit.png',
                    width: 16,
                    height: 16,
                  ),
                ),
                Text(
                  "写书评",
                  style: TextStyle(
                      fontSize: Dimens.textSizeL, color: Color(0xFF33C3A5)),
                )
              ],
            ),
          ),
          commentList(),
          Container(
            child: Text(
              "查看更多评论（268）",
              style: TextStyle(
                  color: MyColors.textPrimaryColor, fontSize: Dimens.textSizeL),
            ),
            padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
          ),
          Container(
            alignment: Alignment.center,
            color: MyColors.dividerColor,
            child: Text(
              "" + _bookInfoResp.copyrightDesc,
              style: TextStyle(color: MyColors.textBlackL, fontSize: 12),
            ),
            padding: EdgeInsets.fromLTRB(0, 14, 0, 68),
          ),
        ],
      ),
    );
  }

  ///封面view
  Widget coverView() {
    return Container(
      color: MyColors.infoBgColor,
      padding:
          EdgeInsets.fromLTRB(Dimens.leftMargin, 68, Dimens.rightMargin, 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.network(
            Utils.convertImageUrl(_bookInfoResp.cover),
            height: 141,
            width: 105,
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: 14,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _bookInfoResp.title,
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: Dimens.titleTextSize, color: MyColors.white),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _bookInfoResp.author,
                  style: TextStyle(
                      fontSize: Dimens.textSizeM, color: MyColors.white),
                ),
                SizedBox(
                  height: 57,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _bookInfoResp.cat,
                      style: TextStyle(
                          fontSize: Dimens.textSizeL, color: MyColors.white),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(11, 0, 11, 0),
                      color: Color(0x50FFFFFF),
                      width: 1,
                      height: 12,
                      child: Text(""),
                    ),
                    Text(
                      getWordCount(_bookInfoResp.wordCount),
                      style: TextStyle(
                          fontSize: Dimens.textSizeL, color: MyColors.white),
                    ),
                    Expanded(child: Container()),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 3, 4),
                      child: Text(
                        _bookInfoResp.rating != null
                            ? _bookInfoResp.rating.score.toStringAsFixed(1)
                            : "7.0",
                        style: TextStyle(
                            color: MyColors.fractionColor, fontSize: 23),
                      ),
                    ),
                    Text(
                      "分",
                      style: TextStyle(
                          color: MyColors.white, fontSize: Dimens.textSizeL),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget bodyView() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        bodyChildView('images/icon_details_bookshelf.png', "加入书架", 0),
        bodyChildView('images/icon_details_chapter.png',
            _bookInfoResp.chaptersCount.toString() + "章", 1),
        bodyChildView('images/icon_details_reward.png', "支持作品", 2),
        bodyChildView('images/icon_details_download.png', "批量下载", 3),
      ],
    );
  }

  Widget bodyChildView(String img, String content, int tap) {
    return Expanded(
      flex: 1,
      child: new GestureDetector(
        onTap: () {
          print("走了" + tap.toString());
          if (tap == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (content) => BookChapters(this.widget._bookId)),
            );
          }
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                img,
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
              Text(content,
                  style: TextStyle(
                      color: MyColors.textBlackH, fontSize: Dimens.textSizeM)),
            ],
          ),
        ),
      ),
    );
  }

  //评论列表
  Widget commentList() {
//   return ListView(
//      padding:
//          EdgeInsets.fromLTRB(Dimens.leftMargin, 12, Dimens.rightMargin, 12),
//      children: <Widget>[
//        itemView(),
//        itemView(),
//        itemView(),
//        itemView(),
//        itemView(),
//      ],
//    );

    return Padding(
      padding: EdgeInsets.fromLTRB(Dimens.leftMargin, 0, Dimens.rightMargin, 0),
      child: Column(
        children: <Widget>[
          itemView("嘻嘻", "更新太慢了", 4.5, "9", true),
          itemView("书友805699513", "好文章不错，就是更新太慢了。", 5, "7", false),
          itemView("书友007", "没看先点赞", 5, "1", false),
        ],
      ),
    );
  }

  Widget itemView(
      String name, String content, double rate, String likeNum, bool image) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            new ClipOval(
              child: new SizedBox(
                width: 32,
                height: 32,
                child: new Image.asset("images/icon_default_avatar.png"),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(name,
                      style: TextStyle(
                          color: MyColors.textBlackM,
                          fontSize: Dimens.textSizeL)),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: new StaticRatingBar(
                      size: 10,
                      rate: rate,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 14, 0, 14),
          child: Text(
            content,
            style: TextStyle(
                color: MyColors.textBlackH, fontSize: Dimens.textSizeL),
          ),
        ),
        Row(
          children: <Widget>[
            Text(
              "2019.05.09",
              style: TextStyle(color: MyColors.textBlackL, fontSize: 12),
            ),
            Expanded(
              child: Container(),
            ),
            GestureDetector(
              child: image
                  ? Image.asset(
                      "images/icon_like_true.png",
                      width: 16,
                      height: 16,
                    )
                  : Image.asset(
                      "images/icon_like_false.png",
                      width: 16,
                      height: 16,
                    ),
              onTap: () {
                Fluttertoast.showToast(msg: "本app不允许点赞", fontSize: 14.0);
              },
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(2, 0, 20, 0),
              child: Text(
                likeNum,
                style: TextStyle(color: MyColors.textBlackL, fontSize: 12),
              ),
            ),
            Image.asset(
              "images/icon_comment.png",
              width: 16,
              height: 16,
            ),
          ],
        ),
        SizedBox(
          height: 18,
        )
      ],
    );
  }

  String getWordCount(int wordCount) {
    if (wordCount > 10000) {
      return (wordCount / 10000).toStringAsFixed(1) + "万字";
    }
    return wordCount.toString() + "字";
  }

  void getData() async {
    await Repository().getBookInfo(this.widget._bookId).then((json) {
      setState(() {
        print("---走了");
        _loadStatus = LoadStatus.SUCCESS;
        _bookInfoResp = BookInfoResp(json);
      });
    }).catchError((e) {
      print("---走了2" + e.toString());
    });
  }
}
