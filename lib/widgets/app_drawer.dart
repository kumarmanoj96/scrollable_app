import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_providers.dart';

import '../screens/tabs_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<AuthProviders>(context,listen: false);
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: FittedBox(child: Text('Hello ${authData.email}')),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('HomeScreen'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Categories'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                TabsScreen.routeName,
              );
            },
          ),
          Divider(),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              authData.logout();
            },
          ),
        ],
      ),
    );
  }
}
