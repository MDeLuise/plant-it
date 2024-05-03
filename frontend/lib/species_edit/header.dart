import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/dto/species_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/image_provider_helper.dart';
import 'package:plant_it/theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EditSpeciesImageHeader extends StatefulWidget {
  final SpeciesDTO species;
  final Environment env;

  const EditSpeciesImageHeader({
    super.key,
    required this.species,
    required this.env,
  });

  @override
  State<EditSpeciesImageHeader> createState() => _EditSpeciesImageHeaderState();
}

class _EditSpeciesImageHeaderState extends State<EditSpeciesImageHeader> {
  bool _loading = true;
  ImageProvider<Object> _imageToDisplay =
      const AssetImage("assets/images/no-image.png");

  @override
  void initState() {
    super.initState();
    _setInitialImage();
  }

  void _setInitialImage() {
    if (widget.species.imageUrl != null) {
      _imageToDisplay = CachedNetworkImageProvider(
        "${widget.env.http.backendUrl}proxy?url=${widget.species.imageUrl}",
        headers: {
          "Key": widget.env.http.key!,
        },
        imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
        errorListener: (p0) {
          _imageToDisplay = const AssetImage("assets/images/no-image.png");
        },
      );
    }
    setState(() {
      _loading = false;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.add_photo_alternate_outlined),
                    title: Text(AppLocalizations.of(context).uploadPhoto),
                    onTap: () {
                      Navigator.of(context).pop();
                      _uploadImage();
                    }),
                ListTile(
                  leading: const Icon(Icons.add_link_outlined),
                  title: Text(AppLocalizations.of(context).linkURL),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showUrlDialog(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  void _showUrlDialog(BuildContext context) {
    String url = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).linkURL),
          content: TextField(
            onChanged: (value) {
              url = value;
            },
            decoration:
                InputDecoration(hintText: AppLocalizations.of(context).url),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context).cancel),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final response = await widget.env.http
                      .get("${widget.env.http.backendUrl}proxy?url=$url");
                  if (response.statusCode == 200) {
                    final imageBytes = response.bodyBytes;
                    widget.species.imageContent = null;
                    widget.species.imageId = null;
                    widget.species.imageUrl = url;
                    setState(() {
                      _loading = true;
                      _imageToDisplay = MemoryImage(imageBytes);
                      _loading = false;
                    });
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  } else {
                    final String errorMsg =
                        'Failed to fetch image, status code: ${response.statusCode}';
                    widget.env.logger.error(errorMsg);
                    throw AppException(errorMsg);
                  }
                } catch (e, st) {
                  widget.env.logger.error('Error fetching image', e, st);
                  throw AppException.withInnerException(e as Exception);
                }
              },
              child: Text(AppLocalizations.of(context).submit),
            ),
          ],
        );
      },
    );
  }

  void _uploadImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    widget.species.imageContentType =
        "image/${pickedImage.name.split(".").last.toLowerCase()}";
    widget.species.imageContent = await pickedImage.readAsBytes();
    widget.species.imageId = null;
    widget.species.imageUrl = null;
    ImageProvider<Object> uploaded = await ImageProviderHelper.getImageProvider(
        pickedImage, widget.env.logger);
    setState(() {
      _loading = true;
      _imageToDisplay = uploaded;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Skeletonizer(
          enabled: _loading,
          effect: skeletonizerEffect,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: _imageToDisplay,
                fit: BoxFit.cover,
                opacity: .3,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.add_photo_alternate_outlined),
              onPressed: () {
                _showPicker(context);
              },
            ),
          ),
        ),
      ],
    );
  }
}
