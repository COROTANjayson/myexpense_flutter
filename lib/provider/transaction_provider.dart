import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myexpense/exceptions/http_exception.dart';

import 'package:myexpense/model/transaction_model.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../services/config.dart';

class TransactionProvider with ChangeNotifier {
  List<TransactionModel> _transaction = [];

  List<TransactionModel> get recentTransactions {
    return _transaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  Future<void> addNewTransaction(var data, var token, var user) async {
    var res = await http.post('$API_URL/expense',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: data);

    if (res.statusCode == 201) {
      // print('Successful');
      fetchAndSetExpenses(user);
    } else {
      throw HttpExceptionModel('An error has Occured');
      //throw Exception('An error has Occured');
    }

    notifyListeners();
  }

  Future<void> editTransaction(var data, var token, var user, var id) async {
    var res = await http.put('$API_URL/expense/$id',
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: data);

    if (res.statusCode == 200) {
      //print('Successful');
      fetchAndSetExpenses(user);
    } else {
      throw HttpExceptionModel('An error has Occured');
      //throw Exception('An error has Occured');
    }

    notifyListeners();
  }

  Future<void> deleteTransaction(id, token, user) async {
    var res = await http.delete('$API_URL/expense/$id',
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token'});

    if (res.statusCode == 200) {
      fetchAndSetExpenses(user);
    } else {
      throw Exception('Error deleting recipe');
    }
  }

  Future<void> fetchAndSetExpenses(String user) async {
    var res = await http.get('$API_URL/users/$user/expense');

    if (res.statusCode == 200) {
      final extractedData = json.decode(res.body) as List;
      if (extractedData == null) {
        return;
      }

      final List<TransactionModel> loadedExpenses = [];

      for (int i = 0; i < extractedData.length; i++) {
        loadedExpenses.add(
          TransactionModel(
            id: extractedData[i]['id'],
            title: extractedData[i]['name'],
            amount: extractedData[i]['amount'].toDouble(),
            date: DateTime.parse(extractedData[i]['date']),
            categoryId: extractedData[i]['category'],
          ),
        );
      }

      _transaction = loadedExpenses;
      print(_transaction.length);
      notifyListeners();
    } else {
      throw Exception('An error has Occured');
    }
  }

  List<TransactionModel> getExpensesbyCategory(String id, String date) {
    return _transaction
        .where((tx) =>
            tx.categoryId == id && DateFormat.yMMMM().format(tx.date) == date)
        .toList();
  }

  double getTotalExpensebyCat(String id, String date) {
    double dailyAmount = 0;

    for (var i = 0; i < _transaction.length; i++) {
      var dateFormat = DateFormat.yMMMM().format(_transaction[i].date);
      if (dateFormat == date && _transaction[i].categoryId == id) {
        dailyAmount += _transaction[i].amount;
      }
    }
    return dailyAmount;
  }

  double getOverallTotal(String date) {
    double sum = 0;
    for (var i = 0; i < _transaction.length; i++) {
      var dateFormat = DateFormat.yMMMM().format(_transaction[i].date);
      if (dateFormat == date) {
        sum += _transaction[i].amount;
      }
    }

    return sum;
  }

  double getDailyAmountbyCat(String id, String date) {
    double dailyAmount = 0;

    for (var i = 0; i < _transaction.length; i++) {
      var dateFormat = DateFormat.yMMMd().format(_transaction[i].date);
      if (dateFormat == date && _transaction[i].categoryId == id) {
        dailyAmount += _transaction[i].amount;
      }
    }
    return dailyAmount;
  }
}
