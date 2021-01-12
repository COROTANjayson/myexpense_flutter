import 'package:flutter/material.dart';
import 'package:myexpense/widget/registration_form.dart';

class RegistrationScreen extends StatelessWidget {
  static const routeName = 'registration';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Registration'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Stack(children: [
          SingleChildScrollView(
              child: Container(
                  child: RegistrationForm(),
                  padding: EdgeInsets.all(12)) //Container
              ) //SingleChildScrollView
        ]));
  }
}
