import 'package:flutter/material.dart';
import 'package:myexpense/model/authmodel.dart';
import 'package:myexpense/provider/category_provider.dart';
import 'package:myexpense/provider/transaction_provider.dart';
import 'package:myexpense/screen/login_screen.dart';
import 'package:myexpense/widget/add_expense.dart';
import 'package:myexpense/widget/category_item.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      var _user = Provider.of<AuthModel>(context, listen: false).user;

      Provider.of<TransactionProvider>(context)
          .fetchAndSetExpenses(_user)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _startAddNewExpense(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: AddExpenseWidget(),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Personal Expenses'),
        actions: [
          PopupMenuButton(
            onSelected: (_) {
              Provider.of<AuthModel>(context, listen: false).logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginScreen.routeName, (Route<dynamic> route) => false);
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Log out'),
                value: 0,
              ),
            ],
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Daily Expenses: ${DateFormat.yMMMd().format(DateTime.now())} ',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Consumer<CategoryProvider>(
                builder: (context, category, child) {
                  return Container(
                    height: 400,
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    child: GridView.builder(
                      itemCount: category.items.length,
                      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                        value: category.items[i],
                        child: CategoryItem(),
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 4 / 5,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewExpense(context),
      ),
    );
  }
}
