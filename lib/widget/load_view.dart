import 'package:flutter/material.dart';

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
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 800));
    _animation = IntTween(begin: 0, end: 10).animate(_controller)
      ..addListener(() {
        if (_position != _animation.value) {
          _position = _animation.value;
          setState(() {});
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
    return Expanded(
      child: Container(
          alignment: Alignment.center,
          child: Image.asset(
            _imageList[_animation.value],
            width: 43,
            height: 43,
          )),
    );
  }

  dispose() {
    _controller.dispose();
    super.dispose();
  }
}

enum LoadStatus {
  LOADING,
  SUCCESS,
  FAILURE,
}
