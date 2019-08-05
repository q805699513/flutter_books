import 'package:flutter/material.dart';
import 'package:flutter_books/res/dimens.dart';
import 'package:flutter_books/ui/home/app_home.dart';

///@author longshaohua

class AboutPandaPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AboutPandaPageState();
}

class _AboutPandaPageState extends State<StatefulWidget> {
  final url = 'https://github.com/q805699513/flutter_books';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        title: Text("关于Panda看书"),
      ),
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.fromLTRB(Dimens.leftMargin, 20, Dimens.rightMargin, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "作者：longshaohua",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    "github：",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Text(
                        url,
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      ),
                      onTap: () {
                        _launchURL();
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "本项目仅用于学习交流",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 原生代码调用系统浏览器显示网页，url 为要打开的链接值传递
  Future<Null> _launchURL() async {
    print("launchURL start");
    final String result = await MyHomePage.platform.invokeMethod(
      'launchURL',
      <String, dynamic>{
        'url': url,
      },
    );
    print("launchURL=$result");
  }
}
