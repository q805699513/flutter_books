import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_books/db/db_helper.dart';
import 'package:flutter_books/event/event_bus.dart';
import 'package:flutter_books/res/colors.dart';
import 'package:flutter_books/res/dimens.dart';
import 'package:flutter_books/ui/details/book_chapters_content_page.dart';
import 'package:flutter_books/ui/search/book_search_page.dart';
import 'package:flutter_books/util/utils.dart';

///@author longshaohua
///书架页面

class BookshelfPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BookshelfPageState();
}

class BookshelfPageState extends State<BookshelfPage> {
  var _dbHelper = DbHelper();
  List<BookshelfBean> _listBean = [];
  StreamSubscription booksSubscription;

  @override
  void initState() {
    super.initState();
    booksSubscription = eventBus.on<BooksEvent>().listen((event) {
      getDbData();
    });

    getDbData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            titleView(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(
                          Dimens.leftMargin, 0, Dimens.rightMargin, 20),
                      padding: EdgeInsets.fromLTRB(18, 10, 18, 10),
                      decoration: BoxDecoration(
                          color: Color(0XFFEBF9F6),
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                      child: Text(
                        "【Panda看书】全网小说不限时免费观看",
                        style: TextStyle(
                            color: MyColors.textBlack6,
                            fontSize: Dimens.textSizeL),
                      ),
                    ),
                    GridView.builder(
                      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _listBean.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.5,
                      ),
                      itemBuilder: (context, index) {
                        return itemView(index);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemView(int index) {
    String readProgress = _listBean[index].readProgress;
    var position = index == 0 ? 0 : index % 3;
    var axisAlignment;
    if (position == 0) {
      axisAlignment = CrossAxisAlignment.start;
    } else if (position == 1) {
      axisAlignment = CrossAxisAlignment.center;
    } else if (position == 2) {
      axisAlignment = CrossAxisAlignment.end;
    }
    print("position$position,index=$index");
    return Column(
      crossAxisAlignment: axisAlignment,
      children: <Widget>[
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(3)),
          ),
          clipBehavior: Clip.antiAlias,
          child: GestureDetector(
            child: Image.network(
              Utils.convertImageUrl(_listBean[index].image),
              height: 121,
              width: 92,
              fit: BoxFit.cover,
            ),
            onLongPress: () {
              showDeleteDialog(index);
            },
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return BookContentPage(
                    _listBean[index].bookUrl,
                    _listBean[index].bookId,
                    _listBean[index].image,
                    _listBean[index].chaptersIndex,
                    _listBean[index].isReversed == 1,
                    _listBean[index].title,
                    _listBean[index].offset);
              }));
            },
          ),
        ),
        SizedBox(
          height: 12,
        ),
        SizedBox(
          width: 95,
          child: Text(
            _listBean[index].title,
            maxLines: 2,
            style: TextStyle(
              fontSize: Dimens.textSizeM,
              color: MyColors.textBlack3,
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        SizedBox(
          width: 96,
          child: Text(
            "已读$readProgress%",
            style: TextStyle(
                fontSize: Dimens.textSizeL, color: MyColors.textBlack9),
          ),
        ),
      ],
    );
  }

  ///书架标题
  Widget titleView() {
    return Container(
      color: MyColors.primary,
      constraints: BoxConstraints.expand(height: Dimens.titleHeight),
      padding: EdgeInsets.fromLTRB(Dimens.leftMargin, 0, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "书架",
            style: TextStyle(
                fontSize: Dimens.titleTextSize, color: MyColors.textBlack3),
            overflow: TextOverflow.ellipsis,
          ),
          Expanded(child: Container()),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BookSearchPage()));
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    Dimens.leftMargin, 0, Dimens.rightMargin, 0),
                child: Image.asset(
                  'images/icon_bookshelf_search.png',
                  width: 20,
                  height: Dimens.titleHeight,
                ),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Image.asset(
                  'images/icon_bookshelf_more.png',
                  width: 3.5,
                  height: Dimens.titleHeight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  showDeleteDialog(int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text("删除书籍"),
          content: Text("删除此书后，书籍源文件及阅读进度也将被删除"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                _dbHelper.deleteBooks(_listBean[index].bookId).then((i) {
                  setState(() {
                    _listBean.removeAt(index);
                  });
                });
              },
              child: Text("确定"),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("取消"),
            ),
          ],
        );
      },
    );
  }

  void getDbData() async {
    await _dbHelper.getTotalList().then((list) {
      _listBean.clear();
      list.reversed.forEach((item) {
        BookshelfBean todoItem = BookshelfBean.fromMap(item);
        setState(() {
          _listBean.add(todoItem);
        });
      });
    }).catchError((e) {});
  }

  @override
  void dispose() {
    super.dispose();
    booksSubscription.cancel();
  }
}


