import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_books/res/colors.dart';
import 'package:flutter_books/res/dimens.dart';
import 'package:flutter_books/ui/bookshelf/bookshelf_page.dart';
import 'package:flutter_books/ui/home/home_page.dart';
import 'package:flutter_books/ui/me/me_page.dart';

///@author longshaohua
///小说首页

class MyHomePage extends StatefulWidget {
  static const platform = const MethodChannel("samples.flutter.io/permission");

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State {
  int _tabIndex = 0;
  final List<Image> _tabImages = [
    Image.asset('images/icon_tab_bookshelf_n.png',
        width: Dimens.homeImageSize, height: Dimens.homeImageSize),
    Image.asset('images/icon_tab_bookshelf_p.png',
        width: Dimens.homeImageSize, height: Dimens.homeImageSize),
    Image.asset('images/icon_tab_home_n.png',
        width: Dimens.homeImageSize, height: Dimens.homeImageSize),
    Image.asset('images/icon_tab_home_p.png',
        width: Dimens.homeImageSize, height: Dimens.homeImageSize),
    Image.asset('images/icon_tab_me_n.png',
        width: Dimens.homeImageSize, height: Dimens.homeImageSize),
    Image.asset('images/icon_tab_me_p.png',
        width: Dimens.homeImageSize, height: Dimens.homeImageSize),
  ];

  @override
  void initState() {
    super.initState();
//    动态申请相机权限示例，原生部分请查看 Android 下的 MainActivity
    _getPermission();
  }

  Future<Null> _getPermission() async {
    final String result =
        await MyHomePage.platform.invokeMethod('requestCameraPermissions');
    print("result=$result");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: IndexedStack(
        children: <Widget>[
          BookshelfPage(),
          TabHomePage(),
          MePage(),
        ],
        index: _tabIndex,
      ),
      bottomNavigationBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: _getBookshelfImage(0),
            title: Text("书架"),
          ),
          BottomNavigationBarItem(
            icon: _getHomeImage(1),
            title: Text("书城"),
          ),
          BottomNavigationBarItem(
            icon: _getMeImage(2),
            title: Text("我的"),
          ),
        ],
        currentIndex: _tabIndex,
        backgroundColor: MyColors.white,
        activeColor: MyColors.homeTabText,
        onTap: (index) {
          setState(() {
            _tabIndex = index;
          });
        },
      ),
    );
  }

  Image _getBookshelfImage(int index) {
    if (_tabIndex == index) {
      return _tabImages[1];
    } else {
      return _tabImages[0];
    }
  }

  Image _getHomeImage(int index) {
    if (_tabIndex == index) {
      return _tabImages[3];
    } else {
      return _tabImages[2];
    }
  }

  Image _getMeImage(int index) {
    if (_tabIndex == index) {
      return _tabImages[5];
    } else {
      return _tabImages[4];
    }
  }
}
