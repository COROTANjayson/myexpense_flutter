import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myexpense/exceptions/http_exception.dart';
import 'package:myexpense/model/authmodel.dart';
import 'package:myexpense/model/category_model.dart';
import 'package:myexpense/model/transaction_model.dart';
import 'package:myexpense/provider/transaction_provider.dart';

import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CategoryList extends StatefulWidget {
  final Color color;
  CategoryList(this.color);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  var _expanded = false;
  var _isLoading = false;
  final _nameFocusNode = FocusNode();
  final _amountFocusNode = FocusNode();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  var _enteredName;
  var _enteredAmount;
  var _isOkay = false;
  var _errorMessage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _nameController.dispose();
    _amountFocusNode.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _showErrorDialog(String message) async {
    return showDialog(
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

  void _deleteTransaction() async {
    final transaction = Provider.of<TransactionModel>(context, listen: false);
    setState(() {
      _isLoading = true;
      _expanded = false;
    });

    try {
      var token = Provider.of<AuthModel>(context, listen: false).token;
      var _user = Provider.of<AuthModel>(context, listen: false).user;
      await Provider.of<TransactionProvider>(context, listen: false)
          .deleteTransaction(transaction.id, token, _user);
    } on HttpExceptionModel catch (error) {
      const errorMessage =
          'Adding Transaction failed, Please check your connection';
      if (error.toString().contains('An error has Occured')) {
        _showErrorDialog(errorMessage);
      }
    } catch (error) {
      const errorMessage = 'Could not add transaction. Please try again later';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
      _expanded = false;
    });
  }

  Future<void> _displayConfirmDelete(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Confirm to Delete'),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: Text('CONFIRM'),
                onPressed: () {
                  _deleteTransaction();
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  Future<void> _displayTextInputDialog(BuildContext context, int select) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: select == 0 ? Text('Name') : Text('Amount'),
            content: select == 0
                ? TextField(
                    focusNode: _nameFocusNode,
                    controller: _nameController,
                    decoration: InputDecoration(hintText: "Enter Name"),
                  )
                : TextField(
                    focusNode: _amountFocusNode,
                    keyboardType: TextInputType.number,
                    controller: _amountController,
                    decoration: InputDecoration(hintText: "Enter Amount"),
                  ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    if (!_isOkay) {
                      if (select == 0) {
                        _nameController.clear();
                      } else {
                        _amountController.clear();
                      }
                    }

                    //_isOkay = false;
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  (select == 0)
                      ? _enteredName = _nameController.text
                      : _enteredAmount = _amountController.text;

                  _isOkay = true;
                  _submitData();

                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void _submitData() async {
    //print('${_amountController.text.isNotEmpty}');
    //if(_amountController.text.isEmpty |)
    final transaction = Provider.of<TransactionModel>(context, listen: false);
    try {
      Map data;

      if (_nameController.text.isNotEmpty) {
        final enteredTitle = _enteredName;
        data = {
          'name': enteredTitle,
        };
      }
      if (_amountController.text.isNotEmpty) {
        // print('click');
        final enteredAmount = double.parse(_enteredAmount);
        data = {
          'amount': enteredAmount.toString(),
        };
      }
      //print(data);
      var token = Provider.of<AuthModel>(context, listen: false).token;
      var _user = Provider.of<AuthModel>(context, listen: false).user;

      await Provider.of<TransactionProvider>(context, listen: false)
          .editTransaction(data, token, _user, transaction.id);
      //print('Successful');
    } on HttpExceptionModel catch (error) {
      //print(error);
      _errorMessage =
          'Updating Transaction failed, Please check your connection';
      if (error.toString().contains('An error has Occured')) {
        //print('true');
        setState(() {
          _isLoading = true;
        });
        _showErrorDialog(_errorMessage);
      }
    } catch (error) {
      print('Somtheing Error');
      print(error);

      setState(() {
        _errorMessage = 'Could not Update transaction. Please try again later';
        _isLoading = true;
      });

      _showErrorDialog(_errorMessage);
    }
    setState(() {
      _isLoading = false;
      _expanded = false;
    });
    //Navigator.of(context).pop(); //Closed the top most moodal sheet
  }

  @override
  Widget build(BuildContext context) {
    int select;
    final transaction = Provider.of<TransactionModel>(context, listen: false);
    return (_isLoading)
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
            ),
          )
        : Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 5,
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                            child: Text(
                          DateFormat.d().format(transaction.date),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )),
                      ),
                    ),
                    title: Text(
                      DateFormat.yMMMM().format(transaction.date),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    subtitle: Text(
                      transaction.title,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    trailing: Container(
                      alignment: Alignment.center,
                      height: double.infinity,
                      width: 80,
                      color: widget.color,
                      child: Text(
                        '${transaction.amount}',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                if (_expanded)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            _displayConfirmDelete(context);
                          },
                        ),
                        PopupMenuButton(
                          onSelected: (_) {
                            _displayTextInputDialog(context, select);
                          },
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              child: Text('Edit Amount'),
                              value: select = 0,
                            ),
                            PopupMenuItem(
                              child: Text('Edit Name'),
                              value: select = 1,
                            )
                          ],
                        )
                      ],
                    ),
                  )
              ],
            ),
          );
  }
}
