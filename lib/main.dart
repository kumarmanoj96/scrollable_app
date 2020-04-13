import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/levels_screen.dart';
import './screens/scroller_screen.dart';
import './screens/tabs_screen.dart';
import './screens/category_contents_screen.dart';
import './screens/edit_content_screen.dart';
import './screens/auth_screen.dart';
import './screens/edit_category_screen.dart';
import './screens/splash_screen.dart';

import './providers/level_providers.dart';
import './providers/content_providers.dart';
import './providers/categories_providers.dart';
import './providers/auth_providers.dart';
import './providers/category_providers.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProviders(),
        ),
        ChangeNotifierProvider.value(
          value: LevelProviders(),
        ),
        ChangeNotifierProxyProvider<AuthProviders, ContentProviders>(
          builder: (ctx, auth, previousContents) => ContentProviders(
              auth.token,
              auth.userId,
              previousContents == null ? {} : previousContents.contents),
        ),
        ChangeNotifierProvider.value(
          value: CategoryProviders(),
        ),
        ChangeNotifierProxyProvider<AuthProviders, CategoriesProviders>(
          builder: (ctx, auth, previousCategories) => CategoriesProviders(
              auth.token,
              auth.userId,
              previousCategories == null ? [] : previousCategories.categories),
        )
      ],
      child: Consumer<AuthProviders>(
        builder: (ctx, authData, _) => MaterialApp(
          title: 'Learn English',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: authData.isAuth ? TabsScreen() : FutureBuilder(
                  future: authData.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            TabsScreen.routeName: (ctx) => TabsScreen(),
            LevelsScreen.routeName: (ctx) => LevelsScreen(),
            ScrollerScreen.routeName: (ctx) => ScrollerScreen(),
            CategoryContentsScreen.routeName: (ctx) => CategoryContentsScreen(),
            EditContentScreen.routeName: (ctx) => EditContentScreen(),
            EditCategoryScreen.routeName: (ctx) => EditCategoryScreen(),
          },
        ),
      ),
    );
  }
}
