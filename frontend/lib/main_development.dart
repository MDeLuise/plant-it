import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:plant_it/data/service/search/cache/app_cache.dart';
import 'package:plant_it/data/service/search/cache/app_cache_pref.dart';
import 'package:plant_it/data/service/search/species_searcher_facade.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/dependencies.dart';
import 'main.dart';

void main() async {
  Logger.root.level = Level.ALL;

  SharedPreferences pref = await SharedPreferences.getInstance();
  SingleChildWidget cacheProvider = Provider<AppCache>(
    create: (context) => AppCachePref(pref: pref),
  );
  SingleChildWidget searchProvider = Provider(
    create: (context) => SpeciesSearcherFacade(
      localSearcher: context.read(),
      trefleSearcher: context.read(),
      cache: context.read(),
    ),
  );

  runApp(
    MultiProvider(
      providers: [...providersLocal, cacheProvider, searchProvider],
      child: const MainApp(),
    ),
  );
}
