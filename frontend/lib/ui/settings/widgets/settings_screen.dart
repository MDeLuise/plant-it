import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
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
                title: L.of(context).errorWithMessage(command.error.toString()),
                label: L.of(context).tryAgain,
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
                        title: Text(L.of(context).eventTypes),
                        subtitle: Text(L.of(context).manageTheEventTypes),
                        leading: Icon(LucideIcons.glass_water),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push(Routes.reminders),
                      child: ListTile(
                        title: Text(L.of(context).reminders),
                        subtitle: Text(L.of(context).manageTheReminders),
                        leading: Icon(LucideIcons.clock),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push(Routes.settingsDataSources,
                          extra: viewModel),
                      child: ListTile(
                        title: Text(L.of(context).dataSources),
                        subtitle: Text(L.of(context).manageTheDataSources),
                        leading: Icon(LucideIcons.text_search),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push(Routes.settingsNotifications,
                          extra: viewModel),
                      child: ListTile(
                        title: Text(L.of(context).notifications),
                        subtitle: Text(L
                            .of(context)
                            .configureWhenAndIfNotificationsAreReceived),
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
                        title: Text(L.of(context).aboutPlantIt),
                        subtitle: Text(L.of(context).detailsAboutTheApp),
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
