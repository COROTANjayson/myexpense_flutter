import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myexpense/model/category_model.dart';
import 'package:myexpense/provider/transaction_provider.dart';
import 'package:myexpense/screen/category_screen.dart';
import 'package:provider/provider.dart';

class CategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final category = Provider.of<CategoryModel>(context, listen: false);
    final amount = Provider.of<TransactionProvider>(context)
        .getDailyAmountbyCat(
            category.id, DateFormat.yMMMd().format(DateTime.now()));
    Map _selectedCat = {
      'categoryId': category.id,
      'selectedDate': DateTime.now()
    };
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(CategoryScreen.routName, arguments: _selectedCat);
      },
      splashColor: Theme.of(context).primaryColor,
      child: Container(
        padding: EdgeInsets.all(10),
        color: category.color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                category.icon,
                Container(
                  width: 200,
                  child: Text(
                    category.title,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Text(
              '$amount',
              style: Theme.of(context).textTheme.headline5,
            )
          ],
        ),
      ),
    );
  }
}
