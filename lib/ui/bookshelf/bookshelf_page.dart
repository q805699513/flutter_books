import 'package:flutter/material.dart';
import 'package:flutter_books/db/db_helper.dart';
import 'package:flutter_books/res/colors.dart';
import 'package:flutter_books/res/dimens.dart';
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

  @override
  void initState() {
    super.initState();
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
                      padding: EdgeInsets.fromLTRB(14, 6, 14, 6),
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
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 0.4,
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
    if (readProgress == "0") {
      readProgress = "1";
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Image.network(
          Utils.convertImageUrl(_listBean[index].image),
          height: 108,
          width: 84,
          fit: BoxFit.cover,
        ),
        SizedBox(
          height: 12,
        ),
        SizedBox(
          width: 88,
          child: Text(
            _listBean[index].title,
            style: TextStyle(
              fontSize: Dimens.textSizeM,
              color: MyColors.textBlack3,
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          "已读$readProgress%",
          style:
              TextStyle(fontSize: Dimens.textSizeL, color: MyColors.textBlack9),
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
              onTap: () {},
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

  void getDbData() async {
    await _dbHelper.getTotalList().then((list) {
      list.forEach((item) {
        print("bookId= ${item.toString()}");
        BookshelfBean todoItem = BookshelfBean.fromMap(item);
        setState(() {
          _listBean.add(todoItem);
        });
        print("bookId= ${todoItem.bookId}");
      });
      print("length= ${_listBean.length}");
    }).catchError((e) {
      print("length= ${e.toString()}");
    });
  }
}
