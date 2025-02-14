import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/app_pages.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/environment.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  final Environment env;

  const Settings(this.env, {super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: "Settings",
      noPadding: true,
      child: Column(
        children: [
          ListTile(
            title: const Text("Notification"),
            subtitle: const Text(
                "Configure when and if notifications are received",
                style: TextStyle(color: Colors.grey)),
            leading: const Icon(LucideIcons.bell),
            onTap: () => navigateTo(context, NotificationSettings(widget.env)),
          ),
          ListTile(
            title: const Text("Theme"),
            subtitle: const Text("Theme options",
                style: TextStyle(color: Colors.grey)),
            leading: const Icon(LucideIcons.palette),
            onTap: () => navigateTo(context, ThemeSettings(env: widget.env)),
          ),
          ListTile(
            title: const Text("About Plant-it"),
            subtitle: const Text("Details about the app",
                style: TextStyle(color: Colors.grey)),
            leading: const Icon(LucideIcons.info),
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
  bool notificationsEnabled = true;
  TimeOfDay notificationTime = const TimeOfDay(hour: 8, minute: 0);

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
      await widget.env.reminderNotificationService.scheduleReminderCheck();
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

  Future<void> _sendTestNotification() async {
    if (!notificationsEnabled) {
      return;
    }
    await widget.env.reminderNotificationService.sendTestNotification();
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Notification Settings',
      closeOnBack: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            title: const Text("Enable Notifications"),
            value: notificationsEnabled,
            onChanged: (e) {
              setState(() {
                notificationsEnabled = e;
              });
              _saveSettingsToDB();
            },
          ),
          ListTile(
            title: const Text("Set Notification Time"),
            subtitle: Text(notificationTime.format(context),
                style: const TextStyle(color: Colors.grey)),
            onTap: notificationsEnabled
                ? () => _selectNotificationTime(context)
                : null,
            enabled: notificationsEnabled,
          ),
          ListTile(
            title: const Text("Send Test Notification"),
            subtitle: Text("Check if notifications work fine",
                style: const TextStyle(color: Colors.grey)),
            onTap: () => _sendTestNotification(),
            enabled: notificationsEnabled,
          ),
        ],
      ),
    );
  }
}

// class DatabaseSettings extends StatelessWidget {
//   const DatabaseSettings({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Database Settings"),
//       ),
//       body: ListView(
//         children: [
//           ListTile(
//             title: const Text("Import Data"),
//             leading: const Icon(Icons.file_upload),
//             onTap: () async {
//               // ScaffoldMessenger.of(context).showSnackBar(
//               //   const SnackBar(content: Text("Import completed!")),
//               // );
//               AlertInfo.show(
//                 context: context,
//                 text: 'Import completed',
//                 typeInfo: TypeInfo.info,
//                 duration: 5,
//                 backgroundColor: Theme.of(context).colorScheme.surface,
//                 textColor: Theme.of(context).colorScheme.onSurface,
//               );
//             },
//           ),
//           ListTile(
//             title: const Text("Export Data"),
//             leading: const Icon(Icons.file_download),
//             onTap: () async {
//               // ScaffoldMessenger.of(context).showSnackBar(
//               //   const SnackBar(content: Text("Export completed!")),
//               // );
//               AlertInfo.show(
//                 context: context,
//                 text: 'Export completed',
//                 typeInfo: TypeInfo.info,
//                 duration: 5,
//                 backgroundColor: Theme.of(context).colorScheme.surface,
//                 textColor: Theme.of(context).colorScheme.onSurface,
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class CacheSettings extends StatelessWidget {
//   final Cache cache;

//   const CacheSettings(this.cache, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Cache Settings"),
//       ),
//       body: ListView(
//         children: [
//           ListTile(
//             title: const Text("Clean Cache"),
//             leading: const Icon(Icons.cleaning_services),
//             onTap: () {
//               cache.removeAll();
//               // ScaffoldMessenger.of(context).showSnackBar(
//               //   const SnackBar(content: Text("Cache cleaned!")),
//               // );
//               AlertInfo.show(
//                 context: context,
//                 text: 'Cache cleaned',
//                 typeInfo: TypeInfo.success,
//                 duration: 5,
//                 backgroundColor: Theme.of(context).colorScheme.surface,
//                 textColor: Theme.of(context).colorScheme.onSurface,
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

class ThemeSettings extends StatefulWidget {
  final Environment env;

  const ThemeSettings({super.key, required this.env});

  @override
  State<ThemeSettings> createState() => _ThemeSettingsState();
}

class _ThemeSettingsState extends State<ThemeSettings> {
  Color _selectedColor = Colors.green;
  Color _holdColor = Colors.green;
  final TextEditingController _colorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadColor();
  }

  Future<void> _loadColor() async {
    final colorString = await widget.env.userSettingRepository
        .getOrDefault('primaryColor', '0xFF4CAF50');
    setState(() {
      _selectedColor = hexToColor(colorString);
      _holdColor = hexToColor(colorString);
    });
  }

  Future<void> _saveColor(Color color) async {
    setState(() {
      _selectedColor = _holdColor;
    });
    widget.env.userSettingRepository.put('primaryColor', _colorController.text);
    widget.env.primaryColor = _holdColor;
  }

  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Pick a color"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (Color color) {
                _holdColor = color;
              },
              labelTypes: const [],
              pickerAreaBorderRadius: BorderRadius.circular(8),
              enableAlpha: false,
              hexInputController: _colorController,
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                _saveColor(_holdColor);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: "Theme Settings",
      closeOnBack: false,
      child: Column(
        children: [
          ListTile(
            title: const Text("Primary Color"),
            subtitle: const Text("Choose your app's accent color"),
            trailing: CircleAvatar(
              backgroundColor: _selectedColor,
              radius: 15,
            ),
            onTap: _openColorPicker,
          ),
        ],
      ),
    );
  }
}

class AppInfo extends StatelessWidget {
  final Environment env;
  final String appVersion;
  final String sourceCodeUrl = "https://github.com/MDeLuise/plant-it";

  const AppInfo({super.key, required this.env}) : appVersion = "Loading...";

  Future<void> _goToSourceCode() async {
    if (!await launchUrl(Uri.parse(sourceCodeUrl))) {
      throw Exception('Could not launch $sourceCodeUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: "App Info",
      closeOnBack: false,
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
                return const Text("Error loading app version");
              }

              return ListTile(
                title: Text("App Version"),
                subtitle: Text(snapshot.data ?? "",
                    style: const TextStyle(color: Colors.grey)),
              );
            },
          ),
          GestureDetector(
            onTap: _goToSourceCode,
            child: ListTile(
              title: Text("Source Code"),
              trailing: GestureDetector(
                onTap: () {},
                child: Icon(Icons.open_in_new),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<String> _loadAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return "${packageInfo.version}+${packageInfo.buildNumber}";
  }
}
