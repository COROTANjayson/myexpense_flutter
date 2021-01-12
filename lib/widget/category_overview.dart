import 'package:flutter/material.dart';
import 'package:myexpense/model/category_model.dart';
import 'package:myexpense/provider/transaction_provider.dart';
import 'package:myexpense/screen/category_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CategoryOverview extends StatelessWidget {
  final DateTime date;

  CategoryOverview(this.date);

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat.yMMMM().format(date);
    final category = Provider.of<CategoryModel>(context, listen: false);

    final amount = Provider.of<TransactionProvider>(context)
        .getTotalExpensebyCat(category.id, formattedDate);

    Map _selectedCat = {'categoryId': category.id, 'selectedDate': date};
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          CategoryScreen.routName,
          arguments: _selectedCat,
        );
      },
      splashColor: Theme.of(context).primaryColor,
      child: Container(
        padding: EdgeInsets.all(10),
        color: category.color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                category.icon,
                Text(
                  category.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            Text('$amount', style: Theme.of(context).textTheme.headline5),
          ],
        ),
      ),
    );
  }
}
