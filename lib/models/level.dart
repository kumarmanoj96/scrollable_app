import 'package:flutter/material.dart';

class Level {
  final String id;
  final String levelName;
  final int speedFactor;
  final Color levelColor;

  const Level({
    this.id,
    this.levelName,
    this.speedFactor,
    this.levelColor,
  });
}
