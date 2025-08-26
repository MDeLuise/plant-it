import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/ui/core/ui/error_indicator.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';
import 'package:plant_it/ui/core/ui/summary.dart';

class AppStepper<T> extends StatefulWidget {
  final T viewModel;
  final Command<void, void> mainCommand;
  final String actionText;
  final List<StepSection<T>> steps;
  final Command<void, void> actionCommand;
  final String? successText;
  final bool summary;
  final int stepsInFocus;

  const AppStepper({
    super.key,
    required this.viewModel,
    required this.mainCommand,
    required this.actionText,
    required this.steps,
    required this.actionCommand,
    this.successText,
    bool? summary,
    int? stepsInFocus,
  })  : summary = summary ?? false,
        stepsInFocus = stepsInFocus ?? steps.length,
        assert(
          (stepsInFocus ?? steps.length) <= steps.length,
          'stepsInFocus cannot be greater than steps.length',
        );

  @override
  State<AppStepper> createState() => _Stepper();
}

class _Stepper<T> extends State<AppStepper<T>> {
  int step = 0;
  bool isOnSummary = false;

  @override
  void initState() {
    super.initState();
    if (widget.stepsInFocus == 0) {
      setState(() => isOnSummary = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CommandResult<void, void>>(
        valueListenable: widget.mainCommand.results,
        builder: (ct, command, _) {
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
          return isOnSummary
              ? Summary<T>(
                  viewModel: widget.viewModel,
                  mainCommand: widget.mainCommand,
                  actionText: widget.actionText,
                  sections: widget.steps,
                  actionCommand: widget.actionCommand,
                  isPrimary: false,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: (step + 1) / widget.stepsInFocus,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: widget.steps[step],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
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
                                valueListenable:
                                    widget.steps[step].isValidNotifier,
                                builder: (ct, isValid, _) {
                                  if (step + 1 != widget.steps.length ||
                                      widget.summary) {
                                    return TextButton(
                                      onPressed: isValid
                                          ? () {
                                              if (step + 1 <
                                                  widget.stepsInFocus) {
                                                widget.steps[step].confirm();
                                                setState(() {
                                                  step = step + 1;
                                                });
                                              } else {
                                                widget.steps[step].confirm();
                                                setState(() {
                                                  isOnSummary = true;
                                                });
                                              }
                                            }
                                          : null,
                                      style: isValid
                                          ? ButtonStyle(
                                              backgroundColor:
                                                  WidgetStatePropertyAll(
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primary),
                                              padding: WidgetStatePropertyAll(
                                                  EdgeInsetsGeometry.symmetric(
                                                      vertical: 15,
                                                      horizontal: 40)),
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
                                            if (widget.actionCommand.results
                                                .value.hasError) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(widget
                                                        .actionCommand.errors
                                                        .toString()),
                                                  ),
                                                );
                                              }
                                            } else {
                                              if (context.mounted) {
                                                context.pop(widget.viewModel);
                                                if (widget.successText !=
                                                    null) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(widget
                                                            .successText!)),
                                                  );
                                                }
                                              }
                                            }
                                          }
                                        : null,
                                    style: isValid
                                        ? ButtonStyle(
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary),
                                            padding: WidgetStatePropertyAll(
                                                EdgeInsetsGeometry.symmetric(
                                                    vertical: 15,
                                                    horizontal: 40)),
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
