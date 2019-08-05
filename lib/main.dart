import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_books/res/colors.dart';
import 'package:flutter_books/ui/splash/splash_page.dart';

void main() {
  runApp(MyApp());
  //设置状态栏透明
  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
  );
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        cursorColor: MyColors.textPrimaryColor,
        scaffoldBackgroundColor: MyColors.white,
        primaryColor: MyColors.primary,
      ),
      home: SplashPage(),
    );
  }
}
