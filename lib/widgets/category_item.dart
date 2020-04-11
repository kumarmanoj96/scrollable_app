import 'package:flutter/material.dart';

import '../screens/category_contents_screen.dart';


class CategoryItem extends StatelessWidget {
  final String id;
  final String title;
  final Color color;
  final bool isFavourite;
  final String categoryImageLocation;
  const CategoryItem({this.id, this.title, this.color, this.isFavourite,this.categoryImageLocation});
  void selectCategory(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(CategoryContentsScreen.routeName,
        arguments: {'id': id, 'title': title});
  }

  @override
  Widget build(BuildContext context) {
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
                categoryImageLocation!=null&&categoryImageLocation!=''?categoryImageLocation:'assets/images/no_image_available.png',
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
                  // categoriesProvidersData.toggleFavouriteStatus(id);
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
