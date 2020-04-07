import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoriesProviders with ChangeNotifier{
  List<Category> _categories = [
    Category(
      id: 'c1',
      title: 'business',
      color: Colors.purple,
    categoryImageLocation: 'assets/images/business_news.png',
    ),
    Category(
      id: 'c2',
      title: 'entertainment',
      color: Colors.red,
      categoryImageLocation: 'assets/images/entertainment_news.png',
    ),
    Category(
      id: 'c3',
      title: 'health',
      color: Colors.orange,
      categoryImageLocation: 'assets/images/health_news.png',
    ),
    Category(
      id: 'c4',
      title: 'science',
      color: Colors.amber,
      categoryImageLocation: 'assets/images/science_news.png',
    ),
    Category(
      id: 'c5',
      title: 'sports',
      color: Colors.blue,
      categoryImageLocation: 'assets/images/sports_news.png',
    ),
    Category(
      id: 'c6',
      title: 'technology',
      color: Colors.green,
      categoryImageLocation: 'assets/images/technology_news.png',
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
