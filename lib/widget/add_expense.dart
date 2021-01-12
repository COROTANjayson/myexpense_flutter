import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myexpense/exceptions/http_exception.dart';
import 'package:myexpense/model/authmodel.dart';
import 'package:myexpense/model/category_model.dart';
import 'package:myexpense/model/transaction_model.dart';
import 'package:myexpense/provider/category_provider.dart';
import 'package:myexpense/provider/transaction_provider.dart';
import 'package:provider/provider.dart';

class AddExpenseWidget extends StatefulWidget {
  @override
  _AddExpenseWidgetState createState() => _AddExpenseWidgetState();
}

class _AddExpenseWidgetState extends State<AddExpenseWidget> {
  final _nameFocusNode = FocusNode();
  final _amountFocusNode = FocusNode();
  //final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  var _isOkay = false;
  var _enteredName;
  var _enteredAmount;
  DateTime _selectedDate = DateTime.now();
  var _isLoading = false;
  var _errorMessage;

  List<DropdownMenuItem<CategoryModel>> _dropdownMenuItems;
  CategoryModel _selectedItem;

  // var _isInit = true;
  // var _isLoading = false;

  // var _addTransaction = TransactionModel(
  //     id: null, title: '', amount: 0, date: null, categoryId: 'string');

  @override
  void initState() {
    final _dropdownItems =
        Provider.of<CategoryProvider>(context, listen: false).items;
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _selectedItem = _dropdownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<CategoryModel>> buildDropDownMenuItems(
      List<CategoryModel> listItems) {
    List<DropdownMenuItem<CategoryModel>> items = List();
    for (CategoryModel listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.title),
          value: listItem,
        ),
      );
    }
    return items;
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

  void _submittData() async {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _enteredName;
    final enteredAmount = double.parse(_enteredAmount);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    //print('$enteredTitle');
    try {
      Map data = {
        'name': enteredTitle,
        'category': _selectedItem.id,
        'amount': enteredAmount.toString(),
        'date': DateFormat("yyyy-MM-dd hh:mm:ss").format(_selectedDate),
      };

      var token = Provider.of<AuthModel>(context, listen: false).token;
      var _user = Provider.of<AuthModel>(context, listen: false).user;

      await Provider.of<TransactionProvider>(context, listen: false)
          .addNewTransaction(data, token, _user);
      print('Successful');
    } on HttpExceptionModel catch (error) {
      _errorMessage = 'Adding Transaction failed, Please check your connection';
      if (error.toString().contains('An error has Occured')) {
        print('true');
        setState(() {
          _isLoading = true;
        });
        _showErrorDialog(_errorMessage);
      }
    } catch (error) {
      print('Somtheing Error');

      setState(() {
        _errorMessage = 'Could not add transaction. Please try again later';
        _isLoading = true;
      });

      _showErrorDialog(_errorMessage);
    }

    Navigator.of(context).pop(); //Closed the top most moodal sheet
  }

  void _presentDatePicker() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light(),
            child: child,
          );
        }).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
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
                  setState(() {
                    (select == 0)
                        ? _enteredName = _nameController.text
                        : _enteredAmount = _amountController.text;

                    _isOkay = true;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //print(_isOkay);
    int select;
    return (_isLoading)
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  height: 13,
                ),
                Text('$_errorMessage'),
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Close',
                    style: Theme.of(context).textTheme.button,
                  ),
                  color: Theme.of(context).primaryColor,
                )
              ],
            ),
          )
        : Card(
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'Category: ',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(width: 20.0),
                          DropdownButton<CategoryModel>(
                              value: _selectedItem,
                              items: _dropdownMenuItems,
                              onChanged: (value) {
                                setState(() {
                                  _selectedItem = value;
                                });
                              }),
                        ],
                      ),
                    ),
                    InkWell(
                      focusColor: Theme.of(context).accentColor,
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: double.infinity,
                        child: (_nameController.text.isEmpty ||
                                _enteredName == null)
                            ? Text(
                                'Name',
                                style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              )
                            : Text('$_enteredName',
                                style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold)),
                      ),
                      onTap: () {
                        //     TextFormField(
                        //   decoration: InputDecoration(labelText: 'Name'),
                        //   controller: _nameController,
                        // ),
                        select = 0;
                        _displayTextInputDialog(context, select);
                      },
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      color: Theme.of(context).primaryColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 50,
                            width: double.infinity,
                            child: InkWell(
                              hoverColor: Colors.black,
                              child: (_amountController.text.isEmpty ||
                                      _enteredAmount == null)
                                  ? Text(
                                      'Amount 0.00',
                                      style: TextStyle(
                                          fontSize: 35.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
                                    )
                                  : Text(
                                      '${double.parse(_enteredAmount)}',
                                      style: TextStyle(
                                          fontSize: 35.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
                                    ),
                              onTap: () {
                                _displayTextInputDialog(context, select = 1);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            child: RaisedButton(
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Container(
                                height: 50,
                                width: 70,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Add'),
                                    Icon(Icons.add),
                                  ],
                                ),
                              ),
                              color: Color.fromRGBO(69, 86, 146, 1),
                              textColor: Colors.white,
                              onPressed: _submittData,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          DateFormat.yMd().format(_selectedDate),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        child: Text(
                          'Choose Date',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: _presentDatePicker,
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
