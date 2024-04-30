import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class TextFieldMultipleDropDown extends StatefulWidget {
  final List<String> options;
  final String text;
  final Function(List<String>) onSelectedItemsChanged;
  final List<String>? initialValues;
  final bool? disabled;

  const TextFieldMultipleDropDown({
    super.key,
    required this.options,
    required this.text,
    required this.onSelectedItemsChanged,
    this.initialValues,
    this.disabled,
  });

  @override
  State<TextFieldMultipleDropDown> createState() =>
      _TextFieldMultipleDropDownState();
}

class _TextFieldMultipleDropDownState extends State<TextFieldMultipleDropDown> {
  final List<String> _selectedItems = [];
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialValues != null) {
      _selectedItems.addAll(widget.initialValues!);
      widget.onSelectedItemsChanged(_selectedItems);
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          iconStyleData: IconStyleData(
            icon: _selectedItems.isEmpty
                ? const Icon(
                    Icons.arrow_drop_down,
                  )
                : IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedItems.clear();
                      });
                    },
                    icon: widget.disabled ?? false
                        ? const SizedBox()
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _selectedItems.clear();
                              });
                              _textEditingController.clear();
                              widget.onSelectedItemsChanged([]);
                            }),
                    splashRadius: 14,
                    constraints: const BoxConstraints(minWidth: 0),
                    padding: EdgeInsets.zero,
                  ),
            iconSize: 18,
          ),
          isExpanded: true,
          hint: Text(
            widget.text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          items: widget.options.map((item) {
            return DropdownMenuItem(
              value: item,
              //disable default onTap to avoid closing menu when selecting an item
              enabled: !(widget.disabled ?? true),
              child: StatefulBuilder(
                builder: (context, menuSetState) {
                  final isSelected = _selectedItems.contains(item);
                  return InkWell(
                    onTap: () {
                      isSelected
                          ? _selectedItems.remove(item)
                          : _selectedItems.add(item);
                      widget.onSelectedItemsChanged(_selectedItems);
                      //This rebuilds the StatefulWidget to update the button's text
                      setState(() {});
                      //This rebuilds the dropdownMenu Widget to update the check mark
                      menuSetState(() {});
                    },
                    child: Container(
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                          color: _selectedItems.contains(item)
                              ? const Color.fromRGBO(31, 57, 48, 1)
                              : null),
                      child: Row(
                        children: [
                          if (isSelected)
                            const Icon(Icons.check_box_outlined)
                          else
                            const Icon(Icons.check_box_outline_blank),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context)
                                    .inputDecorationTheme
                                    .hintStyle!
                                    .color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
          value: _selectedItems.isEmpty ? null : _selectedItems.last,
          onChanged: widget.disabled ?? false ? null : (value) {},
          selectedItemBuilder: (context) {
            return widget.options.map(
              (item) {
                return Container(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(_selectedItems.join(', '),
                      style: TextStyle(
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                        color: (widget.disabled ?? false)
                            ? Colors.grey
                            : Theme.of(context).textTheme.bodyLarge!.color,
                      )),
                );
              },
            ).toList();
          },
          buttonStyleData: ButtonStyleData(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context)
                        .inputDecorationTheme
                        .enabledBorder!
                        .borderSide
                        .color),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            //width: 200,
          ),
          dropdownStyleData: const DropdownStyleData(
            maxHeight: 300,
            decoration: BoxDecoration(
              color: Color.fromRGBO(24, 44, 37, 1),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),
          dropdownSearchData: DropdownSearchData(
            searchController: _textEditingController,
            searchInnerWidgetHeight: 50,
            searchInnerWidget: Container(
              height: 50,
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 4,
                right: 8,
                left: 8,
              ),
              child: TextFormField(
                autofocus: true,
                expands: true,
                maxLines: null,
                controller: _textEditingController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  hintText: "${AppLocalizations.of(context).search}...",
                  hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            searchMatchFn: (item, searchValue) {
              return item.value
                  .toString()
                  .toLowerCase()
                  .contains(searchValue.toLowerCase());
            },
          ),
          //This to clear the search value when you close the menu
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              _textEditingController.clear();
            }
          },
        ),
      ),
    );
  }
}

class TextFieldSingleDropDown extends StatefulWidget {
  final List<String> options;
  final String text;
  final Function(String) onSelectedItemsChanged;
  final String? initialValue;
  final bool? disabled;

  const TextFieldSingleDropDown({
    super.key,
    required this.options,
    required this.text,
    required this.onSelectedItemsChanged,
    required this.initialValue,
    this.disabled,
  });

  @override
  State<TextFieldSingleDropDown> createState() =>
      _TextFieldSingleDropDownState();
}

class _TextFieldSingleDropDownState extends State<TextFieldSingleDropDown> {
  String? _selectedValue;

  @override
  void initState() {
    _selectedValue = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Text(
            widget.text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          items: widget.options
              .map((String item) => DropdownMenuItem<String>(
                    enabled: !(widget.disabled ?? false),
                    value: item,
                    child: Container(
                      // decoration: BoxDecoration(
                      //     color: _selectedValue == item
                      //         ? const Color.fromRGBO(31, 57, 48, 1)
                      //         : null),
                      child: Text(
                        item,
                        style: TextStyle(
                            fontSize: 14,
                            color:
                                Theme.of(context).textTheme.bodyLarge!.color),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ))
              .toList(),
          value: _selectedValue,
          onChanged: (String? value) {
            setState(() {
              _selectedValue = value;
            });
            if (value != null) {
              widget.onSelectedItemsChanged(value);
            }
          },
          buttonStyleData: ButtonStyleData(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context)
                        .inputDecorationTheme
                        .enabledBorder!
                        .borderSide
                        .color),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            //width: 200,
          ),
          iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.arrow_drop_down,
              ),
              iconSize: 14,
              iconEnabledColor: Colors.grey),
          dropdownStyleData: const DropdownStyleData(
            maxHeight: 300,
            decoration: BoxDecoration(
              color: Color.fromRGBO(24, 44, 37,
                  1), // this is the color background for all dropdown
            ),
          ),
          menuItemStyleData:
              const MenuItemStyleData(height: 40, padding: EdgeInsets.all(8)),
        ),
      ),
    );
  }
}
