import 'dart:convert';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:material_loading_buttons/material_loading_buttons.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/toast/toast_manager.dart';

class ChangePasswordPage extends StatefulWidget {
  final Environment env;

  const ChangePasswordPage({
    super.key,
    required this.env,
  });

  @override
  State<StatefulWidget> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _showCurrentPassword = true;
  bool _showNewPassword = true;
  bool _isLoading = false;

  void _updatePassword() async {
    try {
      final response = await widget.env.http.put("user/_password", {
        "currentPassword": _currentPasswordController.text,
        "newPassword": _newPasswordController.text
      });
      if (!mounted) return;
      if (response.statusCode != 200) {
        final responseBody = json.decode(response.body)["message"];
        widget.env.logger.error(responseBody);
        throw AppException(responseBody);
      }
      widget.env.logger.info("Password successfully updated");
      widget.env.toastManager.showToast(context, ToastNotificationType.success,
          AppLocalizations.of(context).passwordUpdated);
      Navigator.pop(context);
    } catch (e, st) {
      widget.env.logger.error(e, st);
      throw AppException.withInnerException(e as Exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).changePassword),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          AppLocalizations.of(context).currentPassword,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                        autofocus: true,
                        controller: _currentPasswordController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_showCurrentPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _showCurrentPassword = !_showCurrentPassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context).enterValue;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          AppLocalizations.of(context).newPassword,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: !_showNewPassword,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_showNewPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _showNewPassword = !_showNewPassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context).enterValue;
                          }
                          if (value.length < 3 || value.length > 20) {
                            return AppLocalizations.of(context).passwordSize;
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          if (_formKey.currentState!.validate()) {
                            _updatePassword();
                          }
                        },
                      ),
                    ],
                  ),

                  // Button
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
                            _updatePassword();
                          }
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    },
                    child: Text(AppLocalizations.of(context).updatePassword),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
