import 'package:flutter/material.dart';
import 'package:myexpense/exceptions/http_exception.dart';
import 'package:myexpense/services/registration_service.dart';
import 'package:myexpense/model/authmodel.dart';
import '../services/loginservice.dart';
import 'package:provider/provider.dart';

class RegistrationForm extends StatefulWidget {
  @override
  RegistrationFormState createState() => RegistrationFormState();
}

InputDecoration txtDecoration(var str) {
  return InputDecoration(
      fillColor: Color.fromRGBO(239, 239, 239, 1.0),
      filled: true,
      hintText: str,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.fromLTRB(15, 15, 10, 8),
      errorStyle: TextStyle(color: Colors.red));
}

class RegistrationFormState extends State<RegistrationForm> {
  final _bottomSpace = 12.0;
  final _formKey = GlobalKey<FormState>();
  bool _isAccepted = false;
  var _isLoading = false;
  //var _isLogin = false;
  final emailExp =
      new RegExp(r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)");
  final passTxtController = TextEditingController();
  final fnameTxtController = TextEditingController();
  final lnameTxtController = TextEditingController();
  final emailTxtController = TextEditingController();
  final confirmTxtController = TextEditingController();
  String _showErrorMessage;
  @override
  void dispose() {
    passTxtController.dispose();
    fnameTxtController.dispose();
    lnameTxtController.dispose();
    emailTxtController.dispose();
    confirmTxtController.dispose();
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

  Future<void> _register() async {
    _showErrorMessage = null;
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      Map data = {
        'fname': fnameTxtController.text,
        'lname': lnameTxtController.text,
        'email': emailTxtController.text,
        'password': confirmTxtController.text
      };
      await register(data).then((_) async {
        print('Succesful');
        // setState(() {
        //   _isLogin = true;
        // });
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
      });
    } on HttpExceptionModel catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('The email has already been taken.')) {
        errorMessage = 'The email address is already in use.';
        _showErrorDialog(errorMessage);
      }
      setState(() {
        _showErrorMessage = errorMessage;
      });
    } catch (error) {
      const errorMessage = 'Please try again later';
      print(error);
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
            children: [
              Text(
                'MyExpense',
                style: TextStyle(fontSize: 40),
              ),
              Form(
                  key: _formKey,
                  child: Column(children: [
                    SizedBox(height: 20),
                    TextFormField(
                        controller: fnameTxtController,
                        decoration: txtDecoration('First Name'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'First name is Required';
                          }
                          return null;
                        }),
                    SizedBox(height: _bottomSpace),
                    TextFormField(
                        controller: lnameTxtController,
                        decoration: txtDecoration('Last Name'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Last name is Required';
                          }
                          return null;
                        }),
                    SizedBox(height: _bottomSpace),
                    TextFormField(
                        decoration: txtDecoration('Email'),
                        controller: emailTxtController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Email is Required';
                          } else if (emailExp.hasMatch(value) == false) {
                            return 'Invalid Email';
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
                            return 'Password is Required';
                          } else if (value.length < 8)
                            return 'Password must be at least 8 characters';
                          return null;
                        }),
                    SizedBox(height: _bottomSpace),
                    TextFormField(
                        obscureText: true,
                        decoration: txtDecoration('Confirm Password'),
                        controller: confirmTxtController,
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Please confirm your password';
                          else if (value != passTxtController.text)
                            return 'Password did not match';

                          return null;
                        }),
                    SizedBox(height: 15),
                    Row(children: [
                      Checkbox(
                        value: _isAccepted,
                        checkColor: Theme.of(context).primaryColor,
                        activeColor: Colors.yellow,
                        onChanged: (isAccepted) {
                          setState(() {
                            _isAccepted = isAccepted;
                          });
                        },
                      ),
                      Text(
                        'By clicking Register, you agree to our terms\n and data policy',
                      )
                    ]),
                    RaisedButton(
                        child: Text(
                          'REGISTER',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Lato'),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: Theme.of(context).primaryColor,
                        onPressed: _isAccepted ? _register : null)
                  ]) //Column

                  ),
            ],
          ); //Form
  }
}
