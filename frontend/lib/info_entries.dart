import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/dto/reminder_dto.dart';
import 'package:plant_it/theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

List<Skeletonizer> generateSkeleton(int num, bool enabled) {
  final List<Skeletonizer> result = [];
  for (var i = 0; i < num; i++) {
    result.add(Skeletonizer(
      effect: skeletonizerEffect,
      enabled: enabled,
      child: SimpleInfoEntry(title: "foo" * (i + 1), value: "bar" * (num - i)),
    ));
  }
  return result;
}

abstract class InfoEntry {
  bool isNull();
}

class InfoGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  const InfoGroup({
    super.key,
    required this.title,
    required this.children,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    bool allNull = true;
    for (var child in children) {
      if (child is! InfoEntry) {
        allNull = false;
        break;
      } else if (!((child as InfoEntry).isNull())) {
        allNull = false;
        break;
      }
    }

    return Padding(
      padding: padding ?? const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          if (allNull)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context).noInfoAvailable,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ...children,
        ],
      ),
    );
  }
}

class SwitchInfoEntry extends StatelessWidget implements InfoEntry {
  final String title;
  final bool value;

  const SwitchInfoEntry({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Row(
        children: [
          Text(title),
          const Spacer(),
          Checkbox(
            value: value,
            onChanged: null,
          ),
        ],
      ),
    );
  }

  @override
  bool isNull() {
    return false;
  }
}

class SimpleInfoEntry extends StatelessWidget implements InfoEntry {
  final String title;
  final String? value;

  const SimpleInfoEntry({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  bool isNull() {
    return value == null || value == "null";
  }

  @override
  Widget build(BuildContext context) {
    return value == null || value == "null"
        ? const SizedBox(
            height: null,
            width: null,
          )
        : Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Row(
              children: [
                Text(title),
                const Spacer(),
                Text(value!),
              ],
            ),
          );
  }
}

class FullWidthInfoEntry extends StatelessWidget implements InfoEntry {
  final String title;
  final String? value;

  const FullWidthInfoEntry({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  bool isNull() {
    return value == null || value == "null";
  }

  @override
  Widget build(BuildContext context) {
    return value == null || value == "null"
        ? const SizedBox(
            height: null,
            width: null,
          )
        : Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: value == null || value == "null"
                  ? []
                  : [
                      Text(title),
                      const SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(24, 44, 37, 1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: Text(value!)),
                      ),
                    ],
            ),
          );
  }
}

class EditableSimpleInfoEntry extends SimpleInfoEntry {
  final bool onlyNumber;
  final bool numberDecimal;
  final bool numberSigned;
  final Function(String)? onChanged;

  const EditableSimpleInfoEntry({
    super.key,
    required String title,
    String? value,
    this.onChanged,
    this.onlyNumber = false,
    this.numberDecimal = true,
    this.numberSigned = false,
  }) : super(title: title, value: value);

  @override
  bool isNull() {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onChanged: onChanged,
            initialValue: value == "null" ? null : value,
            keyboardType: !onlyNumber
                ? null
                : TextInputType.numberWithOptions(
                    decimal: numberDecimal,
                    signed: numberSigned,
                  ),
          ),
        ],
      ),
    );
  }
}

class EditableSwitchInfoEntry extends StatefulWidget implements InfoEntry {
  final String title;
  final bool value;
  final Function(bool) onChanged;

  const EditableSwitchInfoEntry({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  bool isNull() {
    return false;
  }

  @override
  State<StatefulWidget> createState() => _EditableSwitchInfoEntryState();
}

class _EditableSwitchInfoEntryState extends State<EditableSwitchInfoEntry> {
  late bool _state;

  @override
  void initState() {
    super.initState();
    _state = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Row(
        children: [
          Text(widget.title),
          const Spacer(),
          Checkbox(
            value: _state,
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _state = val;
                });
                widget.onChanged(val);
              }
            },
          ),
        ],
      ),
    );
  }
}

class EditableOptionsInfoEntry extends StatefulWidget implements InfoEntry {
  final String text;
  final String? initialValue;
  final List<String> values;
  final Function(String) onChanged;

  const EditableOptionsInfoEntry({
    super.key,
    required this.initialValue,
    required this.values,
    required this.onChanged,
    required this.text,
  });

