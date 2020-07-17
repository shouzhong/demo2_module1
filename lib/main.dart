import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:module1/page/home_page.dart';
import 'package:module1/page/login_page.dart';
import 'package:module1/page/web_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp(_widgetForRoute(window.defaultRouteName)));
//  runApp(MyApp());
  // 沉浸式状态栏
//  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//      statusBarColor: Colors.transparent,
//      statusBarIconBrightness: Brightness.dark),
//  );
}

Widget _widgetForRoute(String route) {
  switch(route) {
    case "page_home":
      return HomePage();
    case "page_login":
      return ChangeNotifierProvider(
        create: (_) => LoginViewModel(),
        child: LoginPage(),
      );
    case "page_web":
      return WebPage();
    default:
      return Center(
        child: Text("error"),
      );
  }
}

class MyApp extends StatelessWidget {
  MyApp(this.widget, {this.backgroundColor});

  final Widget widget;
  final Color backgroundColor;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.blue
      ),
      home: Scaffold(
        backgroundColor: backgroundColor ?? Colors.white,
        body: widget,
      ),
    );
  }
}