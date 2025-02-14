import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/image.dart' as flutter_image;
import 'package:plant_it/database/database.dart' as db_image;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plant_it/repositories/image_repository.dart';

class FullscreenGalleryViewer extends StatefulWidget {
  final List<db_image.Image> images;
  final int initialIndex;
  final ImageRepository imageRepo;

  const FullscreenGalleryViewer({
    super.key,
    required this.images,
    required this.initialIndex,
    required this.imageRepo,
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

  db_image.Image get _currentImage => widget.images[_currentIndex];

  Future<void> _downloadImage() async {
    final bytes =
        base64Decode(await widget.imageRepo.getBase64(_currentImage.id));

    if (await Permission.storage.request().isGranted) {
      final dir = await getExternalStorageDirectory();
      final downloads = Directory("${dir!.path}/Download");
      if (!await downloads.exists()) await downloads.create(recursive: true);

      final file = File('${downloads.path}/${_currentImage.id}.jpg');
      await file.writeAsBytes(bytes);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image downloaded successfully.')),
      );
    }
  }

  Future<void> _deleteImage() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Image"),
        content: const Text("Are you sure you want to delete this image?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete")),
        ],
      ),
    );

    if (confirm == true) {
      if (_currentImage.imagePath != null) {
        await widget.imageRepo.removeImageFile(_currentImage.imagePath!);
      }
      widget.imageRepo.delete(_currentImage.id);
      setState(() => widget.images.removeAt(_currentIndex));
      if (widget.images.isEmpty) Navigator.pop(context);
    }
  }

  Future<void> _toggleAvatar() async {
    final image = _currentImage;
    if (image.plantId != null) {
      await widget.imageRepo.unsetAvatarForPlant(image.plantId!);
    }
    if (image.speciesId != null) {
      await widget.imageRepo.removeAvatarForSpecies(image.speciesId!);
    }
    await widget.imageRepo.update(image.copyWith(isAvatar: !image.isAvatar));
    setState(() => widget.images[_currentIndex] =
        image.copyWith(isAvatar: !image.isAvatar));
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("Info"),
            onTap: () {
              Navigator.pop(context);
              final image = _currentImage;
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Image Info"),
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
                        child: const Text("OK"))
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text("Download"),
            onTap: () {
              Navigator.pop(context);
              _downloadImage();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text("Delete"),
            onTap: () {
              Navigator.pop(context);
              _deleteImage();
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: Text(
                _currentImage.isAvatar ? "Unset as Avatar" : "Set as Avatar"),
            onTap: () {
              Navigator.pop(context);
              _toggleAvatar();
            },
          ),
        ],
      ),
    );
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
            itemCount: widget.images.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (context, index) {
              return FutureBuilder<String>(
                future: widget.imageRepo.getBase64(widget.images[index].id),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Center(
                    child: flutter_image.Image.memory(
                      base64Decode(snapshot.data!),
                      fit: BoxFit.contain,
                    ),
                  );
                },
              );
            },
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: _showOptionsMenu,
            ),
          ),
          Positioned(
            bottom: 40,
            child: Text(
              '${_currentIndex + 1} / ${widget.images.length}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
