import 'package:flutter/material.dart';

import '../screens/category_contents_screen.dart';
import 'package:provider/provider.dart';

import '../providers/categories_providers.dart';
import '../providers/category_providers.dart';
import '../providers/auth_providers.dart';

class CategoryItem extends StatelessWidget {
  // final String categoryId;
  // const CategoryItem({this.categoryId});
  // void selectCategory(BuildContext ctx, CategoryProviders category) {
  //   Navigator.of(ctx).pushNamed(CategoryContentsScreen.routeName,
  //       arguments: {'id': category.id, 'title': category.title});
  // }

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    final authData = Provider.of<AuthProviders>(context, listen: false);
    final category = Provider.of<CategoryProviders>(context);
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
            onTap: () => Navigator.of(context).pushNamed(
                CategoryContentsScreen.routeName,
                arguments: {'id': category.id, 'title': category.title}),
            splashColor: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                category.categoryImageLocation != null &&
                        category.categoryImageLocation != ''
                    ? category.categoryImageLocation
                    : 'assets/images/no_image_available.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          footer: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GridTileBar(
              leading: Consumer<CategoryProviders>(
                builder: (ctx, categoryData, child) => IconButton(
                  icon: Icon(
                    categoryData.isFavorite == true
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                  color: Theme.of(context).accentColor,
                  onPressed: () async {
                    print("*******inside onpressed:${categoryData.id}");
                    print("*******inside onpressed:${categoryData.title}");
                    try {
                      await categoryData.toggleFavouritesStatus(
                          authData.token, authData.userId);
                    } catch (error) {
                      print(error);
                      scaffold.showSnackBar(
                        SnackBar(
                          content: Text('Unable to perform action!',
                              textAlign: TextAlign.center),
                        ),
                      );
                    }
                  },
                ),
              ),
              backgroundColor: Colors.black87,
              title: Text(
                category.title,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
