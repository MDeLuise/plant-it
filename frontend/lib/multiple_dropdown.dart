import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class TextFieldWithDropDown extends StatefulWidget {
  final List<String> options;
  final String text;
  final Function(List<String>) onSelectedItemsChanged;

  const TextFieldWithDropDown(
      {super.key,
      required this.options,
      required this.text,
      required this.onSelectedItemsChanged});

  @override
  State<TextFieldWithDropDown> createState() => _TextFieldWithDropDownState();
}

class _TextFieldWithDropDownState extends State<TextFieldWithDropDown> {
  final List<String> _selectedItems = [];
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
                    icon: IconButton(
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
              enabled: false,
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
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
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
          onChanged: (value) {},
          selectedItemBuilder: (context) {
            return widget.options.map(
              (item) {
                return Container(
                  alignment: AlignmentDirectional.center,
                  child: Text(_selectedItems.join(', '),
                      style: const TextStyle(
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                        color: Colors.grey,
                      )),
                );
              },
            ).toList();
          },
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: 50,
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
