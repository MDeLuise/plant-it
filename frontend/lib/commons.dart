import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:plant_it/dto/event_dto.dart';
import 'package:plant_it/dto/plant_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/event/events.dart';
import 'package:plant_it/splash_screen.dart';
import 'package:icon_animated/icon_animated.dart';

const List<String> currencySymbols = [
  "€", // Euro Sign
  "\$", // Dollar sign
  "¢", // Cent sign
  "₠", // European Currency
  "₡", // Colon Sign
  "₢", // Cruzeiro Sign
  "₣", // French Franc Sign
  "₤", // Lira Sign
  "₥", // Mill Sign
  "₦", // Naira Sign
  "₧", // Peseta Sign
  "₨", // Rupee Sign
  "₩", // Won Sign
  "₪", // New Sheqel Sign
  "₫", // Dong Sign
  "₭", // Kip Sign
  "₮", // Tugrik Sign
  "₯", // Drachma Sign
  "₰", // German Penny Sign
  "₱", // Peso Sign
  "₲", // Guarani Sign
  "₳", // Austral Sign
  "₴", // Hryvnia Sign
  "₵", // Cedi Sign
  "₶", // Old Turkish Lira Sign
  "₷", // Lira Sign
  "₸", // Rupee Sign
  "₹", // Indian Rupee Sign
  "₺", // Turkish Lira Sign
  "₻", // Tamil Rupee Sign
  "₼", // Azerbaijani Manat Sign
  "₽", // Russian Ruble Sign
  "₾", // Lari Sign
  "₿", // Bitcoin Sign
];

String formatDate(DateTime toFormat) {
  final DateFormat dateFormat = DateFormat('dd/MM/yy');
  return dateFormat.format(toFormat);
}

List<int> plantNamesToDiaryIds(List<PlantDTO> plants, List<String> names) {
  final List<int> plantIds = [];
  for (var i = 0; i < names.length; i++) {
    for (var j = 0; j < plants.length; j++) {
      if (plants[j].info.personalName == names[i]) {
        plantIds.add(plants[j].diaryId!);
      }
    }
  }
  return plantIds;
}

Future<dynamic> goToPageSlidingUp(BuildContext context, Widget widget) {
  return Navigator.of(context).push(PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  ));
}

String getBackendEvent(BuildContext context, String localeEvent) {
  String result;
  String lowercasedLocaleEvent = localeEvent.toLowerCase();
  if (lowercasedLocaleEvent == AppLocalizations.of(context).seeding) {
    result = "seeding";
  } else if (lowercasedLocaleEvent == AppLocalizations.of(context).watering) {
    result = "watering";
  } else if (lowercasedLocaleEvent ==
      AppLocalizations.of(context).fertilizing) {
    result = "fertilizing";
  } else if (lowercasedLocaleEvent ==
      AppLocalizations.of(context).biostimulating) {
    result = "biostimulating";
  } else if (lowercasedLocaleEvent == AppLocalizations.of(context).misting) {
    result = "misting";
  } else if (lowercasedLocaleEvent ==
      AppLocalizations.of(context).transplanting) {
    result = "transplanting";
  } else if (lowercasedLocaleEvent ==
      AppLocalizations.of(context).water_changing) {
    result = "water_changing";
  } else if (lowercasedLocaleEvent ==
      AppLocalizations.of(context).observation) {
    result = "observation";
  } else if (lowercasedLocaleEvent == AppLocalizations.of(context).treatment) {
    result = "treatment";
  } else if (lowercasedLocaleEvent ==
      AppLocalizations.of(context).propagating) {
    result = "propagating";
  } else if (lowercasedLocaleEvent == AppLocalizations.of(context).pruning) {
    result = "pruning";
  } else {
    result = AppLocalizations.of(context).repotting;
  }
  return result.toUpperCase();
}

String getLocaleEvent(BuildContext context, String event) {
  final String lowercasedEvent = event.toLowerCase();
  if (lowercasedEvent == "seeding") {
    return AppLocalizations.of(context).seeding;
  } else if (lowercasedEvent == "watering") {
    return AppLocalizations.of(context).watering;
  } else if (lowercasedEvent == "fertilizing") {
    return AppLocalizations.of(context).fertilizing;
  } else if (lowercasedEvent == "biostimulating") {
    return AppLocalizations.of(context).biostimulating;
  } else if (lowercasedEvent == "misting") {
    return AppLocalizations.of(context).misting;
  } else if (lowercasedEvent == "transplanting") {
    return AppLocalizations.of(context).transplanting;
  } else if (lowercasedEvent == "water_changing") {
    return AppLocalizations.of(context).water_changing;
  } else if (lowercasedEvent == "observation") {
    return AppLocalizations.of(context).observation;
  } else if (lowercasedEvent == "treatment") {
    return AppLocalizations.of(context).treatment;
  } else if (lowercasedEvent == "propagating") {
    return AppLocalizations.of(context).propagating;
  } else if (lowercasedEvent == "pruning") {
    return AppLocalizations.of(context).pruning;
  } else {
    return AppLocalizations.of(context).repotting;
  }
}

Future<void> fetchAndSetEventTypes(
    BuildContext context, Environment env) async {
  try {
    final response = await env.http.get("diary/entry/type");
    if (response.statusCode == 200) {
      final List<dynamic> responseBody = json.decode(response.body);
      final List<String> eventTypes = List<String>.from(responseBody);
      env.eventTypes = eventTypes;
    }
  } catch (e) {
    if (!context.mounted) return;
    showSnackbar(context, SnackBarType.fail, e.toString());
  }
}

