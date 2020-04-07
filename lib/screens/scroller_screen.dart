import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../providers/level_providers.dart';

class ScrollerScreen extends StatefulWidget {
  static const routeName = '/scroller-screen';

  @override
  _ScrollerScreenState createState() => _ScrollerScreenState();
}

class _ScrollerScreenState extends State<ScrollerScreen> {
  ScrollController _scrollController;
  bool scroll = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _scroll(int speedFactor) {
    double maxExtent = _scrollController.position.maxScrollExtent;
    double distanceDifference = maxExtent - _scrollController.offset;
    double durationDouble = distanceDifference / speedFactor;
    print("_scrollController.position.maxScrollExtent:");
    print(_scrollController.position.maxScrollExtent);
    print("_scrollController. offset:");
    print(_scrollController.offset);
    _scrollController
        .animateTo(_scrollController.position.maxScrollExtent,
            duration: Duration(
                seconds:
                    durationDouble.toInt() != 0 ? durationDouble.toInt() : 1),
            curve: Curves.linear)
        .then((onValue) {
      print("animation completed:\n");
      // print(onValue);
    });
  }

  _toggleScrolling(int speedFactor) {
    setState(() {
      scroll = !scroll;
    });

    if (scroll) {
      _scroll(speedFactor);
    } else {
      // print("offset:");
      // print(_scrollController.offset);
      _scrollController.animateTo(_scrollController.offset,
          duration: Duration(seconds: 1), curve: Curves.linear);
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    String currentLevelId = routeArgs['levelId'];
    String contentData = routeArgs['contentData'];
    final levelData = Provider.of<LevelProviders>(context);
    final currentLevel = levelData.getLevel(currentLevelId);
    int speedFactor = currentLevel.speedFactor;
    return Scaffold(
      appBar: AppBar(
        title: Text(currentLevel.levelName),
      ),
      body: SafeArea(
        child: NotificationListener(
            onNotification: (notif) {
              if (notif is ScrollEndNotification && scroll) {
                Timer(Duration(seconds: 1), () {
                  _scroll(speedFactor);
                });
              }
              return true;
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              height: 300,
              width: 300,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: _scrollController,
                itemCount: 2,
                itemExtent: 100.0,
                itemBuilder: (context, index) {
                  return   Text(index<=0? contentData:"");
                },
              ),
            )

            //  SingleChildScrollView(
            //   physics: const NeverScrollableScrollPhysics(),
            //   controller: _scrollController,
            //   child: Column(
            //     children: <Widget>[
            //       Container(
            //         width: MediaQuery.of(context).size.width,
            //         margin: EdgeInsets.all(10),
            //         padding: EdgeInsets.all(10),
            //         // child: Text(val),
            //         child: Text(contentData),
            //         // decoration: BoxDecoration(
            //         //   color: Colors.white,
            //         //   border: Border.all(color: Colors.grey),
            //         //   borderRadius: BorderRadius.circular(8),
            //         // ),
            //       ),
            //       SizedBox(height: MediaQuery.of(context).size.height ),
            //     ],
            //   ),
            // ),
            ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(
            scroll ? Icons.pause : Icons.play_arrow,
          ),
          onPressed: () {
            _toggleScrolling(speedFactor);
          }),
    );
  }
}
