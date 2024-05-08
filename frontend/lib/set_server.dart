import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_loading_buttons/material_loading_buttons.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/login.dart';
import 'package:plant_it/toast/toast_manager.dart';

class SetServer extends StatefulWidget {
  final Environment env;

  const SetServer({
    super.key,
    required this.env,
  });

  @override
  State<SetServer> createState() => _SetServerState();
}

class _SetServerState extends State<SetServer> {
  final TextEditingController _backendController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool insertedBackendController = false;
  bool _isLoading = false;

  void _ping() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String url = _backendController.text;
      url = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
      widget.env.http.backendUrl = "$url/api/";
      widget.env.prefs.setString("serverURL", "$url/api/");
      final response = await widget.env.http
          .get('info/ping')
          .timeout(const Duration(seconds: 3));
      if (!mounted) return;
      if (response.statusCode == 200 && response.body == "pong") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(env: widget.env),
          ),
        );
      } else {
        widget.env.logger.error("Cannot connect to the server");
        throw AppException(AppLocalizations.of(context).noBackend);
      }
    } catch (e, st) {
      if (!mounted) return;
      widget.env.logger.error(e, st);
      widget.env.toastManager.showToast(context, ToastNotificationType.error,
          AppLocalizations.of(context).noBackend);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _backendController.dispose();
    super.dispose();
  }

  bool _isValidUrl(String url) {
    final RegExp urlRegExp = RegExp(
      r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:​,.;]*)?",
      caseSensitive: false,
    );
    return urlRegExp.hasMatch(url);
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
                              AppLocalizations.of(context).insertBackendURL,
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
                          controller: _backendController,
                          decoration: InputDecoration(
                              labelText: AppLocalizations.of(context).serverURL,
                              border: const OutlineInputBorder(),
                              hintText: "http://192.168.1.6:8085"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context).enterValue;
                            }
                            if (!_isValidUrl(value)) {
                              return AppLocalizations.of(context).enterValidURL;
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            if (_formKey.currentState!.validate()) {
                              _ping();
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedLoadingButton(
                          isLoading: _isLoading,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _ping();
                            }
                          },
                          child: Text(AppLocalizations.of(context).go),
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
