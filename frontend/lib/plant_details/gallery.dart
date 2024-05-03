import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/dto/plant_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/gallery_package/galleryimage.dart';

class Gallery extends StatefulWidget {
  final Environment env;
  final PlantDTO plant;
  final Future<bool> Function(BuildContext context, String imageId) removePhoto;
  final Future<bool> Function(String imageId) setAvatar;
  final String? avatarImageId;

  const Gallery({
    super.key,
    required this.env,
    required this.plant,
    required this.removePhoto,
    required this.setAvatar,
    required this.avatarImageId,
  });

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  List<String> _imageUrls = [];
  List<String> _imageIds = [];
  late Future<void> _fetchImagesFuture;

  @override
  void initState() {
    super.initState();
    _fetchImagesFuture = _fetchAndSetImagesUrls();
  }

  Future<void> _fetchAndSetImagesUrls() async {
    try {
      final imageIdsResponse =
          await widget.env.http.get("image/entity/all/${widget.plant.id}");
      if (imageIdsResponse.statusCode != 200) {
        final imageIdsResponseBody = json.decode(imageIdsResponse.body);
        widget.env.logger.error(
            "Error while fetching plant images: ${imageIdsResponseBody["message"]}");
        throw AppException(imageIdsResponseBody["message"]);
      }
      final List<String> responseBody =
          json.decode(imageIdsResponse.body).cast<String>();
      for (var id in responseBody) {
        _imageUrls.add("${widget.env.http.backendUrl}image/content/$id");
        _imageIds.add(id);
      }
    } catch (e, st) {
      widget.env.logger.error(e, st);
      throw AppException.withInnerException(e as Exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _fetchImagesFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return _imageUrls.isEmpty
              ? Text(
                  AppLocalizations.of(context).noImages,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                )
              : GalleryImage(
                  numOfShowImages: min(_imageUrls.length, 3),
                  imageUrls: _imageUrls,
                  imageIds: _imageIds,
                  headers: {"Key": widget.env.http.key!},
                  titleGallery: AppLocalizations.of(context)
                      .photosOf(widget.plant.info.personalName!),
                  removePhoto: (context, imageId) async {
                    final removed = await widget.removePhoto(context, imageId);
                    if (!removed) return false;
                    final index = _imageIds.indexOf(imageId);
                    final newUrls = [..._imageUrls];
                    newUrls.removeAt(index);
                    final newIds = [..._imageIds];
                    newIds.removeAt(index);
                    setState(() {
                      _imageUrls = newUrls;
                      _imageIds = newIds;
                    });
                    return removed;
                  },
                  setAvatar: widget.setAvatar,
                  avatarImageId: widget.avatarImageId,
                );
        }
      },
    );
  }
}
