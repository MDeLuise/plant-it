import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/login.dart';

class SetServer extends StatefulWidget {
  final Environment env;

  const SetServer({super.key, required this.env});

  @override
  State<SetServer> createState() => _SetServerState();
}

class _SetServerState extends State<SetServer> {
  late final Environment _env;
  final TextEditingController _backendController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool insertedBackendController = false;

  @override
  void initState() {
    super.initState();
    _env = widget.env;
  }

  Future<void> _ping() async {
    try {
      String url = _backendController.text;
      url = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
      _env.http.setBackendUrl("$url/api/");
      final response =
          await _env.http.get('info/ping').timeout(const Duration(seconds: 3));
      if (!mounted) return;
      if (response.statusCode == 200 && response.body == "pong") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(env: _env),
            // builder: (context) => OTPInsertPage(
            //     env: _env,
            //     request: SignupRequest(
            //         username: "max",
            //         password: "user00000",
            //         email: "homeservertest.mummy895@slmails.com")),
          ),
        );
      } else {
        showSnackbar(context, ContentType.failure,
            AppLocalizations.of(context).noBackend);
      }
    } catch (e) {
      if (!mounted) return;
      showSnackbar(context, ContentType.failure, e.toString());
    }
  }

  @override
  void dispose() {
    _backendController.dispose();
    super.dispose();
  }

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

  Widget _buildMobileView(BuildContext context) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                child: Text(AppLocalizations.of(context).insertBackendURL,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize:
                          DefaultTextStyle.of(context).style.fontSize! * 0.35,
                      decoration: TextDecoration.none,
                    )),
              ),
              TextFormField(
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
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _ping();
                  }

                  // to delete below, just for testing
                  // _httpClient.setBackendUrl("${_backendController.text}/api/");
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => const LoginPage(),
                  //     ));
                },
                child: Text(AppLocalizations.of(context).go),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      )
    ]));
  }

  Widget _buildDesktopView(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double imageWidth = screenSize.width * 0.8;
    final double imageHeight = screenSize.height * 0.8;

    return Container(
      decoration: null,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Image.asset(
            'assets/images/set_server.jpg',
            width: imageWidth,
            height: imageHeight,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < screenSizeTreshold;

    Widget body;
    if (isSmallScreen) {
      body = _buildMobileView(context);
    } else {
      body = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: _buildDesktopView(context),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: null,
              child: _buildMobileView(context),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: body,
        ),
      ),
    );
  }
}
