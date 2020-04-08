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
  bool _isLoading = false;

  Future<void> _refreshProducts(BuildContext context, String categoryId) async {
    await Provider.of<ContentProviders>(context, listen: false)
        .fetchAndSetContentsByCategoryId(categoryId);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      categoryTitle = routeArgs['title'];
      categoryId = routeArgs['id'];

      Provider.of<ContentProviders>(context,listen: false)
          .fetchAndSetContentsByCategoryId(categoryId)
          .then((_) {
        print('fetching done');
        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {
        print('error==:$error');
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final contentProvidersData = Provider.of<ContentProviders>(context);
    final contents =
        contentProvidersData.getContentOnBasisOfCategory(categoryId);

    print("getContentOnBasisOfCategory was called");
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
      body: _isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => _refreshProducts(context, categoryId),
              child: contents.length == 0
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
            ),
    );
  }
}
