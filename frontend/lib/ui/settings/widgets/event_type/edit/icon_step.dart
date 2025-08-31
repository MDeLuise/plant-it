import 'package:flutter/material.dart';
import 'package:plant_it/l10n/app_localizations.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';
import 'package:plant_it/ui/settings/view_models/event_type/edit_event_type_viewmodel.dart';
import 'package:plant_it/utils/icons.dart';

class IconStep extends StepSection<EditEventTypeViewModel> {
  late final ValueNotifier<String> _selectedIcon = ValueNotifier(viewModel.icon);
  late final ValueNotifier<String> _ongoingSelection = ValueNotifier(viewModel.icon);
  final ValueNotifier<bool> _valid = ValueNotifier(true);

  IconStep({
    super.key,
    required super.viewModel,
  });

  @override
  void cancel() {
    _ongoingSelection.value = _selectedIcon.value;
  }

  @override
  void confirm() {
    viewModel.setIcon(_ongoingSelection.value);
    _selectedIcon.value = _ongoingSelection.value;
  }

  @override
  State<StatefulWidget> createState() => _IconStepState();

  @override
  ValueNotifier<bool> get isValidNotifier => _valid;

  @override
  String get title => "Icon";

  @override
  String get value => _selectedIcon.value;
}

class _IconStepState extends State<IconStep> {
  final TextEditingController _filterController = TextEditingController();
  Iterable<MapEntry<String, IconData>> _iconEntries = Iterable.empty();

  @override
  void initState() {
    super.initState();
    _iconEntries = appIcons.entries;
  }

  void _filterIcons(String name) {
    if (name.isEmpty) {
      setState(() => _iconEntries = appIcons.entries);
    } else {
      setState(() =>
          _iconEntries = appIcons.entries.where((i) => i.key.contains(name)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.whichIconYouWantToUse,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),
        SearchBar(
          controller: _filterController,
          hintText: AppLocalizations.of(context)!.filterIcons,
          leading: const Icon(Icons.search),
          elevation: WidgetStatePropertyAll(0),
          padding: const WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0),
          ),
          onChanged: _filterIcons,
        ),
        const SizedBox(height: 10),
        AnimatedBuilder(
            animation: widget._ongoingSelection,
            builder: (context, _) {
              return Expanded(
                child: SingleChildScrollView(
                  child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 3.7 / 2,
                      children: List.generate(_iconEntries.length, (index) {
                        IconData icon = _iconEntries.elementAt(index).value;
                        String iconName = _iconEntries.elementAt(index).key;
                        bool isSelected =
                            widget._ongoingSelection.value == iconName;
                        return GestureDetector(
                          onTap: () {
                            widget._ongoingSelection.value = iconName;
                            widget._valid.value = true;
                          },
                          child: Card.outlined(
                              shape: isSelected
                                  ? RoundedRectangleBorder(
                                      borderRadius: BorderRadiusGeometry.all(
                                          Radius.circular(15)),
                                      side: isSelected
                                          ? BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              width: 2)
                                          : BorderSide.none,
                                    )
                                  : null,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(icon),
                                    const SizedBox(height: 8),
                                    Text(iconName,
                                        overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              )),
                        );
                      })),
                ),
              );
            }),
      ],
    );
  }
}
