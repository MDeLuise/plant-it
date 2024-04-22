import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:material_loading_buttons/material_loading_buttons.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/login.dart';
import 'package:toastification/toastification.dart';

class ChangeServerPage extends StatefulWidget {
  final Environment env;

  const ChangeServerPage({
    super.key,
    required this.env,
  });

  @override
  State<StatefulWidget> createState() => _ChangeServerPageState();
}

class _ChangeServerPageState extends State<ChangeServerPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newServerController = TextEditingController();
  bool _isLoading = false;

  bool _isValidUrl(String url) {
    final RegExp urlRegExp = RegExp(
      r'^(?:http|https):\/\/'
      r'(?:(?:[A-Z0-9][A-Z0-9_-]*)(?::(?:[A-Z0-9][A-Z0-9_-]*))?@)?'
      r'(?:'
      r'(?:[A-Z0-9][A-Z0-9-]{0,61}[A-Z0-9]\.)+[A-Z]{2,6}'
      r'|localhost'
      r'|\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}'
      r')'
      r'(?::\d+)?'
      r'(?:\/[^\s]*)?$',
      caseSensitive: false,
    );
    return urlRegExp.hasMatch(url);
  }

  void _updateServer() async {
    setState(() {
      _isLoading = true;
    });
    final String currentUrl = widget.env.http.backendUrl!;
    try {
      String url = _newServerController.text;
      url = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
      widget.env.http.backendUrl = "$url/api/";
      final response = await widget.env.http
          .get('info/ping')
          .timeout(const Duration(seconds: 3));
      if (!mounted) return;
      if (response.statusCode == 200 && response.body == "pong") {
        widget.env.prefs.setString("serverURL", "$url/api/");
        widget.env.logger.info("Server URL correctly updated");
        showSnackbar(context, ToastificationType.success,
            AppLocalizations.of(context).serverUpdated);
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
      showSnackbar(context, ToastificationType.error,
          AppLocalizations.of(context).noBackend);
    } finally {
      widget.env.http.backendUrl = currentUrl;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _newServerController.text =
        widget.env.http.backendUrl!.replaceAll("/api", "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).changeServer),
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
                          AppLocalizations.of(context).serverURL,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                        autofocus: true,
                        controller: _newServerController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || !_isValidUrl(value)) {
                            return AppLocalizations.of(context).enterValidURL;
                          }
                          return null;
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
                        if (_formKey.currentState!.validate()) {
                          _updateServer();
                        }
                      }
                    },
                    child: Text(AppLocalizations.of(context).changeServer),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
