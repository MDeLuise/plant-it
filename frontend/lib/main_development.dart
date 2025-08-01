import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:plant_it/database/database.dart';
import 'package:provider/provider.dart';

import 'config/dependencies.dart';
import 'main.dart';

void main() {
  Logger.root.level = Level.ALL;

  runApp(
    MultiProvider(
      providers: providersLocal,
      child: Builder(
        builder: (context) {
          final db = context.read<AppDatabase>();
          db.initDummyData();
          return MainApp();
        },
      ),
    ),
  );
}
