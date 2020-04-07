import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/level_providers.dart';
import '../providers/content_providers.dart';
import '../screens/scroller_screen.dart';
import '../screens/edit_content_screen.dart';
import '../models/content.dart';
import '../models/level.dart';
import '../models/http_exception.dart';

class LevelsScreen extends StatefulWidget {
  static const routeName = '/levels';

  @override
  _LevelsScreenState createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  Widget getLevelBox(Level level, Content content) {
    return InkWell(
      onTap: () {
        print('getLevelBox');
        print(level.levelName);
        Navigator.of(context).pushNamed(ScrollerScreen.routeName, arguments: {
          'levelId': level.id,
          'contentData': content.contentData,
        });
      },
      splashColor: Colors.black,
      borderRadius: BorderRadius.circular(15),
      child: Container(
          decoration: BoxDecoration(
              color: level.levelColor, borderRadius: BorderRadius.circular(15)),
          alignment: Alignment.center,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          child: Text(level.levelName)

          //  Column(
          //   children: <Widget>[
          //     ListTile(
          //       // leading: FittedBox(child: getLevelIcon(level.id)),
          //       title: Text(level.levelName),
          //       subtitle: FittedBox(
          //         // fit: BoxFit.cover,
          //         // child: Text(
          //         //   'speed: ${level.speedFactor.toString()} word per minute',
          //         //   // textAlign: TextAlign.end,
          //         // ),
          //       ),
          //       // trailing: getLevelIcon(level.id),
          //     ),
          //   ],
          // ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final scaffold = Scaffold.of(context);
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
        final categoryId = routeArgs['categoryId'];
        final contentId =  routeArgs['contentId'];
    final content = Provider.of<ContentProviders>(context)
        .getContentByContentIdAndCategoryId(
      contentId,
      categoryId,
    );
    final levelData = Provider.of<LevelProviders>(context);
    final levels = levelData.levels;
    return Scaffold(
      appBar: AppBar(
        title: Text('Improve reading skill'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                print('edit btn pressed:');
                print(contentId);
                 Navigator.of(context).pushNamed(EditContentScreen.routeName,
                    arguments: {'contentId': contentId, 'categoryId': categoryId});
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  print('delete btn pressed:');
                  await Provider.of<ContentProviders>(context, listen: false)
                      .deleteContent(contentId,categoryId);
                      Navigator.of(context).pop();
                } catch (error) {
                  // scaffold.showSnackBar(
                  //   SnackBar(
                  //     content:
                  //         Text('Deleting Failed!', textAlign: TextAlign.center),
                  //   ),
                  // );
                }
              },
              color: Theme.of(context).errorColor,
            )
        ],
      ),
      body: content == null
          ? Center(child: Text('Unable to show the news'))
          : Card(
              child: ListView(
              children: <Widget>[
                ...levels.map((level) => getLevelBox(level, content)),
              ],
              itemExtent: 100,
            )),
    );
  }
}
