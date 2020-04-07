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
    this.contentId,
    this.categoryId,
    this.contentData,
    this.contentTitle,
    this.fullContentURL,
    this.imageURL,
    this.description,
  });
}
