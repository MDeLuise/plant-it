import 'package:plant_it/cache/cache.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/environment.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:plant_it/notification/reminder_notification_service.dart';

class Settings extends StatefulWidget {
  final Environment env;

  const Settings(this.env, {super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Notification"),
            subtitle:
                const Text("Configure when and if notifications are received"),
            leading: const Icon(Icons.notifications),
            onTap: () => navigateTo(context, NotificationSettings(widget.env)),
          ),
          ListTile(
            title: const Text("Database"),
            subtitle: const Text("Import and Export options"),
            leading: const Icon(Icons.storage),
            onTap: () => navigateTo(context, const DatabaseSettings()),
          ),
          // ListTile(
          //   title: const Text("Cache"),
          //   subtitle: const Text("Manage cache"),
          //   leading: const Icon(Icons.cached),
          //   onTap: () => navigateTo(context, CacheSettings(widget.env.cache)),
          // ),
          ListTile(
            title: const Text("About Plant-it"),
            subtitle: const Text("Details about the app"),
            leading: const Icon(Icons.info),
            onTap: () => navigateTo(context, AppInfo(env: widget.env)),
          ),
        ],
      ),
    );
  }
}

class NotificationSettings extends StatefulWidget {
  final Environment env;

  const NotificationSettings(this.env, {super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  late final ReminderNotificationService reminderNotification =
      ReminderNotificationService(widget.env);
  bool notificationsEnabled = true;
  TimeOfDay notificationTime = TimeOfDay(hour: 8, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final notificationsStatus = await widget.env.userSettingRepository
        .getOrDefault('notificationsEnabled', 'false');
    final hour = await widget.env.userSettingRepository
        .getOrDefault('notificationHour', '8');
    final minute = await widget.env.userSettingRepository
        .getOrDefault('notificationMinute', '0');

    setState(() {
      notificationsEnabled = notificationsStatus == 'true';
      notificationTime =
          TimeOfDay(hour: int.parse(hour), minute: int.parse(minute));
    });
  }

  Future<void> _saveSettingsToDB() async {
    widget.env.userSettingRepository
        .put('notificationsEnabled', notificationsEnabled.toString());
    widget.env.userSettingRepository
        .put('notificationHour', notificationTime.hour.toString());
    widget.env.userSettingRepository
        .put('notificationMinute', notificationTime.minute.toString());

    if (notificationsEnabled) {
      await reminderNotification.scheduleReminderCheck();
    }
  }

  Future<void> _selectNotificationTime(BuildContext context) async {
    if (!notificationsEnabled) {
      return;
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: notificationTime,
    );

    if (picked != null && picked != notificationTime) {
      setState(() {
        notificationTime = picked;
      });
      _saveSettingsToDB();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification toggle switch
            SwitchListTile(
              title: Text("Enable Notifications"),
              value: notificationsEnabled,
              onChanged: (e) {
                setState(() {
                  notificationsEnabled = e;
                });
                _saveSettingsToDB();
              },
            ),

            ListTile(
              title: Text("Set Notification Time"),
              subtitle: Text(
                notificationsEnabled
                    ? notificationTime.format(context)
                    : "Notifications are disabled",
              ),
              onTap: notificationsEnabled
                  ? () => _selectNotificationTime(context)
                  : null,
              enabled: notificationsEnabled,
            ),
          ],
        ),
      ),
    );
  }
}

class DatabaseSettings extends StatelessWidget {
  const DatabaseSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Database Settings"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Import Data"),
            leading: const Icon(Icons.file_upload),
            onTap: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Import completed!")),
              );
            },
          ),
          ListTile(
            title: const Text("Export Data"),
            leading: const Icon(Icons.file_download),
            onTap: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Export completed!")),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CacheSettings extends StatelessWidget {
  final Cache cache;

  const CacheSettings(this.cache, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cache Settings"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Clean Cache"),
            leading: const Icon(Icons.cleaning_services),
            onTap: () {
              cache.removeAll();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Cache cleaned!")),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AppInfo extends StatelessWidget {
  final Environment env;
  final String appVersion;

  const AppInfo({super.key, required this.env}) : appVersion = "Loading...";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Info"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: _loadAppVersion(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text("Error loading app version");
                }

                return Text("Version: ${snapshot.data}");
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
