import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/http_exception.dart';

class CategoryProviders with ChangeNotifier{
  final String id;
  final String title;
  final Color color;
  final String categoryImageLocation;
  bool isFavourite;
  CategoryProviders({
    @required this.id,
    @required this.title,
    this.color = Colors.orange,
    this.isFavourite = false,
    this.categoryImageLocation,
  });

  Future<void> toggleFavouritesStatus(String token,String userId) async {
    print('toggleFavouritesStatus called with userID:$userId');
    var oldStatus = isFavourite;
    final url = 'https://flutter-update-29928.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
      isFavourite = !isFavourite;
    notifyListeners();
    final response = await http.put(url,
        body: json.encode({
          'isFavourite':isFavourite,
        }));
        var r = json.decode(response.body);
        print("\nresponse:$r");
    if (response.statusCode >= 400) {
      isFavourite = oldStatus;
      notifyListeners();
      throw HttpException('Could not toggle Favourites Status.');
    }
  }
}
