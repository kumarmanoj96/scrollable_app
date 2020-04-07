import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:scrollable_app/models/category.dart';
import 'dart:convert';
import 'package:html/parser.dart';
import './categories_providers.dart';
// import '../models/http_exception.dart';

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

  Future<void> fetchAndSetContents() async {
    print("inside fetchAndSetContents\n\n");
    CategoriesProviders c = new CategoriesProviders();
    for (Category category in c.categories) {
     
      var url =
          'https://scrollable-app.firebaseio.com/${category.id}/contents.json';  try {
        final response = await http.get(url);
        print("response:");
        print(response);
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
             print(extractedData);
        if (extractedData == null) {
          return;
        }
        final List<Content> loadedContents = [];


        extractedData.forEach((key,value) {
            loadedContents.add(Content(
              contentId:key,
              categoryId: value["categoryId"],
              contentData: value["contentData"],
              contentTitle: value["contentTitle"],
              imageURL: value['imageURL'],
            ));
          _contents[category.id] = loadedContents;
        });
        notifyListeners();
      } catch (error) {
        print('error occured\n');
        print(error);
        throw (error);
      }
    }
    print('Done');
  }

  Content getContent(String contentId, String categoryId) {
    if (_contents.containsKey(categoryId)) {
      return _contents[categoryId]
          .firstWhere((content) => content.contentId == contentId);
    }
    return null;
  }

  Future<Content> getWholeContent(String contentId, String categoryId) async {
    print('inside getWholeContent');
    if (_contents.containsKey(categoryId)) {
      Content c = _contents[categoryId]
          .firstWhere((content) => content.contentId == contentId);
      final fullResponse = await http.get(c.fullContentURL);
      // Use html parser
      var document = parse(fullResponse.body);
      var paragraphs = document.body.querySelectorAll("p");
      var wholeContent = "";
      for (var paragraph in paragraphs) {
        if (paragraph.text != null &&
            paragraph.text.length >= 25 &&
            paragraph.text[paragraph.text.length - 1] == '.') {
          wholeContent += paragraph.text;
        }
      }
      print('the whole content is:$wholeContent');
      return new Content(
        contentId: c.contentId,
        categoryId: c.categoryId,
        contentData: wholeContent,
        contentTitle: c.contentTitle,
        fullContentURL: c.fullContentURL,
        imageURL: c.imageURL,
        description: c.description,
      );
    }
    return null;
  }

  Future<void> addContent(Content content,String categoryId) async {
    // CategoriesProviders c = new CategoriesProviders();
    print("addContent called:$content");
    print("title:$content.contentTitle");
     print("contentData:$content.contentData");
     print("categoryId:$content.categoryId");
     print("categoryId:$categoryId*****");

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
        description:content.description,
        contentId: json.decode(response.body)['name'],
      );
      _contents[content.categoryId].add(newContent);
      notifyListeners();
    } catch (error) {
      // print(error);
      throw (error);
    }
  }

  Future<void> fetchAndSetContentsByCategoryId(String categoryId) async {
    print('inside fetchAndSetContentsByCategoryId:\n');
      var url =
          'https://scrollable-app.firebaseio.com/${categoryId}/contents.json';
      try {
        final response = await http.get(url);
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        // if (extractedData == null || extractedData['status'] != 'ok') {
        //   return;
        // }
        print(extractedData);
        final List<Content> loadedContents = [];

        // extractedData['articles'].forEach((article) {
        //   if (article['title'] != null && article['url'] != null) {
        //     loadedContents.add(Content(
        //       contentId: DateTime.now().toString(),
        //       categoryId: category.id,
        //       contentData: "",
        //       contentTitle: article['title'],
        //       fullContentURL: article['url'],
        //       imageURL: article['urlToImage'],
        //       description: article['description'],
        //     ));
        //   }
        //   _contents[category.id] = loadedContents;
        // });
        notifyListeners();
      } catch (error) {
        print('error occured\n');
        print(error);
        throw (error);
      }
    
    print('Done');
  }
}
