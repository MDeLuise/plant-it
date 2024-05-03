import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:material_loading_buttons/material_loading_buttons.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/environment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/info_entries.dart';
import 'package:plant_it/toast/toast_manager.dart';

class EditProfilePage extends StatefulWidget {
  final Environment env;

  const EditProfilePage({
    super.key,
    required this.env,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late String _username;
  late String _email;
  String _currentPassword = "";
  bool _showPassword = true;

  @override
  void initState() {
    super.initState();
    _username = widget.env.credentials.username;
    _email = widget.env.credentials.email;
  }

  bool _isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
    );
    return emailRegex.hasMatch(email);
  }

  void _updateUser() async {
    bool changed = false;
    if (widget.env.credentials.email != _email) {
      if (!_isValidEmail(_email)) {
        widget.env.logger.error("Enter valid email");
        throw AppException("Enter valid email");
      }
      final response = await widget.env.http.put(
          "user/_email", {"password": _currentPassword, "newEmail": _email});
      final responseBody = json.decode(response.body);
      if (!mounted) return;
      if (response.statusCode != 200) {
        widget.env.logger.error(responseBody["message"]);
        throw AppException(responseBody["message"]);
      }
      widget.env.credentials.email = _email;
      widget.env.prefs.setString("email", _email);
      changed = true;
    }
    if (widget.env.credentials.username != _username) {
      final response = await widget.env.http.put("user/_username",
          {"password": _currentPassword, "newUsername": _username});
      if (response.statusCode != 200) {
        if (!mounted) return;
        final responseBody = json.decode(response.body);
        widget.env.logger.error(responseBody["message"]);
        throw AppException(responseBody["message"]);
      }
      widget.env.credentials.username = _username;
      widget.env.prefs.setString("username", _username);
      changed = true;
    }
    if (!mounted) return;
    if (!changed) {
      widget.env.toastManager.showToast(context, ToastNotificationType.warning,
          AppLocalizations.of(context).noChangesDetected);
      return;
    }
    widget.env.logger.info("User correctly updated");
    widget.env.toastManager.showToast(context, ToastNotificationType.success,
        AppLocalizations.of(context).userUpdated);
    Navigator.pop(context, changed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).updateProfile),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AdvancedAvatar(
                      name: _username,
                      size: 70,
                      style:
                          const TextStyle(color: Color.fromARGB(255, 156, 192, 172)),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(53, 98, 82, 1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    EditableSimpleInfoEntry(
                      title: AppLocalizations.of(context).username,
                      value: _username,
                      onChanged: (u) => _username = u,
                      onlyNumber: false,
                    ),
                    EditableSimpleInfoEntry(
                      title: AppLocalizations.of(context).email,
                      value: _email,
                      onChanged: (e) => _email = e,
                      onlyNumber: false,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              AppLocalizations.of(context).currentPassword,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextFormField(
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
                            onChanged: (p) => _currentPassword = p,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedLoadingButton(
                      isLoading: _isLoading,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            if (_formKey.currentState!.validate()) {
                              _updateUser();
                            }
                          } finally {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                      },
                      child: Text(AppLocalizations.of(context).updateProfile),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
