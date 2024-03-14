import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:plant_it/dto/plant_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/splash_screen.dart';

Future<void> fetchAndSetEventTypes(
    BuildContext context, Environment env) async {
  try {
    final response = await env.http.get("diary/entry/type");
    if (response.statusCode == 200) {
      final List<dynamic> responseBody = json.decode(response.body);
      final List<String> eventTypes = List<String>.from(responseBody);
      env.eventTypes = eventTypes;
    }
  } catch (e) {
    if (!context.mounted) return;
    showSnackbar(context, SnackBarType.fail, e.toString());
  }
}

Future<void> fetchAndSetPlants(BuildContext context, Environment env) async {
  try {
    final response = await env.http.get("plant");
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final List<dynamic> plantJsonList = responseBody["content"];
      env.plants =
          plantJsonList.map((json) => PlantDTO.fromJson(json)).toList();
    }
  } catch (e) {
    if (!context.mounted) return;
    showSnackbar(context, SnackBarType.fail, e.toString());
  }
}

const int screenSizeTreshold = 600;

bool isSmallScreen(BuildContext context) {
  final double width = MediaQuery.of(context).size.width;
  return width < screenSizeTreshold;
}

class SignupRequest {
  final String username;
  final String password;
  final String email;

  SignupRequest({
    required this.username,
    required this.password,
    required this.email,
  });

  Map<String, String> toMap() {
    return {
      'username': username,
      'password': password,
      'email': email,
    };
  }
}

String formatEventType(String eventType) {
  return eventType.toLowerCase().replaceAll("_", " ");
}

String encodeEventType(String formattedEventType) {
  return formattedEventType.toUpperCase().replaceAll(" ", "_");
}

void showSnackbar(BuildContext context, SnackBarType type, String message) {
  IconSnackBar.show(context,
      snackBarType: type,
      label: message,
      snackBarStyle: const SnackBarStyle(maxLines: 4),
      duration: const Duration(seconds: 3));
}

Future<void> loginAndSetAppKey(Environment env, BuildContext context,
    String username, String password) async {
  const String appKeyName = "frontend";

  if (!context.mounted) return;
  await _login(env, context, username, password);
  try {
    final response = await env.http.get(
      'api-key/name/$appKeyName',
    );
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final String key = responseBody["value"];
      env.http.jwt = null;
      env.http.key = key;
      await env.prefs.setString('serverKey', key);
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SplashPage(env: env),
        ),
      );
    } else if (response.statusCode == 404) {
      final response = await env.http.post('api-key/', {"name": appKeyName});
      if (response.statusCode == 200) {
        env.http.jwt = null;
        env.http.key = response.body;
        await env.prefs.setString('serverKey', response.body);
        if (!context.mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SplashPage(env: env),
          ),
        );
      } else {
        if (!context.mounted) return;
        final responseBody = json.decode(response.body);
        final errorMessage = responseBody['message'];
        showSnackbar(context, SnackBarType.fail, errorMessage);
      }
    }
  } catch (e) {
    if (!context.mounted) return;
    showSnackbar(
        context, SnackBarType.fail, AppLocalizations.of(context).noBackend);
    rethrow;
  }
}

Future<void> _login(Environment env, BuildContext context, String username,
    String password) async {
  try {
    final response = await env.http.post(
      'authentication/login',
      {
        'username': username,
        'password': password,
      },
    );
    final responseBody = json.decode(response.body);
    if (response.statusCode == 200) {
      env.http.jwt = responseBody["jwt"]["value"];
    } else {
      if (!context.mounted) return;
      final errorMessage = responseBody['message'];
      showSnackbar(context, SnackBarType.fail, errorMessage);
    }
  } catch (e) {
    if (!context.mounted) return;
    showSnackbar(
        context, SnackBarType.fail, AppLocalizations.of(context).noBackend);
    rethrow;
  }
}