Future<void> fetchAndSetPlants(BuildContext context, Environment env) async {
  try {
    final response = await env.http.get("plant");
    if (response.statusCode == 200) {
      final responseBody = json.decode(utf8.decode(response.bodyBytes));
      final List<dynamic> plantJsonList = responseBody["content"];
      env.plants =
          plantJsonList.map((json) => PlantDTO.fromJson(json)).toList();
    }
  } catch (e) {
    if (!context.mounted) return;
    showSnackbar(context, SnackBarType.fail, e.toString());
  }
}

Future<void> fetchAndSetBackendVersion(
    BuildContext context, Environment env) async {
  try {
    final response = await env.http.get("info/version");
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      env.backendVersion = responseBody["currentVersion"];
    }
  } catch (e) {
    if (!context.mounted) return;
    showSnackbar(context, SnackBarType.fail, e.toString());
  }
}

EventCard dtoToCard(dynamic dto, Environment env) {
  return EventCard(
    action: dto["type"],
    plant: dto["diaryTargetPersonalName"],
    date: DateTime.parse(dto["date"]),
    eventDTO: EventDTO.fromJson(dto),
    env: env,
  );
}

const int screenSizeTreshold = 600;

bool isSmallScreen(BuildContext context) {
  final double width = MediaQuery.of(context).size.width;
  return width < screenSizeTreshold;
}

class SignupRequest {
  final String username;
  final String password;
  final String email;

  SignupRequest({
    required this.username,
    required this.password,
    required this.email,
  });

  Map<String, String> toMap() {
    return {
      'username': username,
      'password': password,
      'email': email,
    };
  }
}

String formatEventType(String eventType) {
  return eventType.toLowerCase().replaceAll("_", " ");
}

String encodeEventType(String formattedEventType) {
  return formattedEventType.toUpperCase().replaceAll(" ", "_");
}

void showSnackbar(BuildContext context, SnackBarType type, String message) {
  // IconSnackBar.show(context,
  //     snackBarType: type,
  //     label: message,
  //     snackBarStyle: const SnackBarStyle(maxLines: 4),
  //     duration: const Duration(seconds: 3));
  const duration = Duration(seconds: 3);
  final margin = EdgeInsets.only(
      bottom: MediaQuery.of(context).size.height - 170, right: 20, left: 20);
  switch (type) {
    case SnackBarType.success:
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: duration,
        dismissDirection: DismissDirection.up,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: SnackBarWidget(
          onPressed: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
          },
          label: message,
          backgroundColor: Colors.green,
          //labelTextStyle: snackBarStyle.labelTextStyle,
          iconType: IconType.check,
          maxLines: 4,
        ),
        margin: margin,
      ));
    case SnackBarType.fail:
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: duration,
        dismissDirection: DismissDirection.up,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: SnackBarWidget(
          onPressed: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
          },
          label: message,
          backgroundColor: Colors.red,
          //labelTextStyle: snackBarStyle.labelTextStyle,
          iconType: IconType.fail,
          maxLines: 4,
        ),
        margin: margin,
      ));
    case SnackBarType.alert:
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: duration,
        dismissDirection: DismissDirection.up,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: SnackBarWidget(
          onPressed: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
          },
          label: message,
          backgroundColor: Colors.black,
          //labelTextStyle: snackBarStyle.labelTextStyle,
          iconType: IconType.alert,
          maxLines: 4,
        ),
        margin: margin,
      ));
  }
}

Future<void> loginAndSetAppKey(Environment env, BuildContext context,
    String username, String password) async {
  const String appKeyName = "frontend";

  if (!context.mounted) return;
  final loggedIn = await _login(env, context, username, password);
  if (!loggedIn) {
    return;
  }
  try {
    final response = await env.http.get(
      'api-key/name/$appKeyName',
    );
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final String key = responseBody["value"];
      env.http.jwt = null;
      env.http.key = key;
      await env.prefs.setString('serverKey', key);
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SplashPage(env: env),
        ),
      );
    } else if (response.statusCode == 404) {
      final response = await env.http.post('api-key/', {"name": appKeyName});
      if (response.statusCode == 200) {
        env.http.jwt = null;
        env.http.key = response.body;
        await env.prefs.setString('serverKey', response.body);
        if (!context.mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SplashPage(env: env),
          ),
        );
      } else {
        if (!context.mounted) return;
        final responseBody = json.decode(response.body);
        final errorMessage = responseBody['message'];
        showSnackbar(context, SnackBarType.fail, errorMessage);
      }
    }
  } catch (e) {
    if (!context.mounted) return;
    showSnackbar(
        context, SnackBarType.fail, AppLocalizations.of(context).noBackend);
    rethrow;
  }
}

Future<bool> _login(Environment env, BuildContext context, String username,
    String password) async {
  try {
    final response = await env.http.post(
      'authentication/login',
      {
        'username': username,
        'password': password,
      },
    );
    final responseBody = json.decode(response.body);
    if (response.statusCode == 200) {
      env.http.jwt = responseBody["jwt"]["value"];
      await env.prefs.setString('username', username);
      env.credentials.username = username;
      await env.prefs.setString('email', responseBody["email"]);
      env.credentials.email = responseBody["email"];
      return true;
    } else {
      if (!context.mounted) return false;
      final errorMessage = responseBody['message'];
      showSnackbar(context, SnackBarType.fail, errorMessage);
      return false;
    }
  } catch (e) {
    if (!context.mounted) return false;
    showSnackbar(
        context, SnackBarType.fail, AppLocalizations.of(context).noBackend);
    rethrow;
  }
}
