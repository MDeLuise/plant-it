import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/login.dart';
import 'package:plant_it/theme.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 4.0),
            child: Text(title),
          ),
          ..._buildSeparatedChildren(),
        ],
      ),
    );
  }

  List<Widget> _buildSeparatedChildren() {
    final List<Widget> separatedChildren = [];
    for (int i = 0; i < children.length; i++) {
      separatedChildren.add(children[i]);
      if (i < children.length - 1) {
        separatedChildren.add(Divider(
          color: Colors.grey.withOpacity(.3),
          height: 1,
        ));
      }
    }
    if (separatedChildren.isNotEmpty) {
      final firstChild = separatedChildren.first;
      final lastChild = separatedChildren.last;
      separatedChildren[0] = ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
        child: firstChild,
      );
      separatedChildren[separatedChildren.length - 1] = ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(5),
        ),
        child: lastChild,
      );
    }
    return separatedChildren;
  }
}

class SettingsInfo extends StatelessWidget {
  final String title;
  final String value;
  final bool? isValueLoading;

  const SettingsInfo({
    super.key,
    required this.title,
    required this.value,
    this.isValueLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(24, 44, 37, 1),
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Row(
          children: [
            Text(title),
            const Spacer(),
            Skeletonizer(
                enabled: isValueLoading ?? false,
                effect: skeletonizerEffect,
                child: Text(value)),
          ],
        ),
      ),
    );
  }
}

class SettingsExternalLink extends StatelessWidget {
  final String title;
  final String url;
  const SettingsExternalLink({
    super.key,
    required this.title,
    required this.url,
  });

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        webOnlyWindowName: "_blank",
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Container(
        color: const Color.fromRGBO(24, 44, 37, 1),
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Row(
            children: [
              Text(title),
              const Spacer(),
              Icon(
                Icons.open_in_new,
                size: 20,
                color: Colors.white.withOpacity(.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsHeader extends StatelessWidget {
  final String username;
  final String email;

  const SettingsHeader({
    super.key,
    required this.username,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(24, 44, 37, 1),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AdvancedAvatar(
                name: username,
                size: 70,
                style: const TextStyle(color: Color.fromARGB(255, 156, 192, 172)),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(53, 98, 82, 1),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(username),
                  Text(email),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  final Environment env;

  const LogoutButton({
    super.key,
    required this.env,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            env.http.jwt = null;
            env.http.key = null;
            env.prefs.remove("serverKey");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(env: env),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 179, 48, 39),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              const SizedBox(width: 8.0),
              Text(
                AppLocalizations.of(context).logout.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsInternalLink extends StatelessWidget {
  final String title;
  final Function onClick;

  const SettingsInternalLink({
    super.key,
    required this.title,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick(),
      child: Container(
        color: const Color.fromRGBO(24, 44, 37, 1),
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Row(
            children: [
              Text(title),
              const Spacer(),
              Icon(
                Icons.arrow_right_alt_outlined,
                size: 20,
                color: Colors.white.withOpacity(.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
