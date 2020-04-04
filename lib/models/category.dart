import 'package:flutter/material.dart';

class Category {
  final String id;
  final String title;
  final Color color;
  bool isFavourite;
  Category({
    @required this.id,
    @required this.title,
    this.color = Colors.orange,
    this.isFavourite = false,
  });
}
