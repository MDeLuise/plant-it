import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/logger/logger.dart' as my_logger;
import 'package:plant_it/more/change_language_page.dart';
import 'package:plant_it/more/change_notifications.dart';
import 'package:plant_it/more/change_password_page.dart';
import 'package:plant_it/more/change_server_page.dart';
import 'package:plant_it/more/edit_profile.dart';
import 'package:plant_it/more/gotify_settings.dart';
import 'package:plant_it/more/ntfy_settings.dart';
import 'package:plant_it/more/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/notify_conf_notifier.dart';
import 'package:plant_it/theme.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:talker_flutter/talker_flutter.dart';

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
  bool _ntfyVisible = false;
  bool _gotifyVisible = false;

  void _fetchAndSetStats() async {
    try {
      final response = await widget.env.http.get("stats");
      final responseBody = json.decode(response.body);
      if (response.statusCode != 200) {
        if (!mounted) return;
        widget.env.logger.error(responseBody["message"]);
        throw AppException(responseBody["message"]);
      }
      _stats.clear();
      responseBody.forEach((key, value) {
        _stats[key] = value as int;
      });
      setState(() {
        _statsLoading = false;
      });
    } catch (e, st) {
      if (!mounted) return;
      widget.env.logger.error(e, st);
      throw AppException.withInnerException(e as Exception);
    }
  }

  List<Widget> _buildStatsList() {
    if (_statsLoading) {
      return [1, 2, 3].map((element) {
        return Skeletonizer(
          enabled: true,
          effect: skeletonizerEffect,
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

  bool _isNotificationDispatcherActiveAndEnabled(String name) {
    if (!widget.env.notificationDispatcher.map((e) => e.name).contains(name)) {
      return false;
    }
    final NotificationDispatcher dispatcher =
        widget.env.notificationDispatcher.firstWhere((e) => e.name == name);
    return dispatcher.enabled;
  }

  void _setNotificationServiceSettingVisibility() {
    setState(() {
      _ntfyVisible = _isNotificationDispatcherActiveAndEnabled("NTFY");
      _gotifyVisible = _isNotificationDispatcherActiveAndEnabled("GOTIFY");
    });
  }

  @override
  void initState() {
    super.initState();
    _setNotificationServiceSettingVisibility();
    Provider.of<NotifyConfNotifier>(context, listen: false).addListener(() {
      _setNotificationServiceSettingVisibility();
    });
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
                  final dynamic isUpdated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(
                        env: widget.env,
                      ),
                    ),
                  );
                  if (isUpdated is bool && isUpdated) {
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
              SettingsInternalLink(
                title: AppLocalizations.of(context).changeLanguage,
                onClick: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeLanguagePage(
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
            title: AppLocalizations.of(context).server,
            children: [
              SettingsInternalLink(
                title: AppLocalizations.of(context).serverURL,
                onClick: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeServerPage(
                      env: widget.env,
                    ),
                  ),
                ), //
              ),
              SettingsInternalLink(
                title: AppLocalizations.of(context).notifications,
                onClick: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotificationsPage(
                      env: widget.env,
                    ),
                  ),
                ),
              ),
              if (_ntfyVisible)
                SettingsInternalLink(
                  title: AppLocalizations.of(context).ntfySettings,
                  onClick: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NtfySettingsPage(
                        env: widget.env,
                      ),
                    ),
                  ),
                ),
              if (_gotifyVisible)
                SettingsInternalLink(
                  title: AppLocalizations.of(context).gotifySettings,
                  onClick: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GotifySettingsPage(
                        env: widget.env,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SettingsSection(
            title: AppLocalizations.of(context).supportTheProject,
            children: [
              SettingsExternalLink(
                title: AppLocalizations.of(context).buyMeACoffee,
                url: "https://www.buymeacoffee.com/mdeluise",
              ),
            ],
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
                url: "https://docs.plant-it.org/latest",
              ),
              SettingsExternalLink(
                title: AppLocalizations.of(context).openSource,
                url: "https://github.com/MDeLuise/plant-it",
              ),
              SettingsExternalLink(
                title: AppLocalizations.of(context).reportIssue,
                url: "https://github.com/MDeLuise/plant-it/issues/new/choose",
              ),
              SettingsInternalLink(
                title: AppLocalizations.of(context).appLog,
                onClick: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TalkerScreen(
                      talker:
                          (widget.env.logger as my_logger.TalkerLogger).talker,
                      appBarTitle: AppLocalizations.of(context).appLog,
                      theme: TalkerScreenTheme(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                ),
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
