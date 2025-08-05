import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/ui/core/ui/error_indicator.dart';
import 'package:plant_it/ui/core/ui/stepper/stepper_step.dart';

class AppStepper<T> extends StatefulWidget {
  final T viewModel;
  final Command<void, void> mainCommand;
  final String actionText;
  final List<StepperStep> steps;
  final Command<void, void> actionCommand;
  final String successText;

  const AppStepper({
    super.key,
    required this.viewModel,
    required this.mainCommand,
    required this.actionText,
    required this.steps,
    required this.actionCommand,
    required this.successText,
  });

  @override
  State<AppStepper> createState() => _Stepper();
}

class _Stepper<T> extends State<AppStepper<T>> {
  int step = 0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CommandResult<void, void>>(
        valueListenable: widget.mainCommand.results,
        builder: (context, command, _) {
          if (command.isExecuting) {
            return Center(child: CircularProgressIndicator());
          }
          if (command.hasError) {
            return ErrorIndicator(
              title:
                  "Error", // AppLocalization.of(context).errorWhileLoadingHome,
              label: "Try again", //AppLocalization.of(context).tryAgain,
              onPressed: widget.mainCommand.execute,
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: (step + 1) / widget.steps.length,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.steps[step],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (step != 0)
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              step = step - 1;
                            });
                          },
                          style: ButtonStyle(
                            side: WidgetStatePropertyAll(BorderSide(
                                color: Theme.of(context).colorScheme.primary)),
                            padding: WidgetStatePropertyAll(
                                EdgeInsetsGeometry.symmetric(
                                    vertical: 15, horizontal: 40)),
                          ),
                          child: Text("Back"),
                        ),
                      ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ValueListenableBuilder<bool>(
                          valueListenable: widget.steps[step].isValidNotifier,
                          builder: (context, isValid, _) {
                            if (step + 1 != widget.steps.length) {
                              return TextButton(
                                onPressed: isValid
                                    ? () {
                                        setState(() {
                                          step = step + 1;
                                        });
                                      }
                                    : null,
                                style: isValid
                                    ? ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                            Theme.of(context)
                                                .colorScheme
                                                .primary),
                                        padding: WidgetStatePropertyAll(
                                            EdgeInsetsGeometry.symmetric(
                                                vertical: 15, horizontal: 40)),
                                      )
                                    : null,
                                child: Text(
                                  "Next",
                                  style: isValid
                                      ? TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        )
                                      : null,
                                ),
                              );
                            }
                            return TextButton(
                              onPressed: isValid
                                  ? () async {
                                      await widget.actionCommand
                                          .executeWithFuture();
                                      if (widget.actionCommand.results.value
                                          .hasError) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(widget
                                                    .actionCommand.errors
                                                    .toString())),
                                          );
                                        }
                                      } else {
                                        if (context.mounted) {
                                          context.pop();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content:
                                                    Text(widget.successText)),
                                          );
                                        }
                                      }
                                    }
                                  : null,
                              style: isValid
                                  ? ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                          Theme.of(context)
                                              .colorScheme
                                              .primary),
                                      padding: WidgetStatePropertyAll(
                                          EdgeInsetsGeometry.symmetric(
                                              vertical: 15, horizontal: 40)),
                                    )
                                  : null,
                              child: Text(
                                widget.actionText,
                                style: isValid
                                    ? TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      )
                                    : null,
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }
}