  @override
  bool isNull() {
    return false;
  }

  @override
  State<StatefulWidget> createState() => _EditableOptionsInfoEntryState();
}

class _EditableOptionsInfoEntryState extends State<EditableOptionsInfoEntry> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selected,
      hint: Text(widget.text),
      icon: const Icon(Icons.arrow_downward_outlined),
      elevation: 16,
      onChanged: (val) {
        if (val != null) {
          setState(() {
            _selected = val;
          });
          widget.onChanged(val);
        }
      },
      items: widget.values
          .map((e) => DropdownMenuItem<String>(
                value: e,
                child: Text(e),
              ))
          .toList(),
    );
  }
}

class EditableFullWidthInfoEntry extends StatefulWidget implements InfoEntry {
  final String title;
  final String? value;
  final Function(String) onChanged;

  const EditableFullWidthInfoEntry({
    super.key,
    required this.value,
    required this.title,
    required this.onChanged,
  });

  @override
  State<StatefulWidget> createState() => _EditableFullWidthInfoEntryState();

  @override
  bool isNull() {
    return false;
  }
}

class _EditableFullWidthInfoEntryState
    extends State<EditableFullWidthInfoEntry> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                widget.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
          TextField(
            maxLines: 5,
            onChanged: widget.onChanged,
            controller: _textEditingController,
          )
        ],
      ),
    );
  }
}

class EditableDateInfoEntry extends StatefulWidget implements InfoEntry {
  final DateTime? value;
  final Function(DateTime?) onChange;
  final String title;
  final String emptyHint;

  const EditableDateInfoEntry({
    super.key,
    this.value,
    required this.onChange,
    required this.title,
    required this.emptyHint,
  });

  @override
  State<EditableDateInfoEntry> createState() => _EditableDateInfoEntryState();

  @override
  bool isNull() => value == null;
}

