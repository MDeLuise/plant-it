import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';

class TextFieldWithDropDown extends StatefulWidget {
  const TextFieldWithDropDown({super.key});

  @override
  State<TextFieldWithDropDown> createState() => _TextFieldWithDropDownState();
}

class _TextFieldWithDropDownState extends State<TextFieldWithDropDown> {
  final TextEditingController _controller = TextEditingController();
  final List<SelectedListItem> cities = [
    SelectedListItem(name: "foo"),
    SelectedListItem(name: "bar"),
    SelectedListItem(name: "alpefd"),
    SelectedListItem(name: "lorem"),
    SelectedListItem(name: "ipsum"),
  ];
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onTap: _openDropDown,
      decoration: InputDecoration(
        hintText: 'Select city',
        suffixIcon: Icon(Icons.arrow_drop_down),
      ),
    );
  }

  void _openDropDown() {
    DropDownState(
      DropDown(
        bottomSheetTitle: const Text(
          'Cities',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        submitButtonChild: const Text(
          'Done',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        data: cities ?? [],
        selectedItems: (List<dynamic> selectedList) {
          List<String> list = [];
          for (var item in selectedList) {
            if (item is SelectedListItem) {
              list.add(item.name);
            }
          }
          setState(() {
            _controller.text = list.map((item) => item).join(', ');
          });
        },
        enableMultipleSelection: true,
      ),
    ).showModal(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
