import 'package:flutter/material.dart';
import 'package:myexpense/widget/login_form.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = 'login';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              'Login',
              style: Theme.of(context).appBarTheme.textTheme.headline6,
            ),
            backgroundColor: Theme.of(context).primaryColor),
        body: Stack(children: [
          SingleChildScrollView(
            child: Container(
              child: LoginForm(),
              padding: EdgeInsets.all(12),
            ),
          )
        ]));
  }
}
