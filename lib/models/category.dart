import 'package:flutter/material.dart';

class Category {
  final String id;
  final String title;
  final Color color;
  final String categoryImageLocation;
  bool isFavourite;
  Category({
    @required this.id,
    @required this.title,
    this.color = Colors.orange,
    this.isFavourite = false,
    this.categoryImageLocation,
  });
}
