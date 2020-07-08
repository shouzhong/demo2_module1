import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginViewModel>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: provider.usernameController,
          decoration: InputDecoration(labelText: "username"),
        ),
        TextField(
          controller: provider.passwordController,
          decoration: InputDecoration(labelText: "password"),
        ),
        RaisedButton(
          onPressed: provider.login,
          /// 根据 state 的值，按钮显示不同内容。
          child: provider.state == 0
              ? Text("login")
              : provider.state == 1
                  ? CircularProgressIndicator()
                  : provider.state == 2 ? Icon(Icons.done) : Icon(Icons.cancel),
        ),
      ],
    );
  }
}

class _LoginModel {
  Stream<int> login(dynamic data) {
    return Stream.fromFuture(
      Future.delayed(Duration(seconds: 2), () {
        if (data["username"] == "aaa" && data["password"] == "123") return 0;
        return -1;
      })
    );
  }
}

class LoginViewModel with ChangeNotifier {
  final _model = _LoginModel();
  int state = 0;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  login() {
    final data = {
      "username": usernameController.text,
      "password": passwordController.text,
    };
    if (state != 0) return;
    state = 1;
    notifyListeners();
    _model.login(data).listen((v) {
      if (v != 0) {
        /// 返回值不为0，请求失败
        state = 3;
        notifyListeners();
        Future.delayed(Duration(seconds: 1), () {
          state = 0;
          notifyListeners();
        });
      } else {
        /// 返回值为0，请求成功
        state = 2;
        notifyListeners();
        Future.delayed(Duration(seconds: 1), () {
          state = 0;
          notifyListeners();
        });
      }
    });
  }

}