import 'package:flutter/material.dart';
import 'package:flutter_books/data/model/request/categories_req.dart';
import 'package:flutter_books/data/model/response/categories_resp.dart';
import 'package:flutter_books/data/repository/repository.dart';
import 'package:flutter_books/res/colors.dart';
import 'package:flutter_books/res/dimens.dart';
import 'package:flutter_books/ui/details/book_info_page.dart';
import 'package:flutter_books/util/utils.dart';
import 'package:flutter_books/widget/load_view.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

///@author longshaohua
///书城 ListView

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
    with AutomaticKeepAliveClientMixin
    implements OnLoadReloadListener {
  List<Books> _list = [];
  LoadStatus _loadStatus = LoadStatus.LOADING;
  List<String> _listImage = [
    "images/icon_swiper_1.png",
    "images/icon_swiper_2.png",
    "images/icon_swiper_3.png",
    "images/icon_swiper_4.png",
    "images/icon_swiper_5.png",
  ];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    if (_loadStatus == LoadStatus.LOADING) {
      return LoadingView();
    }
    if (_loadStatus == LoadStatus.FAILURE) {
      return FailureView(this);
    }
    return ListView.builder(
      itemCount: _list.length + 1,
      itemBuilder: (context, position) {
        if (position == 0) {
          return _swiper();
        }
        return _buildListViewItem(position - 1);
      },
    );
  }

  Widget _buildListViewItem(int position) {
    String imageUrl = Utils.convertImageUrl(_list[position].cover);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => BookInfoPage(_list[position].id, false)),
        );
      },
      child: Container(
        padding:
            EdgeInsets.fromLTRB(Dimens.leftMargin, 12, Dimens.leftMargin, 12),
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
                  SizedBox(height: 6),
                  Text(
                    _list[position].shortIntro,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: MyColors.textBlack6, fontSize: 14),
                  ),
                  SizedBox(
                    height: 9,
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

  /// 轮播图
  Widget _swiper() {
    return Container(
      height: 180,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          print("index = $index");
          return Container(
            margin: const EdgeInsets.only(top: 16, bottom: 10),
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_listImage[index]),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(5))),
          );
        },
        autoplayDisableOnInteraction: true,
        itemHeight: 180,
        itemCount: 5,
        onTap: (index) {
          Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) =>
                    BookInfoPage("59ba0dbb017336e411085a4e", false)),
          );
        },
        viewportFraction: 0.9,
        scale: 0.93,
        outer: true,
        pagination: new SwiperPagination(
          alignment: Alignment.bottomCenter,
          builder: DotSwiperPaginationBuilder(
            activeColor: MyColors.textBlack6,
            color: MyColors.paginationColor,
            size: 5,
            activeSize: 5,
          ),
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

  void getData() async {
    print('----------------' + this.widget.gender);
    print('----------------' + this.widget.major);

    CategoriesReq categoriesReq = CategoriesReq();
    categoriesReq.gender = this.widget.gender;
    categoriesReq.major = this.widget.major;
    categoriesReq.type = "hot";
    categoriesReq.start = 0;
    categoriesReq.limit = 40;
    await Repository().getCategories(categoriesReq.toJson()).then((json) {
      var categoriesResp = CategoriesResp.fromJson(json);
      setState(() {
        _loadStatus = LoadStatus.SUCCESS;
        _list = categoriesResp.books;
      });
    }).catchError((e) {
      setState(() {
        _loadStatus = LoadStatus.FAILURE;
      });
      print(e.toString());
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void onReload() {
    setState(() {
      _loadStatus = LoadStatus.LOADING;
    });
    getData();
  }
}
