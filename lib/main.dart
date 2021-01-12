import 'package:flutter/material.dart';
import 'package:myexpense/model/authmodel.dart';
import 'package:myexpense/model/category_model.dart';
import 'package:myexpense/provider/category_provider.dart';
import 'package:myexpense/provider/transaction_provider.dart';
import 'package:myexpense/screen/category_screen.dart';
import 'package:myexpense/screen/login_screen.dart';
import 'package:myexpense/screen/registration_screen.dart';
import 'package:myexpense/screen/tab_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => CategoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => TransactionProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AuthModel(),
        )
      ],
      child: MaterialApp(
        title: 'MyExpense',
        theme: ThemeData(
            primaryColor: Color.fromRGBO(109, 157, 185, 1.0),
            accentColor: Color.fromRGBO(255, 214, 68, 1.0),
            fontFamily: 'OpenSans',
            textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 15,
                  ),
                  button: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 16),
                  headline5: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
            appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                    headline6: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 20,
                    ),
                  ),
            )),
        //home: TabScreen(),
        // home: RegistrationScreen(),
        initialRoute: '/',
        routes: {
          '/': (context) => TabScreen(),
          CategoryScreen.routName: (ctx) => CategoryScreen(),
          RegistrationScreen.routeName: (ctx) => RegistrationScreen(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
        },
      ),
    );
  }
}
