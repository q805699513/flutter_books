import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_books/data/model/response/book_info_resp.dart';
import 'package:flutter_books/data/repository/repository.dart';
import 'package:flutter_books/db/db_helper.dart';
import 'package:flutter_books/event/event_bus.dart';
import 'package:flutter_books/res/colors.dart';
import 'package:flutter_books/res/dimens.dart';
import 'package:flutter_books/ui/details/book_chapters_content_page.dart';
import 'package:flutter_books/ui/details/book_chapters_page.dart';
import 'package:flutter_books/util/utils.dart';
import 'package:flutter_books/widget/load_view.dart';
import 'package:flutter_books/widget/static_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

///@author longshaohua
///详情页

class BookInfoPage extends StatefulWidget {
  final String _bookId;
  final bool _back;

  BookInfoPage(this._bookId, this._back);

  @override
  State<StatefulWidget> createState() => BookInfoPageState();
}

class BookInfoPageState extends State<BookInfoPage>
    implements OnLoadReloadListener {
  LoadStatus _loadStatus = LoadStatus.LOADING;
  BookInfoResp _bookInfoResp;
  ScrollController _controller = new ScrollController();
  Color _iconColor = Color.fromARGB(255, 255, 255, 255);
  Color _titleBgColor = Color.fromARGB(0, 255, 255, 255);
  Color _titleTextColor = Color.fromARGB(0, 0, 0, 0);
  bool _isDividerGone = true;
  String _image;
  String _bookName;
  var _dbHelper = DbHelper();

  //判断是否加入书架
  bool _isAddBookshelf = false;
  BookshelfBean _bookshelfBean;
  StreamSubscription booksSubscription;

  @override
  void initState() {
    super.initState();
    booksSubscription = eventBus.on<BooksEvent>().listen((event) {
      getDbData();
    });
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
    }
    if (_loadStatus == LoadStatus.FAILURE) {
      return FailureView(this);
    }

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
            height: Dimens.titleHeight,
            color: MyColors.textPrimaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0))),
            onPressed: () {
              if (this.widget._back) {
                Navigator.pop(context);
                return;
              }
              if (_isAddBookshelf) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return BookContentPage(
                      _bookshelfBean.bookUrl,
                      this.widget._bookId,
                      _image,
                      _bookshelfBean.chaptersIndex,
                      _bookshelfBean.isReversed == 1,
                      _bookName,
                      _bookshelfBean.offset);
                }));
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return BookContentPage(null, this.widget._bookId, _image, 0,
                      false, _bookName, 0);
                }));
              }
            },
            child: Text(
              _isAddBookshelf
                  ? (_bookshelfBean.readProgress == "0" ? "开始阅读" : "继续阅读")
                  : "开始阅读",
              style: TextStyle(color: MyColors.white, fontSize: 16),
            ),
          ),
        )
      ],
    );
  }

  Widget titleView() {
    return Container(
      color: _titleBgColor,
      constraints: BoxConstraints.expand(height: Dimens.titleHeight),
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
                      height: Dimens.titleHeight,
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
                    height: Dimens.titleHeight,
                  ),
                ),
              ),
            ),
          ),
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
                      fontSize: Dimens.textSizeM, color: MyColors.textBlack3),
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
              style: TextStyle(color: MyColors.textBlack9, fontSize: 12),
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
            height: 137,
            width: 100,
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
                  height: 61,
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
        bodyChildView(
            _isAddBookshelf
                ? 'images/icon_details_bookshelf_add.png'
                : 'images/icon_details_bookshelf.png',
            _isAddBookshelf ? "已在书架" : "加入书架",
            0),
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
          if (tap == 0) {
            if (!_isAddBookshelf) {
              var bean = BookshelfBean(
                _bookName,
                _image,
                "0",
                "",
                this.widget._bookId,
                0,
                0,
                0,
              );
              _dbHelper.addBookshelfItem(bean);
              this._bookshelfBean = bean;
              setState(() {
                _isAddBookshelf = true;
              });
              eventBus.fire(new BooksEvent());
            }
          }
          if (tap == 1) {
            /// 章节目录页
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (content) =>
                      BookChaptersPage(this.widget._bookId, _image, _bookName)),
            );
          }
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                img,
                width: 34,
                height: 34,
                fit: BoxFit.contain,
              ),
              Text(
                content,
                style: TextStyle(
                    color: MyColors.textBlack3, fontSize: Dimens.textSizeM),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //评论列表
  Widget commentList() {
    return Padding(
      padding: EdgeInsets.fromLTRB(Dimens.leftMargin, 0, Dimens.rightMargin, 0),
      child: Column(
        children: <Widget>[
          itemView("嘻嘻", "求更新，不够看", 4.5, "9", true),
          itemView("书友805699513", "不错不错。", 5, "8", false),
          itemView("书友007", "没看先点赞", 5, "5", true),
          itemView("书友00888", "好文章不错，就是更新太慢了。", 3, "1", false),
          itemView("书友00666", "打卡", 5, "9", true),
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
                          color: MyColors.textBlack6,
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
                color: MyColors.textBlack3, fontSize: Dimens.textSizeL),
          ),
        ),
        Row(
          children: <Widget>[
            Text(
              "2019.05.09",
              style: TextStyle(color: MyColors.textBlack9, fontSize: 12),
            ),
            Expanded(
              child: Container(),
            ),
            GestureDetector(
              child: image
                  ? Image.asset(
                      "images/icon_like_true.png",
                      width: 18,
                      height: 18,
                    )
                  : Image.asset(
                      "images/icon_like_false.png",
                      width: 18,
                      height: 18,
                    ),
              onTap: () {
                Fluttertoast.showToast(msg: "本app不允许点赞", fontSize: 14.0);
              },
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(2, 0, 20, 0),
              child: Text(
                likeNum,
                style: TextStyle(color: MyColors.textBlack9, fontSize: 12),
              ),
            ),
            Image.asset(
              "images/icon_comment.png",
              width: 18,
              height: 18,
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
      print("getData1");
      setState(() {
        _loadStatus = LoadStatus.SUCCESS;
        _bookInfoResp = BookInfoResp(json);
        _image = _bookInfoResp.cover;
        _bookName = _bookInfoResp.title;
      });
      getDbData();
    }).catchError((e) {
      print("getData2${e.toString()}");
      setState(() {
        _loadStatus = LoadStatus.FAILURE;
      });
    });
  }

  void getDbData() async {
    var list = await _dbHelper.queryBooks(_bookInfoResp.id);
    if (list != null) {
      print("getDbData1");
      _bookshelfBean = list;
      setState(() {
        _isAddBookshelf = true;
      });
    } else {
      print("getDbData2");
      setState(() {
        _isAddBookshelf = false;
      });
    }
  }

  @override
  void onReload() {
    setState(() {
      _loadStatus = LoadStatus.LOADING;
    });
    getData();
  }

  @override
  void dispose() {
    super.dispose();
    booksSubscription.cancel();
  }
}
