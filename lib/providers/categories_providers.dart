import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoriesProviders with ChangeNotifier{
  List<Category> _categories = [
    Category(
      id: 'c1',
      title: 'business',
      color: Colors.purple,
    ),
    Category(
      id: 'c2',
      title: 'entertainment',
      color: Colors.red,
    ),
    Category(
      id: 'c3',
      title: 'health',
      color: Colors.orange,
    ),
    Category(
      id: 'c4',
      title: 'science',
      color: Colors.amber,
    ),
    Category(
      id: 'c5',
      title: 'sports',
      color: Colors.blue,
    ),
    Category(
      id: 'c6',
      title: 'technology',
      color: Colors.green,
    ),
  ];

  void toggleFavouriteStatus(String categoryId) {
    _categories.firstWhere((category) {
      if (category.id == categoryId) {
        category.isFavourite = !category.isFavourite;
      }
      return false;
    });
  }

  List<Category> get categories {
    return _categories;
  }
}
