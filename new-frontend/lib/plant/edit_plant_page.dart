import 'package:currency_textfield/currency_textfield.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/database/database.dart';
import 'package:flutter/src/widgets/image.dart' as flutter_image;
import 'package:plant_it/environment.dart';
import 'package:plant_it/loading_button.dart';

class EditPlantPage extends StatefulWidget {
  final Environment env;
  final Plant plant;

  const EditPlantPage(this.env, this.plant, {super.key});

  @override
  State<EditPlantPage> createState() => _EditPlantPageState();
}

class _EditPlantPageState extends State<EditPlantPage> {
  final TextEditingController _nameController = TextEditingController();
  final CurrencyTextFieldController _priceController =
      CurrencyTextFieldController(
    decimalSymbol: ",",
    thousandSymbol: ".",
    enableNegative: false,
    forceCursorToEnd: false,
  );
  final TextEditingController _sellerController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime? _purchasedDate;
  bool _hasPurchasedDate = true;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.plant.name;

    if (widget.plant.note != null) {
      _noteController.text = widget.plant.note!;
    }

    _hasPurchasedDate = widget.plant.startDate != null;
    if (widget.plant.startDate != null) {
      _purchasedDate = widget.plant.startDate;
    }
    // other...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0,
                floating: false,
                pinned: true,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: flutter_image.Image.asset(
                    "assets/images/generic-plant.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Collapsable(
                    "General",
                    [
                      _buildTextField("Name", _nameController),
                      _buildMultilineTextField("Note", _noteController),
                      _buildTextField("Location", _locationController),
                    ],
                    expandedAtStart: true,
                  ),
                  Collapsable(
                    "Purchased",
                    [
                      _buildDateField(),
                      _buildNumberField("Price", _priceController),
                      _buildTextField("Seller", _sellerController),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: LoadingButton(
                      'Update Plant',
                      _updatePlant,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              )),
            ],
          ),
          Positioned(
            top: 45,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Theme.of(context).colorScheme.surfaceBright,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.shadow,
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ]),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          TextField(
            controller: controller,
          ),
        ],
      ),
    );
  }

  Widget _buildNumberField(
      String label, CurrencyTextFieldController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
    );
  }

  Widget _buildMultilineTextField(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          TextField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Checkbox(
            value: _hasPurchasedDate,
            onChanged: (value) {
              setState(() {
                _hasPurchasedDate = value ?? false;
                if (!_hasPurchasedDate) _purchasedDate = null;
              });
            },
          ),
          const Text("Purchased Date"),
          if (_hasPurchasedDate)
            TextButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.surface),
                  foregroundColor:
                      WidgetStatePropertyAll(Theme.of(context).primaryColor)),
              onPressed: _pickDate,
              child: Text(
                _purchasedDate != null
                    ? DateFormat.yMMMd().format(_purchasedDate!)
                    : "Select Date",
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _purchasedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _purchasedDate = pickedDate;
      });
    }
  }

  void _updatePlant() async {
    final Plant toSave = widget.plant.copyWith(
      name: _nameController.text,
      note: drift.Value.absentIfNull(_noteController.text),
      startDate: drift.Value(_hasPurchasedDate ? _purchasedDate : null),
    );
    try {
      await widget.env.plantRepository.update(toSave);
    } catch (e) {
      showSnackbar(context, FeedbackLevel.error, "Error updating plant", null);
      return;
    }
    Navigator.of(context).pop(toSave);
    showSnackbar(
        context, FeedbackLevel.success, "Plant updated successfully", null);
  }
}

class Collapsable extends StatefulWidget {
  final List<Widget> children;
  final String title;
  final bool? expandedAtStart;

  const Collapsable(this.title, this.children,
      {super.key, this.expandedAtStart});

  @override
  State<Collapsable> createState() => _CollapsableState();
}

class _CollapsableState extends State<Collapsable> {
  bool _isExpanded = false;

  void _toggleCollapse() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.expandedAtStart != null) {
      _isExpanded = widget.expandedAtStart!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                )),
            trailing: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
            onTap: _toggleCollapse,
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 100),
            firstChild: Container(),
            secondChild: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.children),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          ),
        ],
      ),
    );
  }
}
