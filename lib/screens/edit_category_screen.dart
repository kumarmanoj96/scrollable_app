import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/category_providers.dart';
import '../providers/categories_providers.dart';

import '../widgets/app_drawer.dart';
class EditCategoryScreen extends StatefulWidget {
  static const routeName = 'edit-category';
  @override
  _EditCategoryScreenState createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final _form = GlobalKey<FormState>();
  String categoryId;
  var _editedCategory = CategoryProviders(
    id: null,
    title: '',
    categoryImageLocation: '',
    isFavorite: false,
  );
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      categoryId = ModalRoute.of(context).settings.arguments as String;
      if (categoryId != null) {
        _editedCategory =
            Provider.of<CategoriesProviders>(context, listen: false)
                .getCategoryByCategoryId(categoryId);
      } else {}
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedCategory.id != null) {
      try {
        // await Provider.of<CategoriesProviders>(context, listen: false)
        //     .updateCategory(_editedCategory, categoryId);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Something went wrong!'),
                  content: Text(error.toString()),
                  actions: <Widget>[
                    FlatButton(
                        child: Text('Okay'),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        })
                  ],
                ));
      }
    } else {
      try {
        await Provider.of<CategoriesProviders>(context, listen: false)
            .addCategory(_editedCategory);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Something went wrong!'),
                  content: Text(error.toString()),
                  actions: <Widget>[
                    FlatButton(
                        child: Text('Okay'),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        })
                  ],
                ));
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Category'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              print('Btn pressed');
              _saveForm();
              print('_saveForm called');
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a title.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedCategory = CategoryProviders(
                            title: value,
                            id: _editedCategory.id,
                            categoryImageLocation:
                                _editedCategory.categoryImageLocation,
                            isFavorite: _editedCategory.isFavorite,
                          );
                        },
                      ),
                    ],
                  )),
            ),
    );
  }
}
