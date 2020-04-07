import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/content.dart';
import '../providers/content_providers.dart';

class EditContentScreen extends StatefulWidget {
  static const routeName = 'edit-content';
  @override
  _EditContentScreenState createState() => _EditContentScreenState();
}

class _EditContentScreenState extends State<EditContentScreen> {
  final _descriptionFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  String contentId, categoryId;
  var _editedContent = Content(
    contentId: null,
    categoryId: '',
    contentTitle: '',
    contentData: '',
    imageURL: '',
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
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, Object>;
      contentId = routeArgs['contentId'];
      categoryId = routeArgs['categoryId'];
      if (contentId != null && contentId != '') {
        _editedContent = Provider.of<ContentProviders>(context, listen: false)
            .getContent(categoryId, contentId);
      } else {}
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    super.dispose();
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
    if (_editedContent.contentId != null && _editedContent.contentId != '') {
      // await Provider.of<ContentProviders>(context, listen: false)
      //     .updateContent(_editedContent.contentId, _editedContent);
    } else {
      try {
        await Provider.of<ContentProviders>(context, listen: false)
            .addContent(_editedContent,categoryId);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error occured!'),
                  content: Text('Something went wrong!'),
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
        title: Text('Edit Product'),
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
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a title.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedContent = Content(
                            contentTitle: value,
                            contentId: _editedContent.contentId,
                            categoryId: categoryId,
                            contentData: _editedContent.contentData,
                            description: _editedContent.description,
                            imageURL: _editedContent.imageURL,
                          );
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'contentData',
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a contentData';
                          }
                          if (value.length < 5) {
                            return 'Should be at least 5 charactors long.';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        onSaved: (value) {
                          _editedContent = Content(
                            contentTitle: _editedContent.contentTitle,
                            contentId: _editedContent.contentId,
                            categoryId: categoryId,
                            contentData: value,
                            description: _editedContent.description,
                            imageURL: _editedContent.imageURL,
                          );
                        },
                      ),
                    ],
                  )),
            ),
    );
  }
}
