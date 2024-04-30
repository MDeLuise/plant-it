import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_loading_buttons/material_loading_buttons.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/environment.dart';
import 'package:toastification/toastification.dart';

class ResetPassword extends StatefulWidget {
  final Environment env;

  const ResetPassword({
    super.key,
    required this.env,
  });

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _resetPassword() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await widget.env.http.post(
          "authentication/password/reset/${_usernameController.text}", {});
      if (!mounted) return;
      if (response.statusCode != 200) {
        final responseBody = json.decode(response.body);
        widget.env.logger.error(
            "Error while resetting password: ${responseBody["message"]}");
        throw AppException(AppLocalizations.of(context).errorResettingPassword);
      }
      final responseBody = response.body;
      widget.env.logger.info("Password reset request successfully sent");
      showSnackbar(context, ToastificationType.success, responseBody);
      Navigator.pop(context);
    } catch (e, st) {
      if (!mounted) return;
      widget.env.logger.error(e, st);
      showSnackbar(context, ToastificationType.error,
          AppLocalizations.of(context).errorResettingPassword);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 150,
                      height: 150,
                    )),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                              AppLocalizations.of(context).resetPasswordHeader,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: DefaultTextStyle.of(context)
                                        .style
                                        .fontSize! *
                                    0.35,
                                decoration: TextDecoration.none,
                              )),
                        ),
                        TextFormField(
                          autofocus: true,
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context).username,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.length < 3 ||
                                value.length > 20) {
                              return AppLocalizations.of(context).usernameSize;
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            if (_formKey.currentState!.validate()) {
                              _resetPassword();
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedLoadingButton(
                          isLoading: _isLoading,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _resetPassword();
                            }
                          },
                          child:
                              Text(AppLocalizations.of(context).resetPassword),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                )
              ])),
        ),
      ),
    );
  }
}
