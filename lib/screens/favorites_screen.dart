import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/category_item.dart';
import '../providers/categories_providers.dart';
import '../providers/category_providers.dart';
class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<CategoriesProviders>(context, listen: false)
          .fetchAndSetCategories(),
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
            return Consumer<CategoriesProviders>(
              builder: (ctx, categoryData, child) =>
                  categoryData.favoriteCategories.length == 0
                      ? Center(
                          child: Text('oops no fav Category is availabe,try adding some!'),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(10),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  childAspectRatio: 3 / 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                            value: categoryData.favoriteCategories[i],
                            child: CategoryItem(),
                          ),
                          itemCount: categoryData.favoriteCategories.length,
                        ),
            );
          }
        }
      },
    );
  }
}
