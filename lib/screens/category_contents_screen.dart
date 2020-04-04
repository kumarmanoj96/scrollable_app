import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/content_providers.dart';
import '../models/meal.dart';

import '../screens/content_screen.dart';

class CategoryContentsScreen extends StatefulWidget {
  static const routeName = '/category-meals';

  @override
  _CategoryContentsScreenState createState() => _CategoryContentsScreenState();
}

class _CategoryContentsScreenState extends State<CategoryContentsScreen> {
  String categoryTitle;
  String categoryId;
  var _loadedData = false;
  @override
  void didChangeDependencies() {
    if (!_loadedData) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      categoryTitle = routeArgs['title'];
      categoryId = routeArgs['id'];
      _loadedData = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final contentProvidersData = Provider.of<ContentProviders>(context);
    final contents =
        contentProvidersData.getContentOnBasisOfCategory(categoryId);
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: contents.length == 0
          ? Center(
              child: Text('oops no content is availabe'),
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                print(contents[index].contentId);
                return ContentScreen(categoryId: categoryId,contentId: contents[index].contentId,);
              },
              itemCount: contents.length,
            ),
    );
  }
}
