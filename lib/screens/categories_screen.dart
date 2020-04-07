import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/category_item.dart';
import '../providers/categories_providers.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoriesProvidersData = Provider.of<CategoriesProviders>(context);
    final categories = categoriesProvidersData.categories;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (ctx, index) => CategoryItem(
        title: categories[index].title,
        color: categories[index].color,
        id: categories[index].id,
        isFavourite: categories[index].isFavourite,
        categoryImageLocation: categories[index].categoryImageLocation,
      ),
      itemCount: categories.length,
    );
  }
}
