import 'dart:convert';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:material_loading_buttons/material_loading_buttons.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/notify_conf_notifier.dart';
import 'package:plant_it/toast/toast_manager.dart';
import 'package:provider/provider.dart';

class ChangeNotificationsPage extends StatefulWidget {
  final Environment env;

  const ChangeNotificationsPage({
    super.key,
    required this.env,
  });

  @override
  State<StatefulWidget> createState() => _ChangeNotificationsPageState();
}

class _ChangeNotificationsPageState extends State<ChangeNotificationsPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  List<String> _updatedNotificationDispatchers = [];

  void _updateNotificationDispatchers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await widget.env.http
          .putList("notification-dispatcher", _updatedNotificationDispatchers);
      if (response.statusCode != 200) {
        final responseBody = json.decode(response.body);
        widget.env.logger.error(responseBody["message"]);
        throw AppException(responseBody["message"]);
      }
      widget.env.logger.info("Notification dispatchers correctly updated");
      if (!mounted) return;
      await fetchAndSetNotificationDispatchers(context, widget.env);
      if (!mounted) return;
      widget.env.toastManager.showToast(context, ToastNotificationType.success,
          AppLocalizations.of(context).notificationUpdated);
      Provider.of<NotifyConfNotifier>(context, listen: false).notify();
      Navigator.of(context).pop();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _updatedNotificationDispatchers = widget.env.notificationDispatcher
        .where((element) => element.enabled)
        .map((n) => n.name)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).changeNotifications),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        widget.env.notificationDispatcher.map((dispatcher) {
                      return CheckboxListTile(
                        title: Text(
                          dispatcher.name.toLowerCase(),
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        value: _updatedNotificationDispatchers
                            .contains(dispatcher.name),
                        onChanged: (value) {
                          if (value == null) return;
                          if (value) {
                            _updatedNotificationDispatchers
                                .add(dispatcher.name);
                          } else {
                            _updatedNotificationDispatchers
                                .remove(dispatcher.name);
                          }
                          setState(() {});
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  ElevatedLoadingButton(
                    onPressed: _updateNotificationDispatchers,
                    isLoading: _isLoading,
                    child:
                        Text(AppLocalizations.of(context).updateNotifications),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
