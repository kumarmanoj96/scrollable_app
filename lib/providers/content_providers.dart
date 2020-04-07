import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/http_exception.dart';
import '../models/content.dart';

class ContentProviders with ChangeNotifier {
  final Map<String, List<Content>> _contents = {};

// List<Content> _contents;

  List<Content> get getAllTypeOfContent {
    List<Content> contents = [];
    _contents.forEach((categoryId, contentList) {
      contentList.forEach((content) {
        contents.add(content);
      });
    });
    return contents;
  }

  List<Content> getContentOnBasisOfCategory(String categoryId) {
    print('inside getContentOnBasisOfCategory');
    if (_contents.containsKey(categoryId)) {
      return _contents[categoryId];
    }
    return [];
  }

  Content getContentByContentIdAndCategoryId(
      String contentId, String categoryId) {
    if (_contents.containsKey(categoryId)) {
      return _contents[categoryId]
          .firstWhere((content) => content.contentId == contentId);
    }
    return null;
  }

  Future<void> addContent(Content content, String categoryId) async {
    // CategoriesProviders c = new CategoriesProviders();
    // List<Category> categories = c.categories;
    if (!_contents.containsKey(categoryId)) {
      _contents[categoryId] = [];
    }
    final url =
        'https://scrollable-app.firebaseio.com/${categoryId}/contents.json';
    try {
      final response = await http.post(url,
          body: json.encode({
            'contentTitle': content.contentTitle,
            'categoryId': categoryId,
            'imageURL': content.imageURL,
            'contentData': content.contentData,
            'description': content.description,
          }));
      final newContent = Content(
        contentTitle: content.contentTitle,
        categoryId: categoryId,
        imageURL: content.imageURL,
        contentData: content.contentData,
        description: content.description,
        contentId: json.decode(response.body)['name'],
      );
      _contents[content.categoryId].add(newContent);
      notifyListeners();
    } catch (error) {
      print("the error is:");
      print(error);
      throw (error);
    }
  }

  Future<void> fetchAndSetContentsByCategoryId(String categoryId) async {
    print('inside fetchAndSetContentsByCategoryId:\n');
    var url =
        'https://scrollable-app.firebaseio.com/${categoryId}/contents.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      print(extractedData);
      final List<Content> loadedContents = [];
      extractedData.forEach((key, value) {
        loadedContents.add(Content(
          contentId: key,
          categoryId: value["categoryId"],
          contentData: value["contentData"],
          contentTitle: value["contentTitle"],
          imageURL: value['imageURL'],
        ));
        _contents[categoryId] = loadedContents;
      });
      notifyListeners();
    } catch (error) {
      print('error occured:');
      print(error);
      throw (error);
    }
    print('Done');
  }

  Future<void> deleteContent(String contentId, String categoryId) async {
    print("inside delete content=====");
    print("contentId:");print(contentId);
    print("categoryId");print(categoryId);
    final url =
        'https://scrollable-app.firebaseio.com/${categoryId}/contents/$contentId.json';
    Content existingContent =
        getContentByContentIdAndCategoryId(contentId, categoryId);
print("existingContent:");print(existingContent);
    _contents[categoryId]
        .removeWhere((content) => content.contentId == contentId);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _contents[categoryId].add(existingContent);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingContent = null;
  }

  // @todo
  // Future<void> updateContent(String id, Content updatedContent) async {
  //   final prodIndex = _items.indexWhere((prod) => prod.id == id);
  //   if (prodIndex >= 0) {
  //     final url =
  //         'https://scrollable-app.firebaseio.com/${categoryId}/contents/$contentId.json';
  //     await http.patch(url,
  //         body: json.encode({
  //           'title': newProduct.title,
  //           'imageUrl': newProduct.imageUrl,
  //           'description': newProduct.description,
  //           'price': newProduct.price,
  //         }));
  //     _items[prodIndex] = newProduct;
  //     notifyListeners();
  //   } else {
  //     print('...');
  //   }
  // }
}
