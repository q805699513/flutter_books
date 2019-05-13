import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BookChapters extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BookChaptersState();
  }
}

class BookChaptersState extends State<BookChapters> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('首页'),
//        leading: Image.asset(
//          'images/icon_title_back.png',
//          width: 20,
//          height: 48,
//        ),
      ),
      body: new Text('首页'),
    );
  }
}
