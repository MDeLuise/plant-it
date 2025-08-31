import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/l10n/app_localizations.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';
import 'package:plant_it/ui/species/view_models/edit_species_viewmodel.dart';

class ClassificationStep extends StepSection<EditSpeciesViewModel> {
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(true);
  late final ValueNotifier<String> _selectedSpecies =
      ValueNotifier(viewModel.species);
  late final ValueNotifier<String> _ongoingSpeciesSelection =
      ValueNotifier(viewModel.species);
  late final ValueNotifier<String?> _selectedFamily =
      ValueNotifier(viewModel.family);
  late final ValueNotifier<String?> _ongoingFamilySelection =
      ValueNotifier(viewModel.family);
  late final ValueNotifier<String?> _selectedGenus =
      ValueNotifier(viewModel.genus);
  late final ValueNotifier<String?> _ongoingGenusSelection =
      ValueNotifier(viewModel.genus);
  late final ValueNotifier<List<String>> _selectedSynonyms =
      ValueNotifier(List.unmodifiable(viewModel.synonyms));
  late final ValueNotifier<List<String>> _ongoingSynonymsSelection =
      ValueNotifier(List.unmodifiable(viewModel.synonyms));

  ClassificationStep({
    super.key,
    required super.viewModel,
  });

  @override
  void cancel() {
    _ongoingFamilySelection.value = _selectedFamily.value;
    _ongoingGenusSelection.value = _selectedGenus.value;
    _ongoingSpeciesSelection.value = _selectedSpecies.value;
    _ongoingSynonymsSelection.value = _selectedSynonyms.value;
  }

  @override
  void confirm() {
    viewModel.setSpecies(_ongoingSpeciesSelection.value);
    _selectedSpecies.value = _ongoingSpeciesSelection.value;
    if (_ongoingFamilySelection.value != null) {
      viewModel.setFamily(_ongoingFamilySelection.value!);
      _selectedFamily.value = _ongoingFamilySelection.value;
    }
    if (_ongoingGenusSelection.value != null) {
      viewModel.setGenus(_ongoingGenusSelection.value!);
      _selectedGenus.value = _ongoingGenusSelection.value;
    }
    if (_ongoingSynonymsSelection.value.isNotEmpty) {
      viewModel.setSynonyms(_ongoingSynonymsSelection.value);
      _selectedSynonyms.value = _ongoingSynonymsSelection.value;
    }
  }

  @override
  State<StatefulWidget> createState() => _ClassificationStep();

  @override
  ValueNotifier<bool> get isValidNotifier => _isValidNotifier;

  @override
  String get title => "Classification";

  @override
  String get value {
    String note = _ongoingSpeciesSelection.value;
    if (note.length > 20) {
      note = "${note.substring(0, 20)}...";
    }
    return note;
  }
}

class _ClassificationStep extends State<ClassificationStep> {
  void _addSpecies(BuildContext context) async {
    final TextEditingController controller = TextEditingController(
        text: widget._ongoingSpeciesSelection.value);
    final String? result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.species,
              border: OutlineInputBorder(),
            ),
            maxLines: null,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        );
      },
    );

    if (result != null) {
      widget._ongoingSpeciesSelection.value = result;
      widget._isValidNotifier.value = result.isNotEmpty;
    }
  }

  void _addGenus(BuildContext context) async {
    final TextEditingController controller =
        TextEditingController(text: widget._ongoingGenusSelection.value ?? "");
    final String? result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.genus,
              border: OutlineInputBorder(),
            ),
            maxLines: null,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        );
      },
    );

    if (result != null) {
      widget._ongoingGenusSelection.value = result;
    }
  }

  void _addFamily(BuildContext context) async {
    final TextEditingController controller =
        TextEditingController(text: widget._ongoingFamilySelection.value ?? "");
    final String? result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.family,
              border: OutlineInputBorder(),
            ),
            maxLines: null,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        );
      },
    );

    if (result != null) {
      widget._ongoingFamilySelection.value = result;
    }
  }

  String getSynonyms() {
    List<String> synonyms = widget._ongoingSynonymsSelection.value;
    if (synonyms.isEmpty) {
      return "";
    }
    if (synonyms.length == 1) {
      String synonym = synonyms.first;
      if (synonym.length > 20) {
        synonym = "${synonym.substring(0, 20)}...";
      }
      return synonym;
    }
    return "${synonyms.length} synonyms";
  }

  void _addSynonym(BuildContext context) async {
    final List<TextEditingController> controllers = widget
        ._ongoingSynonymsSelection.value
        .map((s) => TextEditingController(text: s))
        .toList();

    if (controllers.isEmpty) {
      controllers.add(TextEditingController());
    }

    final String? result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...List.generate(
                    controllers.length,
                    (index) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: controllers[index],
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)!.synonym,
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: null,
                                  autofocus: true,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  if (controllers.length > 1) {
                                    controllers.removeAt(index);
                                    setState(() {});
                                  }
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      );
                    },
                  ),
                  TextButton(
                    child: Text(AppLocalizations.of(context)!.addSynonym),
                    onPressed: () {
                      controllers.add(TextEditingController());
                      setState(() {});
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                String addedSynonyms = controllers.map((c) => c.text).join("|");
                Navigator.of(context).pop(addedSynonyms);
              },
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        );
      },
    );

    if (result != null) {
      widget._ongoingSynonymsSelection.value =
          result.split("|").where((s) => s.isNotEmpty).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.classification,
              style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 20),
          AnimatedBuilder(
            animation: widget._ongoingSpeciesSelection,
            builder: (context, child) {
              return GestureDetector(
                onTap: () => _addSpecies(context),
                child: Card.outlined(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context)!.species),
                        Row(
                          children: [
                            Text(widget._ongoingSpeciesSelection.value),
                            SizedBox(width: 10),
                            Icon(LucideIcons.chevron_right),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
              animation: widget._ongoingGenusSelection,
              builder: (context, child) {
                return GestureDetector(
                  onTap: () => _addGenus(context),
                  child: Card.outlined(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.of(context)!.genus),
                          Row(
                            children: [
                              Text(widget._ongoingGenusSelection.value ?? ""),
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
          AnimatedBuilder(
              animation: widget._ongoingFamilySelection,
              builder: (context, child) {
                return GestureDetector(
                  onTap: () => _addFamily(context),
                  child: Card.outlined(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.of(context)!.family),
                          Row(
                            children: [
                              Text(widget._ongoingFamilySelection.value ?? ""),
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
          AnimatedBuilder(
              animation: widget._ongoingSynonymsSelection,
              builder: (context, child) {
                return GestureDetector(
                  onTap: () => _addSynonym(context),
                  child: Card.outlined(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.of(context)!.synonyms),
                          Row(
                            children: [
                              Text(getSynonyms()),
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
        ],
      ),
    );
  }
}
