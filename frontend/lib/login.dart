import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = true;

  @override
  void initState() {
    super.initState();
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
                        loginAndSetAppKey(context, _usernameController.text,
                            _passwordController.text);
                      },
                      child: Text(AppLocalizations.of(context).login),
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
              const Signup()
            ],
          ),
        ),
      ),
    );
  }
}

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: AppLocalizations.of(context).areYouNew,
                style: const TextStyle(color: Colors.black),
              ),
              const TextSpan(text: " "),
              TextSpan(
                text: AppLocalizations.of(context).createAccount,
                style: const TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupPage(),
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
                  text: AppLocalizations.of(context).loginMessage,
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
