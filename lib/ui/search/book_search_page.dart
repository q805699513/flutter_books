import 'package:flutter/material.dart';
import 'package:flutter_books/data/model/request/fuzzy_search_book_list_req.dart';
import 'package:flutter_books/data/model/response/fuzzy_search_book_list_resp.dart';
import 'package:flutter_books/data/repository/repository.dart';
import 'package:flutter_books/res/colors.dart';
import 'package:flutter_books/res/dimens.dart';
import 'package:flutter_books/ui/details/book_info_page.dart';
import 'package:flutter_books/util/utils.dart';
import 'package:flutter_books/widget/load_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BookSearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BookSearchPageState();
}

class BookSearchPageState extends State<BookSearchPage> {
  LoadStatus _loadStatus = LoadStatus.SUCCESS;
  List<FuzzySearchList> _list = [];
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: <Widget>[
          titleView(),
          Divider(height: 1, color: MyColors.dividerDarkColor),
          Expanded(
            child: contentView(),
          ),
        ],
      )),
    );
  }

  void getData(String text) async {
    if (text.isEmpty) {
      Fluttertoast.showToast(msg: "请输入要搜索的书籍", fontSize: 14.0);
      return;
    }
    setState(() {
      _loadStatus = LoadStatus.LOADING;
    });
    FuzzySearchReq categoriesReq = FuzzySearchReq(text);
    await Repository()
        .getFuzzySearchBookList(categoriesReq.toJson())
        .then((json) {
      var fuzzySearchResp = FuzzySearchResp.fromJson(json);
      if (fuzzySearchResp != null && fuzzySearchResp.books != null) {
        setState(() {
          _loadStatus = LoadStatus.SUCCESS;
          _list = fuzzySearchResp.books;
        });
      }
    }).catchError((e) {
      print("2-------------------");
      print(e.toString());
    });
  }

  Widget titleView() {
    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints.expand(height: Dimens.titleHeight),
      child: Flex(
        direction: Axis.horizontal,
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
                  color: MyColors.black,
                  width: 20,
                  height: Dimens.titleHeight,
                ),
              ),
            ),
          ),
          Expanded(
              child: Container(
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: MyColors.homeGrey,
            ),
            padding: EdgeInsets.fromLTRB(7, 0, 0, 0),
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              onSubmitted: (s) {
                getData(_controller.text);
              },
              decoration: InputDecoration(
                  icon: Image.asset(
                    "images/icon_home_search.png",
                    width: 15,
                    height: 15,
                  ),
                  hintText: "斗破苍穹",
                  contentPadding: const EdgeInsets.symmetric(vertical: 5),
                  border: InputBorder.none),
              style: TextStyle(
                color: MyColors.textBlack6,
                fontSize: Dimens.textSizeM,
              ),
            ),
          )),
          MaterialButton(
            minWidth: 10,
            onPressed: () {
              getData(_controller.text);
            },
            child: Text(
              "搜索",
              style: TextStyle(
                  fontSize: Dimens.textSizeM, color: MyColors.textPrimaryColor),
            ),
            height: Dimens.titleHeight,
          )
        ],
      ),
    );
  }

  Widget contentView() {
    if (_loadStatus == LoadStatus.LOADING) {
      return LoadingView();
    } else {
      return ListView.builder(
        itemBuilder: (context, index) => _buildListViewItem(index),
        padding:
            EdgeInsets.fromLTRB(Dimens.leftMargin, 0, Dimens.leftMargin, 0),
        itemCount: _list.length,
      );
    }
  }

  Widget _buildListViewItem(int position) {
    String imageUrl = Utils.convertImageUrl(_list[position].cover);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => BookInfoPage(_list[position].id,false)),
        );
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(
              imageUrl,
              height: 99,
              width: 77,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _list[position].title,
                    style: TextStyle(color: MyColors.textBlack3, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _list[position].author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: MyColors.textBlack6, fontSize: 14),
                        ),
                      ),
                      MaterialButton(
                        color: MyColors.textPrimaryColor,
                        onPressed: null,
                        minWidth: 10,
                        height: 32,
                        child: Text(
                          "阅读",
                          style: TextStyle(
                              color: MyColors.white,
                              fontSize: Dimens.textSizeL),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      tagView(_list[position].cat),
                      SizedBox(
                        width: 6,
                      ),
                      tagView(getWordCount(_list[position].wordCount)),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget tagView(String tag) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      alignment: Alignment.center,
      child: Text(
        tag,
        style: TextStyle(color: MyColors.textBlack9, fontSize: 11.5),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          border: Border.all(width: 0.5, color: MyColors.textBlack9)),
    );
  }

  String getWordCount(int wordCount) {
    if (wordCount > 10000) {
      return (wordCount / 10000).toStringAsFixed(1) + "万字";
    }
    return wordCount.toString() + "字";
  }
}
