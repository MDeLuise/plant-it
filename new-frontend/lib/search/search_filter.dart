import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/loading_button.dart';

enum DataSourceFilterType {
  custom,
  trefle,
  floraCodex;
}

class SearchFilter extends StatefulWidget {
  final Environment env;
  final List<DataSourceFilterType> filteredDataSources;
  final List<DataSourceFilterType> availabledataSources;
  final Function(List<DataSourceFilterType> activityType) callback;

  const SearchFilter(this.env, this.callback, this.availabledataSources,
      this.filteredDataSources,
      {super.key});

  @override
  State<SearchFilter> createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  final _formKey = GlobalKey<FormState>();
  final dataSourceTypeController =
      MultiSelectController<DataSourceFilterType>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dataSourceTypeController
          .selectWhere((p) => widget.filteredDataSources.contains(p.value));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .7,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      'Filters',
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                MultiDropdown<DataSourceFilterType>(
                  items: widget.availabledataSources.map((d) {
                    return DropdownItem(label: d.name, value: d);
                  }).toList(),
                  controller: dataSourceTypeController,
                  enabled: true,
                  searchEnabled: true,
                  chipDecoration: ChipDecoration(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    wrap: true,
                    runSpacing: 2,
                    spacing: 10,
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.surfaceDim),
                  ),
                  fieldDecoration: FieldDecoration(
                    hintText: 'Data Source',
                    prefixIcon: const Icon(LucideIcons.text_search),
                    showClearIcon: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    labelStyle: const TextStyle(color: Colors.black),
                  ),
                  dropdownDecoration: DropdownDecoration(
                    marginTop: 2,
                    maxHeight: 500,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    header: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Select data source from the list',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  dropdownItemDecoration: DropdownItemDecoration(
                    selectedIcon: Icon(Icons.check_box,
                        color: Theme.of(context).colorScheme.surfaceDim),
                    textColor: Colors.black,
                    selectedBackgroundColor:
                        Theme.of(context).colorScheme.primary,
                    selectedTextColor: Colors.black,
                  ),
                  validator: (value) {
                    if (dataSourceTypeController.selectedItems.isEmpty) {
                      return 'Please select adata source';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LoadingButton(
                      'Reset',
                      () {
                        dataSourceTypeController.selectAll();
                        widget.callback(widget.availabledataSources);
                        Navigator.of(context).pop();
                      },
                      width: MediaQuery.of(context).size.width * .4,
                      buttonColor: Theme.of(context)
                          .colorScheme
                          .tertiary
                          .withOpacity(.8),
                    ),
                    LoadingButton(
                      'Apply',
                      () {
                        if (_formKey.currentState!.validate()) {
                          widget.callback(dataSourceTypeController.selectedItems
                              .map((d) => d.value)
                              .toList());
                          Navigator.of(context).pop();
                        }
                      },
                      width: MediaQuery.of(context).size.width * .4,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
