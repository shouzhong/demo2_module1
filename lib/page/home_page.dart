import 'package:flutter/material.dart';
import 'package:module1/base/my_app_bar.dart';

import '../util/utils.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      alignment: Alignment.center,
      child: Text("测试", style: TextStyle(fontSize: 36.mpx, color: Colors.white),),
    );
  }
}