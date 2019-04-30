import 'package:flutter/material.dart';
import 'package:flutter_books/res/colors.dart';
import 'package:flutter_books/ui/home/home_tab_list_view.dart';

class TabHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabHomePageState();
}

class _TabHomePageState extends State<TabHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Column(
            children: <Widget>[
              Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: MyColors.homeGrey,
                      ),
                      padding: EdgeInsets.fromLTRB(8, 4.5, 8, 4.5),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Image.asset(
                            "images/icon_home_search.png",
                            width: 13,
                            height: 13,
                          ),
                          Text(
                            "   搜索本地及网络书籍",
                            style: TextStyle(
                              color: MyColors.homeGreyText,
                              fontSize: 10.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("333333333333333");
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 4, 0, 0),
                      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "images/icon_classification.png",
                            width: 15,
                            height: 15,
                          ),
                          Text(
                            "分类",
                            style: TextStyle(
                              fontSize: 7,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          bottom: PreferredSize(
            child: TabBar(
              labelColor: MyColors.homeTabText,
              unselectedLabelColor: MyColors.homeTabGreyText,
              labelStyle: TextStyle(fontSize: 11),
              labelPadding: EdgeInsets.fromLTRB(0, 8, 0, 8),
              indicatorColor: MyColors.homeTabText,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 1.5,
              indicatorPadding: EdgeInsets.fromLTRB(0, 0, 0, 4),
              tabs: <Widget>[
                Text("精选"),
                Text("男生"),
                Text("女生"),
                Text("出版"),
              ],
            ),
            preferredSize: Size(8, 8),
          ),
        ),
        body: TabBarView(children: [
          HomeTabListView('male', '奇幻'),
          HomeTabListView('male', '玄幻'),
          HomeTabListView('female', '青春校园'),
          HomeTabListView('press', '出版小说'),
        ]),
      ),
    );
  }
}
