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
  bool _isInit = true;

  Future<void> _refreshProducts(BuildContext context, String categoryId) async {
    await Provider.of<ContentProviders>(context, listen: false)
        .fetchAndSetContentsByCategoryId(categoryId);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      categoryTitle = routeArgs['title'];
      categoryId = routeArgs['id'];
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context, categoryId),
        child: FutureBuilder(
          future: Provider.of<ContentProviders>(context, listen: false)
              .fetchAndSetContentsByCategoryId(categoryId),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error != null) {
                return Center(
                  child: Text('An error occured'),
                );
              } else {
                return Consumer<ContentProviders>(
                  builder: (ctx, contentData, child) => contentData
                              .getContentOnBasisOfCategory(categoryId)
                              .length ==
                          0
                      ? Center(
                          child: Text('oops no content is availabe'),
                        )
                      : ListView.builder(
                          itemBuilder: (ctx, index) {
                            return ContentScreen(
                              categoryId: categoryId,
                              contentId: contentData
                                  .getContentOnBasisOfCategory(
                                      categoryId)[index]
                                  .contentId,
                            );
                          },
                          itemCount: contentData
                              .getContentOnBasisOfCategory(categoryId)
                              .length,
                        ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
