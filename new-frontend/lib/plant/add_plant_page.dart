import 'package:currency_textfield/currency_textfield.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plant_it/database/database.dart';
import 'package:flutter/src/widgets/image.dart' as flutter_image;
import 'package:plant_it/environment.dart';
import 'package:plant_it/loading_button.dart';

class AddPlantPage extends StatefulWidget {
  final Environment env;
  final SpeciesCompanion species;

  const AddPlantPage(this.env, this.species, {super.key});

  @override
  State<AddPlantPage> createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  final ScrollController _scrollController = ScrollController();
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

  DateTime? _purchasedDate = DateTime.now();
  bool _hasPurchasedDate = true;

  @override
  void initState() {
    super.initState();
    widget.env.plantRepository
        .countBySpecies(widget.species.id.value)
        .then((c) {
      String name = widget.species.scientificName.value;
      if (c > 0) {
        name += " $c";
      }
      setState(() => _nameController.text = name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
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
                  'Add Plant',
                  _addPlant,
                ),
              ),
              const SizedBox(height: 16),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildNumberField(
      String label, CurrencyTextFieldController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildMultilineTextField(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
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

  void _addPlant() async {
    if (!widget.species.id.present) {
      // TODO create species and set species id
    }
    try {
      await widget.env.plantRepository.insert(PlantsCompanion(
        name: drift.Value(_nameController.text),
        note: drift.Value.absentIfNull(_noteController.text),
        species: widget.species.id,
        startDate: drift.Value.absentIfNull(_purchasedDate),
        createdAt: drift.Value(DateTime.now()),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding plant')),
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Plant added successfully')),
    );
    Navigator.of(context).pop();
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
                  color: Theme.of(context).colorScheme.primary,
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
