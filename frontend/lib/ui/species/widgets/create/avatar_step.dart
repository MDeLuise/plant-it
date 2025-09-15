import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';
import 'package:plant_it/ui/species/view_models/add_species_viewmodel.dart';

class AvatarStep extends StepSection<AddSpeciesViewModel> {
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(true);
  final ValueNotifier<String?> _selectedAvatarUrl = ValueNotifier(null);
  final ValueNotifier<String?> _ongoingAvatarUrl = ValueNotifier(null);
  final ValueNotifier<XFile?> _selectedAvatarImage = ValueNotifier(null);
  final ValueNotifier<XFile?> _ongoingAvatarImage = ValueNotifier(null);
  final ValueNotifier<int> _avatarOption = ValueNotifier(0);

  AvatarStep({
    super.key,
    required super.viewModel,
    required super.appLocalizations,
  });

  @override
  void cancel() {
    _ongoingAvatarImage.value = _selectedAvatarImage.value;
    _ongoingAvatarUrl.value = _selectedAvatarUrl.value;
  }

  @override
  void confirm() {
    if (_avatarOption.value == 1) {
      viewModel.setAvatarUploaded(File(_ongoingAvatarImage.value!.path));
      _selectedAvatarImage.value = _ongoingAvatarImage.value;
    } else if (_avatarOption.value == 2) {
      viewModel.setAvatarUrl(_ongoingAvatarUrl.value!);
      _selectedAvatarUrl.value = _ongoingAvatarUrl.value;
    }
  }

  @override
  State<StatefulWidget> createState() => _AvatarStep();

  @override
  ValueNotifier<bool> get isValidNotifier => _isValidNotifier;

  @override
  String get title => appLocalizations.avatar;

  @override
  String get value {
    String avatarValue =
        _ongoingAvatarUrl.value ?? _ongoingAvatarImage.value?.name ?? "";
    if (avatarValue.length > 20) {
      avatarValue = "${avatarValue.substring(0, 20)}...";
    }
    return avatarValue;
  }
}

class _AvatarStep extends State<AvatarStep> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _urlController = TextEditingController();
  String radioGroupName = 'avatarGroup';

  Future<void> _uploadNewPhoto() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    widget._ongoingAvatarImage.value = pickedFile;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: AnimatedBuilder(
          animation: widget._avatarOption,
          builder: (context, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(L.of(context).avatar,
                    style: Theme.of(context).textTheme.headlineSmall),
                SizedBox(height: 20),
                Row(
                  children: [
                    Radio<int>(
                      value: 0,
                      groupValue: widget._avatarOption.value,
                      onChanged: (int? newValue) {
                        widget._avatarOption.value = newValue!;
                      },
                    ),
                    Text(L.of(context).noAvatar),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Radio<int>(
                      value: 1,
                      groupValue: widget._avatarOption.value,
                      onChanged: (int? newValue) {
                        widget._avatarOption.value = newValue!;
                      },
                    ),
                    Text(L.of(context).uploadPhoto),
                  ],
                ),
                if (widget._avatarOption.value == 1)
                  Row(
                    children: [
                      TextButton(
                          onPressed: _uploadNewPhoto,
                          child: Text(L.of(context).choosePhoto)),
                      Text(widget._ongoingAvatarImage.value?.name ??
                          L.of(context).noPhoto),
                    ],
                  ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Radio<int>(
                      value: 2,
                      groupValue: widget._avatarOption.value,
                      onChanged: (int? newValue) {
                        widget._avatarOption.value = newValue!;
                      },
                    ),
                    Text(L.of(context).useWebImage),
                  ],
                ),
                if (widget._avatarOption.value == 2)
                  TextField(
                    controller: _urlController,
                    onChanged: (value) {
                      widget._ongoingAvatarUrl.value = value;
                    },
                    decoration: InputDecoration(
                      labelText: L.of(context).url,
                      border: OutlineInputBorder(),
                    ),
                  ),
              ],
            );
          }),
    );
  }
}
