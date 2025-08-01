import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/routing/routes.dart';
import 'package:plant_it/ui/core/ui/error_indicator.dart';
import 'package:plant_it/ui/home/view_models/home_viewmodel.dart';
import 'package:plant_it/ui/home/widgets/carousel.dart';

class HomeScreen extends StatefulWidget {
  final HomeViewModel viewModel;
  const HomeScreen({
    super.key,
    required this.viewModel,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go(Routes.plantWithId(1)),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
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
                    "Error", // AppLocalization.of(context).errorWhileLoadingHome,
                label: "Try again", //AppLocalization.of(context).tryAgain,
                onPressed: widget.viewModel.load.execute,
              );
            }

            return SizedBox(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    child: SearchBar(
                      hintText: "Search your plants",
                      leading: Icon(Icons.search),
                    ),
                  ),
                  Carousel(viewModel: widget.viewModel),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
