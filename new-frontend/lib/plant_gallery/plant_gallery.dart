import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:plant_it/plant_gallery/fullscreen_gallery_viewer.dart';
import 'package:plant_it/database/database.dart' as db_image;
import 'package:plant_it/repositories/image_repository.dart';

class PlantGallery extends StatefulWidget {
  final List<db_image.Image> images;
  final int maxThumbnails;
  final bool allowUpload;
  final VoidCallback? onUpload;
  final ImageRepository imageRepository;

  const PlantGallery({
    super.key,
    required this.images,
    this.maxThumbnails = 5,
    this.allowUpload = false,
    this.onUpload,
    required this.imageRepository,
  });

  @override
  State<PlantGallery> createState() => _PlantGalleryState();
}

class _PlantGalleryState extends State<PlantGallery> {
  List<String> _base64InitialImages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setInitialImage();
  }

  Future<void> _setInitialImage() async {
    final List<String> newBase64InitialImages = await Future.wait(
      widget.images.map((i) => widget.imageRepository.getBase64(i.id)),
    );
    setState(() {
      _base64InitialImages = newBase64InitialImages;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return Center(child: CircularProgressIndicator());

    final thumbnails = <Widget>[];

    if (widget.allowUpload) {
      thumbnails.add(_UploadThumbnail(onUpload: widget.onUpload));
    }

    final visibleThumbnails = widget.images.take(widget.maxThumbnails).toList();
    final remainingCount = widget.images.length - widget.maxThumbnails;

    for (int i = 0; i < visibleThumbnails.length; i++) {
      final bool isLastVisible =
          i == visibleThumbnails.length - 1 && remainingCount > 0;
      thumbnails.add(_ImageThumbnail(
        base64Image: _base64InitialImages[i],
        overlayText: isLastVisible ? '+$remainingCount' : null,
        onTap: () => _openGalleryViewer(context, widget.images, startIndex: i),
      ));
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: thumbnails,
    );
  }

  void _openGalleryViewer(BuildContext context, List<db_image.Image> images,
      {int startIndex = 0}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FullscreenGalleryViewer(
          images: images,
          initialIndex: startIndex,
          imageRepo: widget.imageRepository,
        ),
      ),
    );
  }
}

class _UploadThumbnail extends StatelessWidget {
  final VoidCallback? onUpload;

  const _UploadThumbnail({this.onUpload});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onUpload,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surfaceBright,
        ),
        child: Icon(Icons.add_a_photo, color: Theme.of(context).primaryColor),
      ),
    );
  }
}

class _ImageThumbnail extends StatelessWidget {
  final String base64Image;
  final String? overlayText;
  final VoidCallback onTap;

  const _ImageThumbnail({
    required this.base64Image,
    this.overlayText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: MemoryImage(base64Decode(base64Image)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (overlayText != null)
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black45,
              ),
              alignment: Alignment.center,
              child: Text(
                overlayText!,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}
