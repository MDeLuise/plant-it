import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePageHeader extends StatelessWidget {
  final String username;
  const HomePageHeader({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context).hello(username)),
                Text(
                  AppLocalizations.of(context).welcomeBack,
                  style: TextStyle(
                    color:
                        Theme.of(context).inputDecorationTheme.hintStyle!.color,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: AdvancedAvatar(
                name: username,
                style: TextStyle(color: Color.fromARGB(255, 156, 192, 172)),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(24, 44, 37, 1),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
