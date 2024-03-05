import 'package:flutter/material.dart';
import 'package:plant_it/homepage.dart';
import 'package:plant_it/set_server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.containsKey('key');
  runApp(MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isLoggedIn ? const HomePage() : const SetServer()));
}
