import 'package:flutter/material.dart';
import 'package:flutter_books/data/model/request/categories_req.dart';
import 'package:flutter_books/data/model/response/categories_resp.dart';
import 'package:flutter_books/data/repository/repository.dart';
import 'package:flutter_books/res/colors.dart';
import 'package:flutter_books/res/dimens.dart';
import 'package:flutter_books/ui/details/book_info_page.dart';
import 'package:flutter_books/util/utils.dart';

// ignore: must_be_immutable
class HomeTabListView extends StatefulWidget {
  final String major;
  final String gender;

  HomeTabListView(
    this.gender,
    this.major,
  );

  @override
  State<StatefulWidget> createState() => _HomeTabListViewState();
}

class _HomeTabListViewState extends State<HomeTabListView>
    with AutomaticKeepAliveClientMixin {
  List<Books> _list = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(Dimens.leftMargin, 0, Dimens.leftMargin, 0),
      itemCount: _list.length,
      itemBuilder: (context, position) {
        return _buildListViewItem(position);
      },
    );
  }

  Widget _buildListViewItem(int position) {
    String imageUrl = Utils.convertImageUrl(_list[position].cover);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => BookInfoPage(_list[position].id)),
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
                    style:
                        TextStyle(color: MyColors.textBlack3, fontSize: 16),
                  ),
                  SizedBox(height: 6),
                  Text(
                    _list[position].shortIntro,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(color: MyColors.textBlack6, fontSize: 14),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        _list[position].author,
                        style: TextStyle(
                          color: MyColors.textBlack9,
                          fontSize: 14,
                        ),
                      )),
                      _list[position].tags != null &&
                              _list[position].tags.length > 0
                          ? tagView(_list[position].tags[0])
                          : tagView('限免'),
                      _list[position].tags != null &&
                              _list[position].tags.length > 1
                          ? SizedBox(
                              width: 4,
                            )
                          : SizedBox(),
                      _list[position].tags != null &&
                              _list[position].tags.length > 1
                          ? tagView(_list[position].tags[1])
                          : SizedBox(),
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

  tagView(String tag) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 0, 5,0),
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

  void getData() async {
    print('----------------' + this.widget.gender);
    print('----------------' + this.widget.major);

    CategoriesReq categoriesReq = CategoriesReq();
    categoriesReq.gender = this.widget.gender;
    categoriesReq.major = this.widget.major;
    categoriesReq.type = "hot";
    categoriesReq.start = 0;
    categoriesReq.limit = 20;
    await Repository().getCategories(categoriesReq.toJson()).then((json) {
      var categoriesResp = CategoriesResp.fromJson(json);
        setState(() {
          _list = categoriesResp.books;
        });
    }).catchError((e) {
      print(e.toString());
    });
  }

  @override
  bool get wantKeepAlive => true;
}
