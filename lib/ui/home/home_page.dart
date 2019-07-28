import 'package:flutter/material.dart';
import 'package:flutter_books/res/colors.dart';
import 'package:flutter_books/ui/home/home_tab_list_view.dart';
import 'package:flutter_books/ui/search/book_search_page.dart';

///@author longshaohua
///书城

class TabHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabHomePageState();
}

class _TabHomePageState extends State<TabHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookSearchPage()));
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: MyColors.homeGrey,
                          ),
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Image.asset(
                                "images/icon_home_search.png",
                                width: 15,
                                height: 15,
                              ),
                              Text(
                                "   搜索本地及网络书籍",
                                style: TextStyle(
                                  color: MyColors.homeGreyText,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print("333333333333333");
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 3, 0, 0),
                        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              "images/icon_classification.png",
                              width: 22,
                              height: 22,
                            ),
                            Text(
                              "分类",
                              style: TextStyle(
                                color: MyColors.textBlack6,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                TabBar(
                  labelColor: MyColors.homeTabText,
                  unselectedLabelColor: MyColors.homeTabGreyText,
                  labelStyle: TextStyle(fontSize: 16),
                  labelPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  indicatorColor: MyColors.homeTabText,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 2,
                  indicatorPadding: EdgeInsets.fromLTRB(0, 0, 0, 6),
                  tabs: <Widget>[
                    Text("精选"),
                    Text("男生"),
                    Text("女生"),
                    Text("出版"),
                  ],
                ),
                Divider(height: 1, color: MyColors.dividerDarkColor),
                Expanded(
                  child: TabBarView(children: [
                    HomeTabListView('male', '仙侠'),
                    HomeTabListView('male', '玄幻'),
                    HomeTabListView('female', '现代言情'),
                    HomeTabListView('press', '出版小说'),
                  ]),
                )
              ],
            ),
          ),
        ));
  }
}
