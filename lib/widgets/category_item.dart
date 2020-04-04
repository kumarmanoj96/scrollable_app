import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/category_contents_screen.dart';

import '../providers/categories_providers.dart';

class CategoryItem extends StatelessWidget {
  final String id;
  final String title;
  final Color color;
  final bool isFavourite;
  const CategoryItem({this.id, this.title, this.color, this.isFavourite});

  String get imageAsset {
    switch (id) {
      case 'c1':
        {
          return 'assets/images/business_news.png';
        }
        break;
      case 'c2':
        {
          return 'assets/images/entertainment_news.png';
        }
        break;
      case 'c3':
        {
          return 'assets/images/health_news.png';
        }
        break;
      case 'c4':
        {
          return 'assets/images/science_news.png';
        }
        break;
      case 'c5':
        {
          return 'assets/images/sports_news.png';
        }
        break;
      case 'c6':
        {
          return 'assets/images/technology_news.png';
        }
        break;
    }
  }

  void selectCategory(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(CategoryContentsScreen.routeName,
        arguments: {'id': id, 'title': title});
  }

  @override
  Widget build(BuildContext context) {
    final categoriesProvidersData = Provider.of<CategoriesProviders>(context);
    return Card(
      borderOnForeground: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 10,
      margin: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: GridTile(
          child: InkWell(
            onTap: () => selectCategory(context),
            splashColor: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imageAsset,
                fit: BoxFit.cover,
              ),
            ),
          ),
          footer: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GridTileBar(
              leading: IconButton(
                icon: Icon(
                  isFavourite == true ? Icons.favorite : Icons.favorite_border,
                ),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  categoriesProvidersData.toggleFavouriteStatus(id);
                },
              ),
              backgroundColor: Colors.black87,
              title: Text(
                title,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
