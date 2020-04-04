import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import './screens/levels_screen.dart';
import './screens/scroller_screen.dart';
import './screens/tabs_screen.dart';
import './screens/category_contents_screen.dart';

import './providers/level_providers.dart';
import './providers/content_providers.dart';
import './providers/categories_providers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: LevelProviders(),
        ),
        ChangeNotifierProvider.value(
          value: ContentProviders(),
        ),
        ChangeNotifierProvider.value(
          value: CategoriesProviders(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TabsScreen(),
        routes: {
          LevelsScreen.routeName: (ctx) => LevelsScreen(),
          ScrollerScreen.routeName: (ctx) => ScrollerScreen(),
          CategoryContentsScreen.routeName: (ctx) => CategoryContentsScreen(),
        },
      ),
    );
  }
}
