import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/homepage.dart';

const int screenSizeTreshold = 600;

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

void showSnackbar(
    BuildContext context, ContentType contentType, String message) {
  String title = "Oh Snap!";
  if (contentType == ContentType.help) {
    title = "Hi there!";
  } else if (contentType == ContentType.warning) {
    title = "Warning!";
  } else if (contentType == ContentType.success) {
    title = "Well done!";
  }

  final snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      contentType: contentType,
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
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
      env.http.removeJwt();
      env.http.addAuthorizationHeader(key);
      await env.prefs.setString('serverKey', key);
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(env: env),
        ),
      );
    } else if (response.statusCode == 404) {
      final response = await env.http.post('api-key/', {"name": appKeyName});
      if (response.statusCode == 200) {
        env.http.removeJwt();
        env.http.addAuthorizationHeader(response.body);
        await env.prefs.setString('serverKey', response.body);
        if (!context.mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(env: env),
          ),
        );
      } else {
        if (!context.mounted) return;
        final responseBody = json.decode(response.body);
        final errorMessage = responseBody['message'];
        showSnackbar(context, ContentType.failure, errorMessage);
      }
    }
  } catch (e) {
    if (!context.mounted) return;
    showSnackbar(
        context, ContentType.failure, AppLocalizations.of(context).noBackend);
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
      env.http.addJwt(responseBody["jwt"]["value"]);
    } else {
      if (!context.mounted) return;
      final errorMessage = responseBody['message'];
      showSnackbar(context, ContentType.failure, errorMessage);
    }
  } catch (e) {
    if (!context.mounted) return;
    showSnackbar(
        context, ContentType.failure, AppLocalizations.of(context).noBackend);
  }
}
