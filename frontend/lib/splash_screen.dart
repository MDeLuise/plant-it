import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/template.dart';

class SplashPage extends StatefulWidget {
  final Environment env;

  const SplashPage({super.key, required this.env});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<Widget> fetchData(BuildContext context, Environment env) async {
    try {
      await Future.wait([
        fetchAndSetEventTypes(context, env),
        fetchAndSetPlants(context, env),
        fetchAndSetBackendVersion(context, env),
      ]);
      return Future.value(TemplatePage(env: env));
    } catch (e) {
      if (!context.mounted) return const SizedBox();
      showSnackbar(context, SnackBarType.fail, e.toString());
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset('assets/images/logo.png'),
      backgroundColor: const Color(0xFF061913),
      showLoader: true,
      loadingText: Text(AppLocalizations.of(context).splashLoading),
      futureNavigator: fetchData(context, widget.env),
      loaderColor: Colors.grey,
    );
  }
}
