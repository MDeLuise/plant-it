import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/login.dart';

class SignupPage extends StatefulWidget {
  final Environment env;

  const SignupPage({super.key, required this.env});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late final Environment _env;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = true;

  @override
  void initState() {
    super.initState();
    _env = widget.env;
  }

  Future<void> _signup() async {
    try {
      final response = await _env.http.post(
        Uri.parse('authentication/signup'),
        {
          'username': _usernameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );
      if (!mounted) return;
      final responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        await loginAndSetAppKey(
            _env, context, _usernameController.text, _passwordController.text);
      } else {
        final errorMessage = responseBody['message'];
        showErrorDialog(
            context, AppLocalizations.of(context).generalError, errorMessage);
      }
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(
          context, AppLocalizations.of(context).noBackend, e.toString());
    }
  }

  bool _isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
    );
    return emailRegex.hasMatch(email);
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const HeaderMessage(),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Username
                    TextFormField(
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
                    const SizedBox(height: 20),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).email,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context).enterValue;
                        }
                        if (!_isValidEmail(value)) {
                          return AppLocalizations.of(context).enterValidEmail;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Password
                    Column(
                      children: [
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_showPassword,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context).password,
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
                              return AppLocalizations.of(context).enterValue;
                            }
                            if (value.length < 3 || value.length > 20) {
                              return AppLocalizations.of(context).passwordSize;
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              AppLocalizations.of(context).forgotPassword,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Button
                    const SizedBox(height: 20),
                    ElevatedButton(
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

              // Divider
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Divider(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'or',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: Divider(),
                  ),
                ],
              ),

              // Signup
              Login(env: _env)
            ],
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
                style: const TextStyle(color: Colors.black),
              ),
              const TextSpan(text: " "),
              TextSpan(
                text: AppLocalizations.of(context).login,
                style: const TextStyle(color: Colors.blue),
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
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: AppLocalizations.of(context).signupMessage,
                  style: TextStyle(
                      fontSize:
                          DefaultTextStyle.of(context).style.fontSize! * 2,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.bold)),
              TextSpan(
                  text: ' ',
                  style: TextStyle(
                    fontSize: DefaultTextStyle.of(context).style.fontSize! * 2,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.bold,
                  )),
              TextSpan(
                  text: AppLocalizations.of(context).appName,
                  style: TextStyle(
                      fontSize:
                          DefaultTextStyle.of(context).style.fontSize! * 2,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.bold,
                      color: Colors.green)),
            ],
          ),
        ));
  }
}
