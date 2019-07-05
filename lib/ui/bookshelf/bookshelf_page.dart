import 'package:flutter/material.dart';
import 'package:flutter_books/res/colors.dart';
import 'package:flutter_books/res/dimens.dart';

///@author longshaohua
///书架页面

class BookshelfPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BookshelfPageState();
}

class BookshelfPageState extends State<BookshelfPage> {
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
                          Dimens.leftMargin, 0, Dimens.rightMargin, 12),
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
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 10,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 1.0,
                      ),
                      itemBuilder: (context, index) {
                        return Stack(
                          children: <Widget>[Text("12122")],
                        );
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
}
