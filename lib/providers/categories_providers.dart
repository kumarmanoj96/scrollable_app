import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/http_exception.dart';
import './category_providers.dart';

class CategoriesProviders with ChangeNotifier {
  List<CategoryProviders> _categories = [];

  final String authToken;
  final String userId;
  CategoriesProviders(this.authToken, this.userId, this._categories);

  List<CategoryProviders> get categories {
    return _categories;
  }

  List<CategoryProviders> get favoriteCategories {
    print("*********insidefavoriteCategories ");
    print(_categories);
    return _categories.where((category) => category.isFavorite).toList();
  }

  CategoryProviders getCategoryByCategoryId(String categoryId) {
    return _categories.firstWhere((category) => category.id == categoryId);
  }

  bool _isFavouriteCategory(String categoryId) {
    return _categories
        .any((category) => category.id == categoryId && category.isFavorite);
  }

  Future<void> addCategory(CategoryProviders category) async {
    final url =
        'https://scrollable-app-582c6.firebaseio.com/categories.json?auth=$authToken';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': category.title,
            'categoryImageLocation': category.categoryImageLocation,
          }));
      final newCategory = CategoryProviders(
        title: category.title,
        id: json.decode(response.body)['name'],
        isFavorite: false,
        categoryImageLocation: category.categoryImageLocation,
      );
      print("new category added with id:${newCategory.id}");
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
      url =
          'https://scrollable-app-582c6.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      print("*******favoriteData:");
      print(favoriteData);
      final List<CategoryProviders> loadedCategories = [];
      extractedData.forEach((categoryId, value) {
        loadedCategories.add(CategoryProviders(
          id: categoryId,
          title: value["title"],
          categoryImageLocation: value["categoryImageLocation"],
          isFavorite: favoriteData == null || favoriteData[categoryId] ==null
              ? false
              : favoriteData[categoryId]['isFavorite'] ?? false,
        ));
        _categories = loadedCategories;
      });
      notifyListeners();
    } catch (error) {
      print(error);
      throw HttpException('Could not load categories.');
    }
    print('Done');
  }
}
