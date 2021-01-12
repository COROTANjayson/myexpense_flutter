import 'package:flutter/material.dart';

class CategoryModel with ChangeNotifier {
  final String id;
  final String title;
  final Color color;
  final Widget icon;

  CategoryModel({
    @required this.id,
    @required this.title,
    this.color,
    this.icon,
  });
}
