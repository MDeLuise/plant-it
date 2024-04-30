import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:material_loading_buttons/material_loading_buttons.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/commons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/environment.dart';

class OTPInsertPage extends StatefulWidget {
  final Environment env;
  final SignupRequest request;
  const OTPInsertPage({
    super.key,
    required this.env,
    required this.request,
  });

  @override
  State<OTPInsertPage> createState() => _OTPInsertPageState();
}

class _OTPInsertPageState extends State<OTPInsertPage> {
  late final FocusNode _firstFieldFocus = FocusNode();
  late final FocusNode _secondFieldFocus = FocusNode();
  late final FocusNode _thirdFieldFocus = FocusNode();
  late final FocusNode _fourthFieldFocus = FocusNode();
  late final FocusNode _fifthFieldFocus = FocusNode();
  late final FocusNode _sixthFieldFocus = FocusNode();
  late final TextEditingController _firstController = TextEditingController();
  late final TextEditingController _secondController = TextEditingController();
  late final TextEditingController _thirdController = TextEditingController();
  late final TextEditingController _fourthController = TextEditingController();
  late final TextEditingController _fifthController = TextEditingController();
  late final TextEditingController _sixthController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstFieldFocus.requestFocus();
  }

  @override
  void dispose() {
    _firstFieldFocus.dispose();
    _secondFieldFocus.dispose();
    _thirdFieldFocus.dispose();
    _fourthFieldFocus.dispose();
    _fifthFieldFocus.dispose();
    _sixthFieldFocus.dispose();
    _firstController.dispose();
    _secondController.dispose();
    _thirdController.dispose();
    _fourthController.dispose();
    _fifthController.dispose();
    _sixthController.dispose();
    super.dispose();
  }

  void resetCode() {
    _firstController.clear();
    _secondController.clear();
    _thirdController.clear();
    _fourthController.clear();
    _fifthController.clear();
    _sixthController.clear();
    _firstFieldFocus.requestFocus();
  }

  String _getInsertedOTP() {
    String result = "";
    result += _firstController.text;
    result += _secondController.text;
    result += _thirdController.text;
    result += _fourthController.text;
    result += _fifthController.text;
    result += _sixthController.text;
    return result;
  }

  void _verify() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await widget.env.http.post(
          "authentication/signup/otp/${_getInsertedOTP()}",
          widget.request.toMap());
      if (response.statusCode == 200) {
        if (!mounted) return;
        loginAndSetAppKey(widget.env, context, widget.request.username,
            widget.request.password);
      } else {
        if (!mounted) return;
        final responseBody = json.decode(response.body);
        widget.env.logger.error(responseBody["message"]);
        throw AppException(responseBody["message"]);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resendCode() async {
    final response = await widget.env.http
        .post("authentication/signup", widget.request.toMap());
    if (response.statusCode == 202) {
      resetCode();
    } else {
      if (!mounted) return;
      final responseBody = json.decode(response.body);
      widget.env.logger.error(responseBody["message"]);
      throw AppException(responseBody["message"]);
    }
  }

  void _onChanged(String value, FocusNode focus) {
    if (value.length == 1) {
      focus.nextFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context).sentOTPCode,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.request.email,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildOTPField(_firstController, _firstFieldFocus),
                        _buildOTPField(_secondController, _secondFieldFocus),
                        _buildOTPField(_thirdController, _thirdFieldFocus),
                        _buildOTPField(_fourthController, _fourthFieldFocus),
                        _buildOTPField(_fifthController, _fifthFieldFocus),
                        _buildOTPField(_sixthController, _sixthFieldFocus),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedLoadingButton(
                      isLoading: _isLoading,
                      onPressed: () {
                        _verify();
                      },
                      child: Text(AppLocalizations.of(context).verify),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        _resendCode();
                      },
                      child: Text(AppLocalizations.of(context).resendCode),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOTPField(TextEditingController controller, FocusNode focus) {
    final double maxWidth = MediaQuery.of(context).size.width / 7;
    final double maxHeight = MediaQuery.of(context).size.height / 7;

    return Container(
      constraints: const BoxConstraints(maxWidth: 80, maxHeight: 80),
      width: maxWidth,
      height: maxHeight,
      padding: const EdgeInsets.all(7.0),
      child: TextField(
        controller: controller,
        focusNode: focus,
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 18),
        decoration: InputDecoration(
          counter: const Offstage(),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onChanged: (value) => _onChanged(value, focus),
      ),
    );
  }
}
