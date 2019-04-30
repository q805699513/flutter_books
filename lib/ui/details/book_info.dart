import 'package:flutter/material.dart';
import 'package:flutter_books/data/model/response/book_info_resp.dart';
import 'package:flutter_books/data/repository/repository.dart';
import 'package:flutter_books/res/colors.dart';
import 'package:flutter_books/res/dimens.dart';
import 'package:flutter_books/util/utils.dart';
import 'package:flutter_books/widget/load_view.dart';

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

  @override
  void initState() {
    super.initState();

    getData();
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
        ],
      );
    }
  }

  Widget titleView() {
    return Container(
      color: MyColors.infoBgColor,
      constraints: BoxConstraints.expand(height: 48),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            left: 0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  Dimens.leftMargin, 0, Dimens.rightMargin, 0),
              child: Image.asset(
                'images/icon_title_back.png',
                color: MyColors.white,
                width: 18,
                height: 48,
              ),
            ),
          ),
          Text(
            _bookInfoResp.title,
            style: TextStyle(
                fontSize: Dimens.titleTextSize, color: MyColors.white),
            overflow: TextOverflow.ellipsis,
          ),
          Positioned(
            right: 0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  Dimens.leftMargin, 0, Dimens.rightMargin, 0),
              child: Image.asset(
                'images/icon_share.png',
                color: MyColors.white,
                width: 16,
                height: 48,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget contentView() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          coverView(),
          bodyView(),
          Container(
            height: 8,
            color: MyColors.dividerColor,
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(
                  Dimens.leftMargin, 14, Dimens.rightMargin, 14),
              child: Text(
                _bookInfoResp.longIntro,
                style: TextStyle(fontSize: 12, color: MyColors.black),
              )),
          Container(
            height: 8,
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
                      fontSize: Dimens.titleTextSize,
                      color: MyColors.textBlackH),
                ),
                Expanded(
                  child: Container(),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 1,3, 0),
                  child: Image.asset(
                    'images/icon_info_edit.png',
                    width: 13,
                    height: 13,
                  ),
                ),
                Text(
                  "写书评",
                  style: TextStyle(fontSize: 12, color: Color(0xFF33C3A5)),
                )
              ],
            ),
          )
//          commentList(),
        ],
      ),
    );
  }

  ///封面view
  Widget coverView() {
    return Container(
      color: MyColors.infoBgColor,
      padding:
          EdgeInsets.fromLTRB(Dimens.leftMargin, 56, Dimens.rightMargin, 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.network(
            Utils.convertImageUrl(_bookInfoResp.cover),
            height: 106,
            width: 80,
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: 10,
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
                  height: 48,
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
                      margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      color: Color(0x50FFFFFF),
                      width: 1,
                      height: 9,
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
                            color: MyColors.fractionColor, fontSize: 18),
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
        bodyChildView('images/icon_details_bookshelf.png', "加入书架"),
        bodyChildView('images/icon_details_chapter.png',
            _bookInfoResp.chaptersCount.toString() + "章"),
        bodyChildView('images/icon_details_reward.png', "支持作品"),
        bodyChildView('images/icon_details_download.png', "批量下载"),
      ],
    );
  }

  Widget bodyChildView(String img, String content) {
    return Expanded(
      flex: 1,
      child: new GestureDetector(
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
//  Widget commentList(){
//    return
//  }

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
