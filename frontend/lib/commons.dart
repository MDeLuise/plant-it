import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/dto/event_dto.dart';
import 'package:plant_it/dto/plant_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/event/event_card.dart';
import 'package:plant_it/splash_screen.dart';
import 'package:plant_it/toast/toast_manager.dart';

const double maxWidth = 550;

const List<String> currencySymbols = [
  "",
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

Future<dynamic> goToPageSlidingUp(BuildContext context, Widget widget) async {
  return await Navigator.of(context).push(PageRouteBuilder(
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

Future<void> prefetchImages(BuildContext context, Environment env) {
  env.plants.forEach((plant) {
    final String plantImageUrl =
        "${env.http.backendUrl}image/content/${plant.avatarImageId}";
    precacheImage(CachedNetworkImageProvider(plantImageUrl), context);
  });
  return Future.value();
}

Future<void> fetchAndSetEventTypes(
    BuildContext context, Environment env) async {
  try {
    final response = await env.http.get("diary/entry/type");
    final responseBody = json.decode(response.body);
    if (response.statusCode == 200) {
      final List<String> eventTypes = List<String>.from(responseBody);
      env.eventTypes = eventTypes;
    } else {
      env.logger.error(responseBody["message"]);
      throw AppException(responseBody["message"]);
    }
  } catch (e, st) {
    if (!context.mounted) return;
    env.logger.error(e, st);
    throw AppException.withInnerException(e as Exception);
  }
}

Future<void> fetchAndSetPlants(BuildContext context, Environment env) async {
  try {
    final totalPlantsResponse = await env.http.get("plant/_count");
    if (totalPlantsResponse.statusCode != 200) {
      final totalPlantsResponseBody = json.decode(totalPlantsResponse.body);
      throw AppException(totalPlantsResponseBody["message"]);
    }
    final response =
        await env.http.get("plant?pageSize=${totalPlantsResponse.body}");
    if (response.statusCode == 200) {
      final responseBody = json.decode(utf8.decode(response.bodyBytes));
      final List<dynamic> plantJsonList = responseBody["content"];
      env.plants =
          plantJsonList.map((json) => PlantDTO.fromJson(json)).toList();
    }
  } catch (e, st) {
    if (!context.mounted) return;
    env.logger.error(e, st);
    throw AppException.withInnerException(e as Exception);
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
  } catch (e, st) {
    if (!context.mounted) return;
    env.logger.error(e, st);
    env.toastManager
        .showToast(context, ToastNotificationType.error, e.toString());
    throw AppException.withInnerException(e as Exception);
  }
}

Future<List<String>> _fetchAvailableNotificationDispatchers(
    BuildContext context, Environment env) async {
  try {
    final response = await env.http.get("info/notification-dispatchers");
    if (response.statusCode == 200) {
      final List<String> responseBody =
          json.decode(response.body).cast<String>();
      return responseBody;
    } else {
      final String errorMessage = json.decode(response.body)["message"];
      env.logger.error(errorMessage);
      throw AppException(errorMessage);
    }
  } catch (e, st) {
    if (!context.mounted) return [];
    env.logger.error(e, st);
    env.toastManager
        .showToast(context, ToastNotificationType.error, e.toString());
    throw AppException.withInnerException(e as Exception);
  }
}

Future<List<String>> _fetchEnabledNotificationDispatchers(
    BuildContext context, Environment env) async {
  try {
    final response = await env.http.get("notification-dispatcher");
    if (response.statusCode == 200) {
      final List<String> responseBody =
          json.decode(response.body).cast<String>();
      return responseBody;
    } else {
      final String errorMessage = json.decode(response.body)["message"];
      env.logger.error(errorMessage);
      throw AppException(errorMessage);
    }
  } catch (e, st) {
    if (!context.mounted) return [];
    env.logger.error(e, st);
    throw AppException.withInnerException(e as Exception);
  }
}

Future<void> fetchAndSetNotificationDispatchers(
    BuildContext context, Environment env) async {
  final List<String> available =
      await _fetchAvailableNotificationDispatchers(context, env);
  final List<String> enabled =
      await _fetchEnabledNotificationDispatchers(context, env);
  final List<NotificationDispatcher> result = [];
  available.forEach((element) {
    result.add(NotificationDispatcher(
        name: element, enabled: enabled.contains(element)));
  });
  env.notificationDispatcher = result;
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
        env.logger.error(Exception(errorMessage));
        throw AppException(errorMessage);
      }
    }
  } catch (e, st) {
    if (!context.mounted) return;
    env.logger.error(e, st);
    throw AppException(AppLocalizations.of(context).noBackend);
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
      env.logger.error(errorMessage);
      env.toastManager
          .showToast(context, ToastNotificationType.error, errorMessage);
      return false;
    }
  } catch (e, st) {
    if (!context.mounted) return false;
    env.logger.error(e, st);
    env.toastManager.showToast(context, ToastNotificationType.error,
        AppLocalizations.of(context).noBackend);
    return false;
  }
}
