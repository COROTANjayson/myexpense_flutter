import 'package:flutter/foundation.dart'; // for @required

class TransactionModel with ChangeNotifier {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String categoryId;

  TransactionModel({
    @required this.id,
    @required this.title,
    @required this.amount,
    @required this.date,
    @required this.categoryId,
  });
}
