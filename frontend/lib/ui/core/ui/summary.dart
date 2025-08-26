import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/ui/core/ui/error_indicator.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';

class Summary<T> extends StatefulWidget {
  final T viewModel;
  final Command<void, void> mainCommand;
  final String actionText;
  final List<StepSection<T>> sections;
  final Command<void, void> actionCommand;
  final String? successText;
  final String? mainText;
  final bool isPrimary;

  const Summary({
    super.key,
    required this.viewModel,
    required this.mainCommand,
    required this.actionText,
    required this.sections,
    required this.actionCommand,
    this.mainText,
    this.successText,
    bool? isPrimary,
  }) : isPrimary = isPrimary ?? true;

  @override
  State<Summary> createState() => _Stepper();
}

class _Stepper<T> extends State<Summary<T>> {
  int _focusOn = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isPrimary
          ? AppBar(
              leading: BackButton(
                onPressed: () {
                  if (_focusOn == -1) {
                    context.pop();
                  }
                  widget.sections[_focusOn].cancel();
                  setState(() => _focusOn = -1);
                },
              ),
            )
          : null,
      body: ValueListenableBuilder<CommandResult<void, void>>(
        valueListenable: widget.mainCommand.results,
        builder: (ct, command, _) {
          if (command.isExecuting) {
            return Center(child: CircularProgressIndicator());
          }
          if (command.hasError) {
            return ErrorIndicator(
              title:
                  "Error : ${command.error}", // AppLocalization.of(context).errorWhileLoadingHome,
              label: "Try again", //AppLocalization.of(context).tryAgain,
              onPressed: widget.mainCommand.execute,
            );
          }
          return _focusOn != -1
              ? Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: widget.sections[_focusOn],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                widget.sections[_focusOn].cancel();
                                setState(() {
                                  _focusOn = -1;
                                });
                              },
                              style: ButtonStyle(
                                side: WidgetStatePropertyAll(BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                                padding: WidgetStatePropertyAll(
                                    EdgeInsetsGeometry.symmetric(
                                        vertical: 15, horizontal: 40)),
                              ),
                              child: Text("Cancel"),
                            ),
                          ),
                          SizedBox(width: 10),
                          ValueListenableBuilder(
                              valueListenable:
                                  widget.sections[_focusOn].isValidNotifier,
                              builder: (context, valid, child) {
                                return Expanded(
                                  child: TextButton(
                                      onPressed: () {
                                        widget.sections[_focusOn].confirm();
                                        setState(() => _focusOn = -1);
                                      },
                                      style: valid
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
                                        "Confirm",
                                        style: valid
                                            ? TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                              )
                                            : null,
                                      )),
                                );
                              }),
                        ],
                      ),
                    )
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.mainText != null)
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          widget.mainText!,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    SizedBox(height: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: ListView.builder(
                            itemCount: widget.sections.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () async {
                                  if (widget.sections[index].isActionSection) {
                                    await widget.sections[index]
                                        .action(context, widget.viewModel);
                                    widget.sections[index].confirm();
                                    setState(() {});
                                  } else {
                                    setState(() => _focusOn = index);
                                  }
                                },
                                child: Card.outlined(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(widget.sections[index].title),
                                        Row(
                                          children: [
                                            Text(widget.sections[index].value),
                                            SizedBox(width: 10),
                                            Icon(LucideIcons.chevron_right),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => context.pop(),
                                style: ButtonStyle(
                                  side: WidgetStatePropertyAll(BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                                  padding: WidgetStatePropertyAll(
                                      EdgeInsetsGeometry.symmetric(
                                          vertical: 15, horizontal: 40)),
                                ),
                                child: Text("Cancel"),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextButton(
                                  onPressed: () async {
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
                                                .toString()),
                                          ),
                                        );
                                      }
                                    } else {
                                      if (context.mounted) {
                                        context.pop(widget.viewModel);
                                        if (widget.successText != null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    widget.successText!)),
                                          );
                                        }
                                      }
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    padding: WidgetStatePropertyAll(
                                        EdgeInsetsGeometry.symmetric(
                                            vertical: 15, horizontal: 40)),
                                  ),
                                  child: Text(
                                    widget.actionText,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  )),
                            ),
                          ]),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
