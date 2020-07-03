import 'package:flutter/material.dart';

import '../util/utils.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  MyAppBar({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _MyAppbarState();
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _MyAppbarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Container(
        height: 88.mpx,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.only(left: 30.mpx, top: 26.mpx, bottom: 26.mpx),
                child: Image.asset(
                  "images/ic_arrow_left.png",
                  width: 36.mpx,
                  height: 36.mpx,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                widget.title ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 36.mpx, color: Color(0xff333333)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

