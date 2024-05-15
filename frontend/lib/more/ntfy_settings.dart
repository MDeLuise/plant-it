import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/environment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/toast/toast_manager.dart';

class NtfySettingsPage extends StatefulWidget {
  final Environment env;
  const NtfySettingsPage({
    super.key,
    required this.env,
  });

  @override
  State<StatefulWidget> createState() => _NtfySettingsPageState();
}

class _NtfySettingsPageState extends State<NtfySettingsPage> {
  bool _showPassword = true;
  bool _showToken = true;
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();

  void _loadNtfySettings() async {
    try {
      final response =
          await widget.env.http.get('notification-dispatcher/config/ntfy');
      if (response.statusCode != 200) {
        final String responseErr = json.decode(response.body)["message"];
        widget.env.logger
            .error("Error while retrieving ntfy settings: $responseErr");
        if (!mounted) return;
        throw AppException(AppLocalizations.of(context).generalError);
      }
      if (!mounted) return;
      final responseBody = json.decode(response.body);
      _urlController.text = responseBody["url"] ?? "";
      _topicController.text = responseBody["topic"] ?? "";
      _usernameController.text = responseBody["username"] ?? "";
      _passwordController.text = responseBody["password"] ?? "";
      _tokenController.text = responseBody["token"] ?? "";
    } catch (e, st) {
      if (!mounted) return;
      widget.env.logger.error(e, st);
      widget.env.toastManager.showToast(context, ToastNotificationType.error,
          AppLocalizations.of(context).noBackend);
    }
  }

  void _updateNtfySettings() async {
    try {
      final response =
          await widget.env.http.post('notification-dispatcher/config/ntfy', {
        "url": _urlController.text,
        "topic": _topicController.text,
        "username": _usernameController.text,
        "password": _passwordController.text,
        "token": _tokenController.text,
      });
      if (response.statusCode != 200) {
        final String responseErr = json.decode(response.body)["message"];
        widget.env.logger
            .error("Error while updating ntfy settings: $responseErr");
        if (!mounted) return;
        throw AppException(AppLocalizations.of(context).generalError);
      }
      if (!mounted) return;
      widget.env.logger.info("ntfy settings correctly updated");
      widget.env.toastManager.showToast(context, ToastNotificationType.success,
          AppLocalizations.of(context).ntfySettingsUpdated);
      Navigator.of(context).pop();
    } catch (e, st) {
      if (!mounted) return;
      widget.env.logger.error(e, st);
      widget.env.toastManager.showToast(context, ToastNotificationType.error,
          AppLocalizations.of(context).noBackend);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadNtfySettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).ntfySettings),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateNtfySettings,
        //tooltip: AppLocalizations.of(context).addNewEvent,
        child: const Icon(Icons.save_outlined),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          AppLocalizations.of(context).ntfyServerUrl,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                        controller: _urlController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || !isValidUrl(value)) {
                            return AppLocalizations.of(context).enterValidURL;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          AppLocalizations.of(context).ntfyServerTopic,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                        controller: _topicController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return AppLocalizations.of(context).enterValidTopic;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          AppLocalizations.of(context).ntfyServerUsername,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          AppLocalizations.of(context).ntfyServerPassword,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_showPassword,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_showPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            AppLocalizations.of(context).ntfyServerToken,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextFormField(
                          controller: _tokenController,
                          obscureText: !_showToken,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(_showToken
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _showToken = !_showToken;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
