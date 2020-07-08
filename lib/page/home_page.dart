import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../util/utils.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  StreamSubscription _streamSubscription;
  String _eventData;
  BasicMessageChannel _basicMessageChannel;
  BasicMessageChannel _basicMessageChannel2;
  String _messageData;
  String _messageData2;
  MethodChannel _methodChannel;
  String _methodData;

  @override
  void initState() {
    _streamSubscription = EventChannel("com.shouzhong.flutter.demo2/event").receiveBroadcastStream().listen((event) {
      setState(() {
        _eventData = "EventChannel:$event";
      });
    });
    _basicMessageChannel = BasicMessageChannel("com.shouzhong.flutter.demo2/basic", StandardMessageCodec());
    _basicMessageChannel2 = BasicMessageChannel("com.shouzhong.flutter.demo2/basic2", StandardMessageCodec());
    _sendMessage();
    _receiveMessage();
    _methodChannel = MethodChannel("com.shouzhong.flutter.demo2/method");
    _getMethod();
    super.initState();
  }

  Future<void> _sendMessage() async {
    String reply = await _basicMessageChannel.send("发送给native的数据");
    setState(() {
      _messageData = "BasicMessageChannel:$reply";
    });
  }

  void _receiveMessage() {
    _basicMessageChannel2.setMessageHandler((message) async {
      setState(() {
        _messageData2 = "BasicMessageChannel:$message";
      });
      return "返回给native的数据";
    });
  }

  Future<void> _getMethod() async {
    String s = await _methodChannel.invokeMethod("add", {"i1": 1, "i2": 2});
    setState(() {
      _methodData = "MethodChannel:$s";
    });
  }

  @override
  void dispose() {
    if (_streamSubscription != null) {
      _streamSubscription.cancel();
      _streamSubscription = null;
    }
    if (_basicMessageChannel != null) {
      _basicMessageChannel = null;
    }
    if (_basicMessageChannel2 != null) {
      _basicMessageChannel2.setMockMessageHandler(null);
      _basicMessageChannel2 = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 120.mpx,
          alignment: Alignment.center,
          child: Text(_eventData ?? "", style: TextStyle(fontSize: 36.mpx, color: Colors.black),),
        ),
        Container(
          width: double.infinity,
          height: 120.mpx,
          alignment: Alignment.center,
          child: Text(_messageData ?? "", style: TextStyle(fontSize: 36.mpx, color: Colors.black),),
        ),
        Container(
          width: double.infinity,
          height: 120.mpx,
          alignment: Alignment.center,
          child: Text(_messageData2 ?? "", style: TextStyle(fontSize: 36.mpx, color: Colors.black),),
        ),
        Container(
          width: double.infinity,
          height: 120.mpx,
          alignment: Alignment.center,
          child: Text(_methodData ?? "", style: TextStyle(fontSize: 36.mpx, color: Colors.black),),
        ),
      ],
    );
  }
}