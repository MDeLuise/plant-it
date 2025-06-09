import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/dto/ui_mode_dto.dart';

class ChangeUiModePage extends StatefulWidget {
  final Environment env;

  const ChangeUiModePage({
    super.key,
    required this.env,
  });

  @override
  State<StatefulWidget> createState() => _ChangeUiModePageState();
}



class _ChangeUiModePageState extends State<ChangeUiModePage> {
  UiModeDTO? _selectedUiMode;

  @override
  void initState() {
    super.initState();
    try{
      _selectedUiMode = UiModeDTO.fromString(widget.env.prefs.getString('uimode') ?? 'mobile');
    } catch(e){
      _selectedUiMode = UiModeDTO.fromString('mobile');
    }
  }

  void _updateUI() async {
    widget.env.prefs.setString("uimode", _selectedUiMode.toString());
  }


  @override
  Widget build(BuildContext context) {
    final uiModes = UiMode.values;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).changeUI),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: uiModes.map((uiMode) {
                return RadioListTile(
                  title: Text(
                    uiMode.name,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
                  value: uiMode.name,
                  groupValue: _selectedUiMode.toString(),
                  onChanged: (String? value) {
                    if (value == null) return;
                    setState(() {
                      _selectedUiMode = UiModeDTO.fromString(value);
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedUiMode != null) {
            _updateUI();
          }
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
