import 'package:flutter/material.dart';
import '../models/level.dart';
import '../widgets/level_data.dart';

class LevelProviders with ChangeNotifier {
  List<Level> get levels {
    return LEVELS.toList();
  }

  Level getLevel(String levelId) {
    return LEVELS.firstWhere((level) => level.id == levelId);
  }
}
