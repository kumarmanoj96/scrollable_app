import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/category_item.dart';
import '../providers/categories_providers.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final categoriesProvidersData = Provider.of<CategoriesProviders>(context);
    // final categories = categoriesProvidersData.categories;

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
                  categoryData.categories.length == 0
                      ? Center(
                          child: Text('oops no Category is availabe'),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(10),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  childAspectRatio: 3 / 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemBuilder: (ctx, index) => CategoryItem(
                            title: categoryData.categories[index].title,
                            color: categoryData.categories[index].color,
                            id: categoryData.categories[index].id,
                            isFavourite:
                                categoryData.categories[index].isFavourite,
                            categoryImageLocation: categoryData
                                .categories[index].categoryImageLocation,
                          ),
                          itemCount: categoryData.categories.length,
                        ),
            );
          }
        }
      },
    );
  }
}
