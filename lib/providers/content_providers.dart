import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/http_exception.dart';
import '../models/content.dart';

class ContentProviders with ChangeNotifier {
  final Map<String, List<Content>> _contents = {};

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
    if (_contents.containsKey(categoryId)) {
      return _contents[categoryId];
    }
    return <Content>[];
  }

  Content getContentByContentIdAndCategoryId(
      String contentId, String categoryId) {
    if (_contents.containsKey(categoryId)) {
      if (_contents[categoryId].length == 0) return null;
      return _contents[categoryId]
          .firstWhere((content) => content.contentId == contentId);
    }
    return null;
  }

  Future<void> addContent(Content content, String categoryId) async {
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
      throw HttpException('Could not Add Content.');
    }
  }

  Future<void> fetchAndSetContentsByCategoryId(String categoryId) async {
    var url =
        'https://scrollable-app.firebaseio.com/${categoryId}/contents.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        _contents[categoryId] = <Content>[];
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
      throw HttpException('Could not load contents.');
    }
    print('Done');
  }

  Future<void> deleteContent(String contentId, String categoryId) async {
    final url =
        'https://scrollable-app.firebaseio.com/${categoryId}/contents/$contentId.json';
    Content existingContent =
        getContentByContentIdAndCategoryId(contentId, categoryId);
    _contents[categoryId]
        .removeWhere((content) => content.contentId == contentId);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _contents[categoryId].add(existingContent);
      notifyListeners();
      throw HttpException('Could not delete Content.');
    }
    existingContent = null;
  }

  Future<void> updateContent(Content content, String categoryId) async {
    final url =
        'https://scrollable-app.firebaseio.com/${categoryId}/contents/${content.contentId}.json';
    try {
      final response = await http.patch(url,
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
      _contents[categoryId]
          .removeWhere((c) => c.contentId == content.contentId);
      _contents[content.categoryId].add(newContent);
      notifyListeners();
    } catch (error) {
      throw HttpException('Could not Update Content.');
    }
  }
}
