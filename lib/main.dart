import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_books/res/colors.dart';
import 'package:flutter_books/ui/home/app_home.dart';

void main() {
  runApp(MyApp());
  if (Platform.isAndroid) {
    //设置状态栏透明
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        cursorColor: MyColors.textPrimaryColor,
        scaffoldBackgroundColor: MyColors.white,
        primaryColor: MyColors.primary,
      ),
      home: MyHomePage(),
    );
  }
}
