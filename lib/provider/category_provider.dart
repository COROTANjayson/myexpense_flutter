import 'package:flutter/material.dart';
import 'package:myexpense/model/category_model.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoryModel> _category = [
    CategoryModel(
      id: 'c1',
      title: 'Grocery',
      color: Color.fromRGBO(125, 255, 177, 1),
      icon: Icon(
        Icons.local_grocery_store,
        size: 50,
      ),
    ),
    CategoryModel(
      id: 'c2',
      title: 'Foods',
      color: Color.fromRGBO(255, 195, 125, 1),
      icon: Icon(
        Icons.restaurant,
        size: 50,
      ),
    ),
    CategoryModel(
      id: 'c3',
      title: 'Shopping',
      color: Color.fromRGBO(125, 216, 255, 1),
      icon: Icon(
        Icons.shopping_basket,
        size: 50,
      ),
    ),
    CategoryModel(
      id: 'c4',
      title: 'Health/Medicine',
      color: Color.fromRGBO(255, 125, 125, 1),
      icon: Icon(
        Icons.add_to_queue,
        size: 50,
      ),
    ),
    CategoryModel(
      id: 'c5',
      title: 'Transport/Bill',
      color: Color.fromRGBO(255, 125, 195, 1),
      icon: Icon(
        Icons.train,
        size: 50,
      ),
    ),
    CategoryModel(
      id: 'c6',
      title: 'Others',
      color: Color.fromRGBO(221, 125, 255, 1),
      icon: Icon(
        Icons.devices_other,
        size: 50,
      ),
    ),
  ];

  List<CategoryModel> get items {
    return [..._category];
  }

  CategoryModel getCategoryId(String id) {
    return _category.firstWhere((cat) => cat.id == id);
  }
}
