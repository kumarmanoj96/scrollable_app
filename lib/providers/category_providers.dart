import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/http_exception.dart';

class CategoryProviders with ChangeNotifier{
  final String id;
  final String title;
  final Color color;
  final String categoryImageLocation;
  bool isFavorite;
  CategoryProviders({
    @required this.id,
    @required this.title,
    this.color = Colors.orange,
    this.isFavorite = false,
    this.categoryImageLocation,
  });

  Future<void> toggleFavouritesStatus(String token,String userId) async {
    print('toggleFavouritesStatus called with userID:$userId');
    print("and categoryId:$id");
    var oldStatus = isFavorite;
    final url = 'https://scrollable-app-582c6.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
      isFavorite = !isFavorite;
    notifyListeners();
    final response = await http.put(url,
        body: json.encode({
          'isFavorite':isFavorite,
        }));
        var r = json.decode(response.body);
        print("\nresponse:$r");
    if (response.statusCode >= 400) {
      isFavorite = oldStatus;
      notifyListeners();
      throw HttpException('Could not toggle Favourites Status.');
    }
  }
}
