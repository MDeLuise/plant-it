import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_loading_buttons/material_loading_buttons.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/login.dart';
import 'package:plant_it/otp.dart';
import 'package:plant_it/toast/toast_manager.dart';

class SignupPage extends StatefulWidget {
  final Environment env;

  const SignupPage({
    super.key,
    required this.env,
  });

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _isLoading = false;

  Future<void> _signup() async {
    final SignupRequest request = SignupRequest(
        username: _usernameController.text,
        password: _passwordController.text,
        email: _emailController.text);
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await widget.env.http.post(
        'authentication/signup',
        request.toMap(),
      );
      if (!mounted) return;
      if (response.statusCode == 200) {
        await loginAndSetAppKey(widget.env, context, _usernameController.text,
            _passwordController.text);
      } else if (response.statusCode == 202) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPInsertPage(
              env: widget.env,
              request: request,
            ),
          ),
        );
      } else {
        final responseBody = json.decode(response.body);
        widget.env.logger.error(responseBody["message"]);
        widget.env.toastManager.showToast(
            context, ToastNotificationType.error, responseBody["message"]);
      }
    } catch (e, st) {
      if (!mounted) return;
      widget.env.logger.error(e, st);
      throw AppException.withInnerException(e as Exception);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const HeaderMessage(),
                  Form(
                    key: _formKey,
                    child: AutofillGroup(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: maxWidth,
                            child: 
                              // Username
                              TextFormField(
                                autofillHints: [AutofillHints.username],
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context).username,
                                  border: const OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context).enterValue;
                                  }
                                  if (value.length < 3 || value.length > 20) {
                                    return AppLocalizations.of(context).usernameSize;
                                  }
                                  return null;
                                },
                              ),
                          ),
                          const SizedBox(height: 20),
                      
                          SizedBox(
                            width: maxWidth,
                            child: 
                              // Email
                              TextFormField(
                                autofillHints: [AutofillHints.email],
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context).email,
                                  border: const OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context).enterValue;
                                  }
                                  if (!isValidEmail(value)) {
                                    return AppLocalizations.of(context)
                                        .enterValidEmail;
                                  }
                                  return null;
                                },
                              ),
                          ),
                          const SizedBox(height: 20),
                      
                          SizedBox(
                            width: maxWidth,
                            child: 
                              // Password
                              Column(
                                children: [
                                  TextFormField(
                                    autofillHints: [AutofillHints.password],
                                    controller: _passwordController,
                                    obscureText: !_showPassword,
                                    decoration: InputDecoration(
                                      labelText:
                                          AppLocalizations.of(context).password,
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return AppLocalizations.of(context)
                                            .enterValue;
                                      }
                                      if (value.length < 6 || value.length > 20) {
                                        return AppLocalizations.of(context)
                                            .passwordSize;
                                      }
                                      return null;
                                    },
                                  )
                                ],
                              ),
                          ),
                          // Button
                          const SizedBox(height: 20),
                          ElevatedLoadingButton(
                            isLoading: _isLoading,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _signup();
                              }
                            },
                            child: Text(AppLocalizations.of(context).signup),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),

                  // Divider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Divider(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          AppLocalizations.of(context).or,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const Expanded(
                        child: Divider(),
                      ),
                    ],
                  ),

                  // Signup
                  Login(env: widget.env)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Login extends StatelessWidget {
  final Environment env;

  const Login({super.key, required this.env});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: AppLocalizations.of(context).alreadyRegistered,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const TextSpan(text: " "),
              TextSpan(
                text: AppLocalizations.of(context).login,
                style: const TextStyle(color: Color(0xFF6DD075)),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(env: env),
                      ),
                    );
                  },
              ),
            ],
          ),
        ));
  }
}

class HeaderMessage extends StatelessWidget {
  const HeaderMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyLarge,
              children: [
                TextSpan(
                  text: AppLocalizations.of(context).signupMessage,
                  style: TextStyle(
                    fontSize: DefaultTextStyle.of(context).style.fontSize! * 2,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' ',
                  style: TextStyle(
                    fontSize: DefaultTextStyle.of(context).style.fontSize! * 2,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: AppLocalizations.of(context).appName,
                  style: TextStyle(
                    fontSize: DefaultTextStyle.of(context).style.fontSize! * 2,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
              height: 10), // Add spacing between the RichText and the tagline
          Text(
            AppLocalizations.of(context).singupTagline,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