class _EditableDateInfoEntryState extends State<EditableDateInfoEntry> {
  DateTime? _selectedDate;
  late DateTime _lastSelectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.value;
    _lastSelectedDate = widget.value ?? DateTime.now();
  }

  void _handleDateChange(DateTime? newDate) {
    setState(() {
      _selectedDate = newDate;
      if (newDate != null) {
        _lastSelectedDate = newDate;
      }
    });
    widget.onChange(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF6DD075).withOpacity(0.5)),
              borderRadius: BorderRadius.circular(4.0),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Checkbox(
                  value: _selectedDate != null,
                  onChanged: _setCheckboxState,
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: InkWell(
                    onTap: _selectedDate == null ? null : _selectDate,
                    child: Text(
                      _selectedDate == null
                          ? widget.emptyHint
                          : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _setCheckboxState(bool? newValue) {
    if (newValue == null) {
      return;
    }
    if (newValue) {
      _selectedDate ??= _lastSelectedDate;
      widget.onChange(_selectedDate);
    } else {
      _selectedDate = null;
      widget.onChange(null);
    }
    setState(() {});
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      _handleDateChange(pickedDate);
    }
  }
}

class EditableCurrencyInfoEntry extends StatefulWidget implements InfoEntry {
  final double? value;
  final String? currency;
  final Function(double?) onChangeValue;
  final Function(String?) onChangeCurrency;
  final String title;

  const EditableCurrencyInfoEntry({
    super.key,
    required this.value,
    required this.onChangeValue,
    required this.onChangeCurrency,
    required this.title,
    required this.currency,
  });

  @override
  State<EditableCurrencyInfoEntry> createState() =>
      _EditableCurrencyInfoEntryState();

  @override
  bool isNull() => false;
}

class _EditableCurrencyInfoEntryState extends State<EditableCurrencyInfoEntry> {
  String? _selectedCurrency;

  @override
  void initState() {
    super.initState();
    _selectedCurrency = widget.currency ?? currencySymbols.elementAt(0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF6DD075).withOpacity(0.5)),
              borderRadius: BorderRadius.circular(4.0),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: _selectedCurrency,
                  onChanged: _handleValueChange,
                  items: currencySymbols.map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value.toString(),
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextFormField(
                    initialValue: widget.value?.toString(),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: _handleTextChange,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: AppLocalizations.of(context).insertPrice,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleValueChange(String? newValue) {
    setState(() {
      _selectedCurrency = newValue;
    });
    widget.onChangeCurrency(newValue);
  }

  void _handleTextChange(String newValue) {
    if (newValue == "") {
      widget.onChangeValue(null);
    }
    final double? parsedValue = double.tryParse(newValue);
    if (parsedValue != null) {
      widget.onChangeValue(parsedValue);
    }
  }
}

class EditableAvatarMode extends StatefulWidget implements InfoEntry {
  final String mode;
  final Function(String) onChangeValue;
  final String title;

  const EditableAvatarMode({
    super.key,
    required this.mode,
    required this.onChangeValue,
    required this.title,
  });

  @override
  State<EditableAvatarMode> createState() =>
      _EditableAvatarModeInfoEntryState();

  @override
  bool isNull() => false;
}

class _EditableAvatarModeInfoEntryState extends State<EditableAvatarMode> {
  final List<String> _options = [];
  String? _selectedAvatarMode;

  @override
  void initState() {
    super.initState();
    _selectedAvatarMode = widget.mode;
    _options.addAll({"NONE", "LAST", "RANDOM"});
    if (_selectedAvatarMode == "SPECIFIED") {
      _options.add("SPECIFIED");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF6DD075).withOpacity(0.5)),
              borderRadius: BorderRadius.circular(4.0),
            ),
            width: double.infinity,
            padding: const EdgeInsets.all(10.0),
            child: DropdownButton<String>(
              value: _selectedAvatarMode,
              onChanged: _handleValueChange,
              items: _options.map((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _handleValueChange(String? newValue) {
    if (newValue == null) return;
    setState(() {
      _selectedAvatarMode = newValue;
    });
    widget.onChangeValue(newValue);
  }
}

class EditableFrequencyInfoEntry extends StatefulWidget implements InfoEntry {
  final int? value;
  final Unit? unit;
  final Function(int?) onChangeValue;
  final Function(Unit?) onChangeUnit;
  final String title;

  const EditableFrequencyInfoEntry({
    super.key,
    required this.value,
    required this.onChangeValue,
    required this.onChangeUnit,
    required this.title,
    required this.unit,
  });

  @override
  State<EditableFrequencyInfoEntry> createState() =>
      _EditableFrequencyInfoEntryState();

  @override
  bool isNull() => false;
}

class _EditableFrequencyInfoEntryState
    extends State<EditableFrequencyInfoEntry> {
  Unit? _selectedUnit;

  @override
  void initState() {
    super.initState();
    _selectedUnit = widget.unit ?? Unit.DAYS;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF6DD075).withOpacity(0.5)),
              borderRadius: BorderRadius.circular(4.0),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue:
                        widget.value != null ? widget.value.toString() : "3",
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: false,
                      signed: false,
                    ),
                    onChanged: _handleQuantityChange,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: AppLocalizations.of(context).insertPrice,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                DropdownButton<String>(
                  value: _selectedUnit.toString().split('.').last.toLowerCase(),
                  onChanged: _handleUnitChange,
                  items: Unit.values.map((value) {
                    return DropdownMenuItem<String>(
                      value: value.toString().split('.').last.toLowerCase(),
                      child: Text(
                        value
                            .toString()
                            .toString()
                            .split('.')
                            .last
                            .toLowerCase(),
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Unit _stringToUnit(String unitString) {
    switch (unitString.toLowerCase()) {
      case 'days':
        return Unit.DAYS;
      case 'weeks':
        return Unit.WEEKS;
      case 'months':
        return Unit.MONTHS;
      case 'years':
        return Unit.YEARS;
      default:
        throw Exception('Invalid unit string: $unitString');
    }
  }

  void _handleUnitChange(String? newValue) {
    setState(() {
      _selectedUnit = _stringToUnit(newValue!);
    });
    widget.onChangeUnit(_stringToUnit(newValue!));
  }

  void _handleQuantityChange(String newValue) {
    if (newValue == "") {
      widget.onChangeValue(null);
    }
    final int? parsedValue = int.tryParse(newValue);
    if (parsedValue != null) {
      widget.onChangeValue(parsedValue);
    }
  }
}
