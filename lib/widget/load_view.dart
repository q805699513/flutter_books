import 'package:flutter/material.dart';
import 'package:flutter_books/res/colors.dart';

class LoadingView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView>
    with SingleTickerProviderStateMixin {
  List<String> _imageList = [
    "images/icon_load_1.png",
    "images/icon_load_2.png",
    "images/icon_load_3.png",
    "images/icon_load_4.png",
    "images/icon_load_5.png",
    "images/icon_load_6.png",
    "images/icon_load_7.png",
    "images/icon_load_8.png",
    "images/icon_load_9.png",
    "images/icon_load_10.png",
    "images/icon_load_11.png",
  ];
  Animation<int> _animation;
  AnimationController _controller;
  int _position = 0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _animation = IntTween(begin: 0, end: 10).animate(_controller)
      ..addListener(() {
        if (_position != _animation.value) {
          setState(() {
            _position = _animation.value;
          });
        }
      });

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        color: MyColors.homeGrey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              _imageList[_position],
              width: 43,
              height: 43,
              gaplessPlayback: true,
            ),
          ],
        )
    );
  }

  dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class FailureView extends StatefulWidget {
  final OnLoadReloadListener _listener;

  FailureView(this._listener);

  @override
  State<StatefulWidget> createState() => _FailureViewState();
}

class _FailureViewState extends State<FailureView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.homeGrey,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "images/icon_network_error.png",
            width: 150,
            height: 150,
          ),
          SizedBox(
            height: 14,
          ),
          Text(
            "咦？没网络啦~检查下设置吧",
            style: TextStyle(fontSize: 12, color: MyColors.textBlack9),
          ),
          SizedBox(
            height: 25,
          ),
          MaterialButton(
            onPressed: () {
              this.widget._listener.onReload();
            },
            minWidth: 150,
            height: 43,
            color: MyColors.textPrimaryColor,
            child: Text(
              "重新加载",
              style: TextStyle(
                color: MyColors.white,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}

abstract class OnLoadReloadListener {
  void onReload();
}

enum LoadStatus {
  LOADING,
  SUCCESS,
  FAILURE,
}
