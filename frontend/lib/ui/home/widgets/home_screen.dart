import 'dart:async';

import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/l10n/app_localizations.dart';
import 'package:plant_it/ui/core/ui/error_indicator.dart';
import 'package:plant_it/ui/home/view_models/home_viewmodel.dart';
import 'package:plant_it/ui/home/widgets/carousel.dart';
import 'package:plant_it/ui/home/widgets/reminder_occurrence_list.dart';
import 'package:plant_it/utils/stream_code.dart';

class HomeScreen extends StatefulWidget {
  final HomeViewModel viewModel;
  final StreamController<StreamCode> streamController;

  const HomeScreen({
    super.key,
    required this.viewModel,
    required this.streamController,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.streamController.stream.listen((_) {
      widget.viewModel.load.execute();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: ValueListenableBuilder<CommandResult<void, void>>(
        valueListenable: widget.viewModel.load.results,
        builder: (context, command, _) {
          if (command.isExecuting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (command.hasError) {
            return ErrorIndicator(
              title:
                  "Error : ${command.error}", // AppLocalization.of(context).errorWhileLoadingHome,
              label: "Try again", //AppLocalization.of(context).tryAgain,
              onPressed: widget.viewModel.load.execute,
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: SearchBar(
                    controller: _searchController,
                    hintText: AppLocalizations.of(context)!.searchYourPlants,
                    leading: const Icon(Icons.search),
                    elevation: WidgetStatePropertyAll(0),
                    padding: const WidgetStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                ),
                Carousel(viewModel: widget.viewModel),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Next actions",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                fontWeight: FontWeight.w500, fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      ReminderOccurrenceList(viewModel: widget.viewModel),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
