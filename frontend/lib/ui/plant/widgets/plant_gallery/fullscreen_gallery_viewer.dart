import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/image.dart' as flutter_image;
import 'package:plant_it/database/database.dart' as db_image;
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/ui/plant/view_models/plant_view_model.dart';
import 'package:plant_it/utils/stream_code.dart';
import 'package:result_dart/result_dart.dart';

class FullscreenGalleryViewer extends StatefulWidget {
  final PlantViewModel viewModel;
  final int initialIndex;
  final VoidCallback reload;
  final StreamController<StreamCode> streamController;

  const FullscreenGalleryViewer({
    super.key,
    required this.viewModel,
    required this.initialIndex,
    required this.reload,
    required this.streamController,
  });

  @override
  State<FullscreenGalleryViewer> createState() =>
      _FullscreenGalleryViewerState();
}

class _FullscreenGalleryViewerState extends State<FullscreenGalleryViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  db_image.Image get _currentImage =>
      widget.viewModel.galleryImage[_currentIndex];

  Future<void> _downloadImage() async {
    return widget.viewModel.downloadPhoto(_currentImage.id);
  }

  Future<void> _deleteImage() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(L.of(context).deleteImage),
        content: Text(L.of(context).areYouSureYouWantToDeleteThisImage),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(L.of(context).cancel)),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(L.of(context).delete)),
        ],
      ),
    );

    if (confirm == true) {
      await widget.viewModel.deletePhoto.executeWithFuture(_currentImage.id);

      // Check if the current index is the last image
      if (_currentIndex >= widget.viewModel.galleryImage.length - 1) {
        // If it is, go back to the previous image
        if (_currentIndex > 0) {
          _currentIndex--;
        }
      }

      // Update the PageController to the new index
      _pageController.jumpToPage(_currentIndex);

      if (widget.viewModel.galleryImage.isEmpty) {
        Navigator.pop(context, true);
        return;
      }

      setState(() {});
    }
  }

  Future<void> _toggleAvatar() async {
    return widget.viewModel.toggleAvatar
        .executeWithFuture(_currentImage.isAvatar ? null : _currentImage.id);
  }

  Future<void> _showOptionsMenu() async {
    await showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(L.of(context).info),
            onTap: () {
              Navigator.pop(context);
              final image = _currentImage;
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(L.of(context).imageInfo),
                  content: Text(
                    "ID: ${image.id}\n"
                    "Path: ${image.imagePath ?? '-'}\n"
                    "URL: ${image.imageUrl ?? '-'}\n"
                    "Avatar: ${image.isAvatar}\n"
                    "Description: ${image.description ?? '-'}\n",
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(L.of(context).ok))
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: Text(L.of(context).download),
            onTap: () {
              Navigator.pop(context);
              _downloadImage();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: Text(L.of(context).delete),
            onTap: () async {
              Navigator.pop(context);
              await _deleteImage();
            },
          ),
          ListTile(
            leading: _currentImage.isAvatar
                ? const Icon(Icons.star_outline)
                : const Icon(Icons.star),
            title: Text(_currentImage.isAvatar
                ? L.of(context).unsetAsAvatar
                : L.of(context).setAsAvatar),
            onTap: () async {
              await _toggleAvatar();
              widget.streamController.add(StreamCode.editPlant);
              setState(() {});
              Navigator.pop(context, true);
            },
          ),
        ],
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.viewModel.galleryImage.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (context, index) {
              return FutureBuilder<Result<String>>(
                future: widget.viewModel
                    .getBase64(widget.viewModel.galleryImage[index].id),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Center(
                    child: flutter_image.Image.memory(
                      base64Decode(snapshot.data!.getOrThrow()),
                      fit: BoxFit.contain,
                    ),
                  );
                },
              );
            },
          ),
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () async => await _showOptionsMenu(),
            ),
          ),
          Positioned(
            bottom: 40,
            child: Text(
              '${_currentIndex + 1} / ${widget.viewModel.galleryImage.length}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
