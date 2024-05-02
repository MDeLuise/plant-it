import 'dart:async';

import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/set_server.dart';
import 'package:plant_it/template.dart';
import 'package:plant_it/toast/toast_manager.dart';

class SplashPage extends StatefulWidget {
  final Environment env;

  const SplashPage({
    super.key,
    required this.env,
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<Widget> fetchData(BuildContext context, Environment env) async {
    try {
      await Future.wait(
        [
          fetchAndSetEventTypes(context, env),
          fetchAndSetPlants(context, env),
          fetchAndSetBackendVersion(context, env),
          fetchAndSetNotificationDispatchers(context, env),
        ],
        eagerError: true,
      );
      await prefetchImages(context, env);
      return Future.value(TemplatePage(env: env));
    } catch (e, st) {
      if (!context.mounted) return const SizedBox();
      widget.env.logger.error(e, st);
      throw AppException.withInnerException(e as Exception);
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      if (!mounted) return;
      widget.env.http.jwt = null;
      widget.env.http.key = null;
      widget.env.toastManager.showToast(context, ToastNotificationType.error,
          AppLocalizations.of(context).noBackend);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SetServer(
            env: widget.env,
          ),
        ),
      );
    });
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
      title: Text("Plant-it"),
    );
  }
}
