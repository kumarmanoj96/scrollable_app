import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/content_providers.dart';

import '../screens/content_screen.dart';
import '../screens/edit_content_screen.dart';

class CategoryContentsScreen extends StatefulWidget {
  static const routeName = '/category-contents';

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
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditContentScreen.routeName,
                    arguments: {'contentId': '', 'categoryId': categoryId});
              }),
        ],
      ),
      body: contents.length == 0
          ? Center(
              child: Text('oops no content is availabe'),
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                print(contents[index].contentId);
                return ContentScreen(
                  categoryId: categoryId,
                  contentId: contents[index].contentId,
                );
              },
              itemCount: contents.length,
            ),
    );
  }
}
