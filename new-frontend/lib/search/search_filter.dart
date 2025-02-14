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
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
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

                // Data Source
                const Text("Data Source"),
                MultiDropdown<DataSourceFilterType>(
                  items: widget.availabledataSources.map((d) {
                    return DropdownItem(label: d.name, value: d);
                  }).toList(),
                  controller: dataSourceTypeController,
                  enabled: true,
                  searchEnabled: true,
                  fieldDecoration: FieldDecoration(
                    hintText: "i.e. Custom",
                    showClearIcon: false,
                    suffixIcon: null,
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).dividerColor, width: 1),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  ),
                  dropdownDecoration: DropdownDecoration(
                    maxHeight: 500,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    elevation: 2,
                  ),
                  searchDecoration: const SearchFieldDecoration(
                    searchIcon: Icon(LucideIcons.search),
                  ),
                  chipDecoration: const ChipDecoration(
                      labelStyle: TextStyle(
                    color: Colors.black87,
                  )),
                  validator: (value) {
                    if (dataSourceTypeController.selectedItems.isEmpty) {
                      return 'Please select a data source';
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
