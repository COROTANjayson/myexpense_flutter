import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:myexpense/provider/category_provider.dart';
import 'package:myexpense/provider/transaction_provider.dart';
import 'package:myexpense/widget/category_list.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  static const routName = '/category-list';

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  DateTime _selectedDate;
  String _formattedDate;

  @override
  void didChangeDependencies() {
    final selectedCat = ModalRoute.of(context).settings.arguments as Map;
    _selectedDate = selectedCat['selectedDate'];
    _formattedDate = DateFormat.yMMMM().format(selectedCat['selectedDate']);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCat = ModalRoute.of(context).settings.arguments as Map;
    final category = Provider.of<CategoryProvider>(context, listen: false)
        .getCategoryId(selectedCat['categoryId']);
    final transaction = Provider.of<TransactionProvider>(context)
        .getExpensesbyCategory(selectedCat['categoryId'], _formattedDate);
    //_selectedDate = selectedCat['selectedDate'];

    void _presentDatePicker() {
      showMonthPicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime.now(),
      ).then((pickedDate) {
        if (pickedDate == null) {
          return;
        }
        setState(() {
          _selectedDate = pickedDate;
          _formattedDate = DateFormat.yMMMM().format(_selectedDate);
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 120,
                  padding: EdgeInsets.all(10),
                  color: category.color,
                  child: Column(
                    children: [
                      category.icon,
                      Container(
                        width: 100,
                        child: Text(
                          category.title,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                FlatButton(
                  textColor: Colors.black,
                  child: Text(
                    DateFormat.yMMMM().format(_selectedDate),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  onPressed: _presentDatePicker,
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ListView.builder(
                  itemCount: transaction.length,
                  itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                    value: transaction[i],
                    child: CategoryList(category.color),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
