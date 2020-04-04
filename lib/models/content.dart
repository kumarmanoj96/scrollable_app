import 'package:flutter/material.dart';

class Content {
  final String contentId;
  final String categoryId;
  final String contentTitle;
  final String contentData;
  final String fullContentURL;
  final String imageURL;
  final String description;

  const Content({
    @required this.contentId,
    @required this.categoryId,
    @required this.contentData,
    @required this.contentTitle,
    @required this.fullContentURL,
    @required this.imageURL,
    @required this.description,
  });
}
