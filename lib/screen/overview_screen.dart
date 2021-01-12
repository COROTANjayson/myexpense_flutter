import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:myexpense/provider/category_provider.dart';
import 'package:myexpense/provider/transaction_provider.dart';
import 'package:myexpense/widget/category_overview.dart';
import 'package:provider/provider.dart';

class OverviewScreen extends StatefulWidget {
  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _totalExpense = Provider.of<TransactionProvider>(context)
        .getOverallTotal(DateFormat.yMMMM().format(_selectedDate));
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
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses List'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: Text(
              'Total Expenses: $_totalExpense',
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Consumer<CategoryProvider>(
            builder: (context, category, child) {
              return Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: ListView.builder(
                    itemCount: category.items.length,
                    itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                      value: category.items[i],
                      child: CategoryOverview(_selectedDate),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
