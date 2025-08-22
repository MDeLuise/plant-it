import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/routing/routes.dart';
import 'package:plant_it/ui/core/ui/error_indicator.dart';
import 'package:plant_it/ui/settings/view_models/settings_viewmodel.dart';
import 'package:plant_it/ui/settings/widgets/support_banner.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsViewModel viewModel;

  const SettingsScreen({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ValueListenableBuilder<CommandResult<void, void>>(
          valueListenable: viewModel.load.results,
          builder: (context, command, _) {
            if (command.isExecuting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (command.hasError) {
              return ErrorIndicator(
                title:
                    "Error", // AppLocalization.of(context).errorWhileLoadingHome,
                label: "Try again", //AppLocalization.of(context).tryAgain,
                onPressed: viewModel.load.execute,
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Column(
                  children: [
                    SupportBanner(),
                    GestureDetector(
                      onTap: () => context.push(Routes.eventTypes),
                      child: ListTile(
                        title: Text("Event Types"),
                        subtitle: Text("Manage the event types"),
                        leading: Icon(LucideIcons.glass_water),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push(Routes.reminders),
                      child: ListTile(
                        title: Text("Reminders"),
                        subtitle: Text("Manage the reminders"),
                        leading: Icon(LucideIcons.clock),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push(Routes.settingsDataSources, extra: viewModel),
                      child: ListTile(
                        title: Text("Data Sources"),
                        subtitle: Text("Manage the data sources"),
                        leading: Icon(LucideIcons.text_search),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push(Routes.settingsNotifications,
                          extra: viewModel),
                      child: ListTile(
                        title: Text("Notification"),
                        subtitle: Text(
                            "Configure when and if notifications are received"),
                        leading: Icon(LucideIcons.bell),
                      ),
                    ),
                    // ListTile(
                    //   title: Text("Theme"),
                    //   subtitle: Text("Theme options"),
                    //   leading: Icon(LucideIcons.palette),
                    // ),
                    GestureDetector(
                      onTap: () => context.push(Routes.settingsInfo),
                      child: ListTile(
                        title: Text("About Plant-it"),
                        subtitle: Text("Details about the app"),
                        leading: Icon(LucideIcons.info),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
