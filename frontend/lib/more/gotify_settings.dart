import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/environment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/toast/toast_manager.dart';

class GotifySettingsPage extends StatefulWidget {
  final Environment env;
  const GotifySettingsPage({
    super.key,
    required this.env,
  });

  @override
  State<StatefulWidget> createState() => _GotifySettingsPageState();
}

class _GotifySettingsPageState extends State<GotifySettingsPage> {
  bool _showToken = false;
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();

  void _loadGotifySettings() async {
    try {
      final response =
          await widget.env.http.get('notification-dispatcher/config/gotify');
      if (response.statusCode != 200) {
        final String responseErr = json.decode(response.body)["message"];
        widget.env.logger
            .error("Error while retrieving gotify settings: $responseErr");
        if (!mounted) return;
        throw AppException(AppLocalizations.of(context).generalError);
      }
      if (!mounted) return;
      final responseBody = json.decode(response.body);
      _urlController.text = responseBody["url"] ?? "";
      _tokenController.text = responseBody["token"] ?? "";
    } catch (e, st) {
      if (!mounted) return;
      widget.env.logger.error(e, st);
      widget.env.toastManager.showToast(context, ToastNotificationType.error,
          AppLocalizations.of(context).noBackend);
    }
  }

  void _updateGotifySettings() async {
    try {
      final response =
          await widget.env.http.post('notification-dispatcher/config/gotify', {
        "url": _urlController.text,
        "token": _tokenController.text,
      });
      if (response.statusCode != 200) {
        final String responseErr = json.decode(response.body)["message"];
        widget.env.logger
            .error("Error while updating gotify settings: $responseErr");
        if (!mounted) return;
        throw AppException(AppLocalizations.of(context).generalError);
      }
      if (!mounted) return;
      widget.env.logger.info("gotify settings correctly updated");
      widget.env.toastManager.showToast(context, ToastNotificationType.success,
          AppLocalizations.of(context).gotifySettingsUpdated);
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
    _loadGotifySettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).gotifySettings),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateGotifySettings,
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
                          AppLocalizations.of(context).gotifyServerUrl,
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
                            AppLocalizations.of(context).gotifyServerToken,
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
