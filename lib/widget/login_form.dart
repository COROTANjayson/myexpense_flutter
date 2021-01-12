import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:myexpense/model/authmodel.dart';
import 'package:myexpense/screen/registration_screen.dart';
import 'package:myexpense/widget/registration_form.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
// import 'models/authmodel.dart';
import '../services/loginservice.dart';

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() => LoginFormState();
}

InputDecoration txtDecoration(var str) {
  return InputDecoration(
    fillColor: Colors.white,
    filled: true,
    hintText: str,
    hintStyle: TextStyle(
      fontFamily: 'Lato',
      fontSize: 18,
    ),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
    contentPadding: EdgeInsets.fromLTRB(15, 15, 10, 8),
    errorStyle: TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.bold,
    ),
  );
}

class LoginFormState extends State<LoginForm> {
  final _bottomSpace = 10.0;
  final _formKey = GlobalKey<FormState>();
  final emailExp =
      new RegExp(r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)");
  final passTxtController = TextEditingController();
  final emailTxtController = TextEditingController();
  var _isLoading = false;
  //String errMsg = "";
  @override
  void dispose() {
    passTxtController.dispose();
    emailTxtController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An error Occured'),
              content: Text(message),
              actions: [
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ));
  }

  _login() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      String email = emailTxtController.text;
      String password = passTxtController.text;
      var loginRes = await authenticate(email, password);
      if (loginRes.errMsg == null) {
        Provider.of<AuthModel>(context, listen: false)
            .login(loginRes.user, loginRes.token);
        Navigator.pushNamedAndRemoveUntil(
            context, '/', (Route<dynamic> route) => false);
      } else {
        _showErrorDialog(loginRes.errMsg);
      }
    } catch (error) {
      const errorMessage = 'Could not authenticate you. Please try again later';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading)
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'MyExpense',
                  style: TextStyle(fontSize: 40),
                ),
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      TextFormField(
                          controller: emailTxtController,
                          decoration: txtDecoration('Email'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter your Email';
                            }
                            return null;
                          }),
                      SizedBox(height: _bottomSpace),
                      TextFormField(
                          obscureText: true,
                          decoration: txtDecoration('Password'),
                          controller: passTxtController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter your password';
                            }

                            return null;
                          }),
                      SizedBox(height: _bottomSpace),
                      RaisedButton(
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Lato'),
                          ),
                          onPressed: _login,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: Theme.of(context).primaryColor),
                      SizedBox(height: 30),
                      Column(
                        children: [
                          Text(
                            'Don\'t have an account?',
                            style: TextStyle(fontFamily: 'Lato'),
                          ),
                          FlatButton(
                            textColor: Theme.of(context).primaryColor,
                            child: Text(
                              'Register Now',
                              style: Theme.of(context)
                                  .appBarTheme
                                  .textTheme
                                  .headline6,
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(RegistrationScreen.routeName);
                            },
                          )
                        ],
                      )
                    ],
                  ) //Column

                  ),
            ],
          ); //Form
  }
}
