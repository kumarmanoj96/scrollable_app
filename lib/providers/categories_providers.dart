import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/http_exception.dart';
import './category_providers.dart';

class CategoriesProviders with ChangeNotifier {
  List<CategoryProviders> _categories = [];

  final String authToken;
  CategoriesProviders(this.authToken, this._categories);

  List<CategoryProviders> get categories {
    return _categories;
  }

  List<CategoryProviders> get favoriteCategories {
    return _categories.where((category) => category.isFavourite);
  }

  CategoryProviders getCategoryByCategoryId(String categoryId) {
    return _categories.firstWhere((category) => category.id == categoryId);
  }

  bool _isFavouriteCategory(String categoryId) {
    return _categories
        .any((category) => category.id == categoryId && category.isFavourite);
  }

  Future<void> addCategory(CategoryProviders category) async {
    final url =
        'https://scrollable-app-582c6.firebaseio.com/categories.json?auth=$authToken';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': category.title,
            'imageURL': category.categoryImageLocation,
            'isFavourite': false,
          }));
      final newCategory = CategoryProviders(
        title: category.title,
        id: json.decode(response.body)['name'],
        isFavourite: false,
        categoryImageLocation: category.categoryImageLocation,
      );
      _categories.add(newCategory);
      notifyListeners();
    } catch (error) {
      throw HttpException('Could not Add Category.');
    }
  }

  Future<void> fetchAndSetCategories() async {
    var url =
        'https://scrollable-app-582c6.firebaseio.com/categories.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        _categories = [];
        return;
      }
      print(extractedData);
      final List<CategoryProviders> loadedCategories = [];
      extractedData.forEach((key, value) {
        loadedCategories.add(CategoryProviders(
          id: key,
          title: value["title"],
          categoryImageLocation: value["categoryImageLocation"],
          isFavourite: value["isFavourite"],
        ));
        _categories = loadedCategories;
      });
      notifyListeners();
    } catch (error) {
      throw HttpException('Could not load categories.');
    }
    print('Done');
  }
}
