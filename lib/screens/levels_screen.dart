import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/level_providers.dart';
import '../providers/content_providers.dart';
import '../screens/scroller_screen.dart';
import '../models/content.dart';
import '../models/level.dart';

class LevelsScreen extends StatefulWidget {
  static const routeName = '/levels';

  @override
  _LevelsScreenState createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  var _loadedData = false;
  String contentId;
  String categoryId;
  var _isInit = true;
  var _isLoading = false;
  var content;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      if (!_loadedData) {
        final routeArgs =
            ModalRoute.of(context).settings.arguments as Map<String, String>;
        contentId = routeArgs['contentId'];
        categoryId = routeArgs['categoryId'];
        _loadedData = true;
      }

      Provider.of<ContentProviders>(context)
          .getWholeContent(contentId, categoryId)
          .then((c) {
        content = c;
        print('fetching done');
        print(c.contentData);
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

  String imageAsset(String levelId) {
    switch (levelId) {
      case 'level1':
        {
          return 'assets/images/level1.png';
        }
        break;
      case 'level2':
        {
          return 'assets/images/level2.png';
        }
        break;
      case 'level3':
        {
          return 'assets/images/level3.png';
        }
        break;
      case 'level4':
        {
          return 'assets/images/level4.png';
        }
        break;
      case 'level5':
        {
          return 'assets/images/level5.png';
        }
    }
  }

  Widget getLevelIcon(String levelId) {
    switch (levelId) {
      case 'level1':
        {
          return Row(
            children: <Widget>[
              Icon(Icons.filter_1),
            ],
          );
        }
      case 'level2':
        {
          return Row(
            children: <Widget>[
              Icon(Icons.filter_2),
            ],
          );
        }
      case 'level3':
        {
          return Row(
            children: <Widget>[
              Icon(Icons.filter_3),
            ],
          );
        }
      case 'level4':
        {
          return Row(
            children: <Widget>[
              Icon(Icons.filter_4),
            ],
          );
        }
      case 'level5':
        {
          return Row(
            children: <Widget>[
              Icon(Icons.filter_5),
            ],
          );
        }
    }
  }

  Widget getLevelBox(Level level, Content content) {
    return InkWell(
      onTap: () {
        print('getLevelBox');
        print(level.levelName);
        Navigator.of(context).pushNamed(ScrollerScreen.routeName, arguments: {
          'levelId': level.id,
          'contentData': content.contentData.length >= 200
              ? content.contentData
              : content.description,
        });
      },
      splashColor: Colors.black,
      borderRadius: BorderRadius.circular(15),
      child:  Container(
          decoration: BoxDecoration(
              color: level.levelColor, borderRadius: BorderRadius.circular(15)),
          alignment: Alignment.center,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          child:Text(level.levelName)
          
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
    final levelData = Provider.of<LevelProviders>(context);
    final levels = levelData.levels;

    // final contentProvidersData = Provider.of<ContentProviders>(context);
    // final content = contentProvidersData.getContent(contentId, categoryId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Improve reading skill'),
      ),
      body: _isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : content == null
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
