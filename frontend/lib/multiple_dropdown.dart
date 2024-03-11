import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class TextFieldWithDropDown extends StatefulWidget {
  final List<String> options;
  final String text;
  const TextFieldWithDropDown(
      {super.key, required this.options, required this.text});

  @override
  State<TextFieldWithDropDown> createState() => _TextFieldWithDropDownState();
}

class _TextFieldWithDropDownState extends State<TextFieldWithDropDown> {
  late final String _text;
  late final List<String> _options;
  final List<String> selectedItems = [];
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    _options = widget.options;
    _text = widget.text;
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          iconStyleData: IconStyleData(
            icon: selectedItems.isEmpty
                ? const Icon(
                    Icons.arrow_drop_down,
                  )
                : IconButton(
                    onPressed: () {
                      setState(() {
                        selectedItems.clear();
                      });
                    },
                    icon: const Icon(Icons.clear),
                    splashRadius: 14,
                    constraints: const BoxConstraints(minWidth: 0),
                    padding: EdgeInsets.zero,
                  ),
            iconSize: 18,
          ),
          isExpanded: true,
          hint: Text(
            _text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          items: _options.map((item) {
            return DropdownMenuItem(
              value: item,
              //disable default onTap to avoid closing menu when selecting an item
              enabled: false,
              child: StatefulBuilder(
                builder: (context, menuSetState) {
                  final isSelected = selectedItems.contains(item);
                  return InkWell(
                    onTap: () {
                      isSelected
                          ? selectedItems.remove(item)
                          : selectedItems.add(item);
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
          value: selectedItems.isEmpty ? null : selectedItems.last,
          onChanged: (value) {},
          selectedItemBuilder: (context) {
            return _options.map(
              (item) {
                return Container(
                  alignment: AlignmentDirectional.center,
                  child: Text(selectedItems.join(', '),
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
            height: 40,
            width: 200,
          ),
          dropdownStyleData: const DropdownStyleData(
            maxHeight: 200,
            decoration: BoxDecoration(
              color: Color.fromRGBO(24, 44, 37, 1),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),
          dropdownSearchData: DropdownSearchData(
            searchController: textEditingController,
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
                controller: textEditingController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  hintText: 'Search...',
                  hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            searchMatchFn: (item, searchValue) {
              return item.value.toString().contains(searchValue);
            },
          ),
          //This to clear the search value when you close the menu
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              textEditingController.clear();
            }
          },
        ),
      ),
    );
  }
}
