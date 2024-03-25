import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/more/change_password_page.dart';
import 'package:plant_it/more/edit_profile.dart';
import 'package:plant_it/more/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MorePage extends StatefulWidget {
  final Environment env;

  const MorePage({
    super.key,
    required this.env,
  });

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  final Map<String, int> _stats = {};
  bool _statsLoading = true;
  late String _appVersion;
  bool _appVersionLoading = true;

  void _fetchAndSetStats() async {
    try {
      final response = await widget.env.http.get("stats");
      final responseBody = json.decode(response.body);
      if (response.statusCode != 200) {
        if (!mounted) return;
        showSnackbar(context, SnackBarType.fail, responseBody["message"]);
        return;
      }
      _stats.clear();
      responseBody.forEach((key, value) {
        _stats[key] = value as int;
      });
      setState(() {
        _statsLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      showSnackbar(context, SnackBarType.fail, e.toString());
    }
  }

  List<Widget> _buildStatsList() {
    if (_statsLoading) {
      return [1, 2, 3].map((element) {
        return Skeletonizer(
          enabled: true,
          effect: const PulseEffect(
            from: Colors.grey,
            to: Color.fromARGB(255, 207, 207, 207),
          ),
          child: SettingsInfo(
            title: element.toString() * (8 + element),
            value: element.toString() * (8 + element),
          ),
        );
      }).toList();
    } else {
      return _stats.entries.map((entry) {
        return SettingsInfo(
          title: _formatStats(context, entry.key),
          value: entry.value.toString(),
        );
      }).toList();
    }
  }

  String _formatStats(BuildContext context, String statName) {
    if (statName == "diaryEntryCount") {
      return AppLocalizations.of(context).eventCount;
    } else if (statName == "plantCount") {
      return AppLocalizations.of(context).plantCount;
    } else if (statName == "botanicalInfoCount") {
      return AppLocalizations.of(context).speciesCount;
    } else if (statName == "imageCount") {
      return AppLocalizations.of(context).imageCount;
    } else {
      return AppLocalizations.of(context).unknown;
    }
  }

  void _fetchAndSetAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _appVersion = packageInfo.version;
    setState(() {
      _appVersionLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchAndSetStats();
    _fetchAndSetAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SettingsHeader(
            username: widget.env.credentials.username,
            email: widget.env.credentials.email,
          ),
          SettingsSection(
            title: AppLocalizations.of(context).account,
            children: [
              SettingsInternalLink(
                title: AppLocalizations.of(context).editProfile,
                onClick: () async {
                  final bool isUpdated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(
                        env: widget.env,
                      ),
                    ),
                  );
                  if (isUpdated) {
                    setState(() {});
                  }
                },
              ),
              SettingsInternalLink(
                title: AppLocalizations.of(context).changePassword,
                onClick: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordPage(
                      env: widget.env,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SettingsSection(
            title: AppLocalizations.of(context).stats,
            children: _buildStatsList(),
          ),
          SettingsSection(
            title: AppLocalizations.of(context).more,
            children: [
              SettingsInfo(
                title: AppLocalizations.of(context).appVersion,
                isValueLoading: _appVersionLoading,
                value: _appVersionLoading ? "loading..." : _appVersion,
              ),
              SettingsInfo(
                title: AppLocalizations.of(context).serverVersion,
                value: widget.env.backendVersion,
              ),
              SettingsExternalLink(
                title: AppLocalizations.of(context).documentation,
                url: "https://docs.plant-it.org/",
              ),
              SettingsExternalLink(
                title: AppLocalizations.of(context).openSource,
                url: "https://github.com/MDeLuise/plant-it",
              ),
              SettingsExternalLink(
                title: AppLocalizations.of(context).reportIssue,
                url: "https://github.com/MDeLuise/plant-it/issues/new/choose",
              ),
            ],
          ),
          LogoutButton(
            env: widget.env,
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
