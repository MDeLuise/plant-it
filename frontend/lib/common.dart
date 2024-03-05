import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/app_http_client.dart';
import 'package:plant_it/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> showErrorDialog(
    BuildContext context, String message, String details) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ExpansionTile(
              title: const Text(
                'Details',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                Text(details),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text(AppLocalizations.of(context).ok),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> loginAndSetAppKey(
    BuildContext context, String username, String password) async {
  const String appKeyName = "frontend";
  final http = AppHttpClient();
  final prefs = await SharedPreferences.getInstance();

  if (!context.mounted) return;
  await _login(context, username, password);
  try {
    final response = await http.get(
      Uri.parse('api-key/name/$appKeyName'),
    );
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      http.removeJwt();
      await prefs.setString('key', responseBody["value"]);
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } else if (response.statusCode == 404) {
      final response =
          await http.post(Uri.parse('api-key/'), {"name": appKeyName});
      if (response.statusCode == 200) {
        http.removeJwt();
        await prefs.setString('key', response.body);
        if (!context.mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else {
        if (!context.mounted) return;
        final responseBody = json.decode(response.body);
        final errorMessage = responseBody['message'];
        await showErrorDialog(
            context, AppLocalizations.of(context).error, errorMessage);
      }
    }
  } catch (e) {
    if (!context.mounted) return;
    await showErrorDialog(
        context, AppLocalizations.of(context).noBackend, e.toString());
  }
}

Future<void> _login(
    BuildContext context, String username, String password) async {
  final http = AppHttpClient();
  try {
    final response = await http.post(
      Uri.parse('authentication/login'),
      {
        'username': username,
        'password': password,
      },
    );
    final responseBody = json.decode(response.body);
    if (response.statusCode == 200) {
      http.addJwt(responseBody["jwt"]["value"]);
    } else {
      if (!context.mounted) return;
      final errorMessage = responseBody['message'];
      await showErrorDialog(
          context, AppLocalizations.of(context).badCredentials, errorMessage);
    }
  } catch (e) {
    if (!context.mounted) return;
    await showErrorDialog(
        context, AppLocalizations.of(context).noBackend, e.toString());
  }
}
