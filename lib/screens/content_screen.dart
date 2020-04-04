import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/content_providers.dart';
import '../screens/levels_screen.dart';

class ContentScreen extends StatelessWidget {
  final String contentId;
  final String categoryId;
  ContentScreen({this.categoryId, this.contentId});
  @override
  Widget build(BuildContext context) {
    final contentProvidersData = Provider.of<ContentProviders>(context);
    final content = contentProvidersData.getContent(contentId, categoryId);

    return content == null
        ? Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            alignment: Alignment.center,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            color: Colors.red,
            child: ListTile(
              leading: Icon(Icons.note),
              title: Text('Unable to load'),
            ),
          )
        : InkWell(
            onTap: () {
              print('Hello');
              Navigator.of(context)
                  .pushNamed(LevelsScreen.routeName, arguments: {
                'contentId': contentId,
                'categoryId': categoryId,
              });
            },
            splashColor: Colors.black,
            borderRadius: BorderRadius.circular(15),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 10,
              child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Container(
                          height: 300,
                          width: double.infinity,
                          child: content.imageURL != null
                              ? Image.network(
                                  (content.imageURL),
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/images/no_image_available.png',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      // FittedBox(
                      //   child: Image.network(
                      //     (content.imageURL),
                      //     fit: BoxFit.cover,
                      //   ),
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text(content.contentTitle),
                      )
                    ],
                  )

                  // ListTile(
                  //   // leading: Icon(Icons.note),
                  //   leading: Image.network(
                  //     (content.imageURL),
                  //     fit: BoxFit.cover,
                  //   ),
                  //   title: Text(content.contentTitle),
                  // ),
                  ),
            ),
          );
  }
}
