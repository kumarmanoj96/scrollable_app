import 'package:flutter/material.dart';
import '../models/level.dart';

const LEVELS = const [
  Level(
    id: 'level1',
    levelName: 'Level 1',
    speedFactor: 50,
    levelColor: Colors.green,
  ),
  Level(
    id: 'level2',
    levelName: 'Level 2',
    speedFactor: 60,
    levelColor: Colors.yellow,
  ),
  Level(
    id: 'level3',
    levelName: 'Level 3',
    speedFactor: 70,
    levelColor: Colors.orange,
  ),
  Level(
    id: 'level4',
    levelName: 'Level 4',
    speedFactor: 80,
    levelColor: Colors.redAccent,
  ),
  Level(
    id: 'level5',
    levelName: 'Level 5',
    speedFactor: 500,
    levelColor: Colors.red,
  ),
];
