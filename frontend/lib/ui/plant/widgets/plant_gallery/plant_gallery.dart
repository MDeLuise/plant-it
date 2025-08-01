import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:plant_it/ui/plant/view_models/plant_view_model.dart';
import 'package:plant_it/ui/plant/widgets/plant_gallery/fullscreen_gallery_viewer.dart';

class PlantGallery extends StatefulWidget {
  final PlantViewModel viewModel;
  final bool allowUpload;
  final VoidCallback? onUpload;

  const PlantGallery({
    super.key,
    required this.viewModel,
    this.allowUpload = false,
    this.onUpload,
  });

  @override
  State<PlantGallery> createState() => _PlantGalleryState();
}

class _PlantGalleryState extends State<PlantGallery> {
  @override
  Widget build(BuildContext context) {
    List<Widget> thumbnails = <Widget>[];

    if (widget.allowUpload) {
      thumbnails.add(_UploadThumbnail(onUpload: widget.onUpload));
    }

    List<String> visibleThumbnails = widget.viewModel.thumbnails;
    int remainingCount =
        widget.viewModel.galleryImage.length - visibleThumbnails.length;

    for (int i = 0; i < visibleThumbnails.length; i++) {
      bool isLastVisible =
          i == visibleThumbnails.length - 1 && remainingCount > 0;
      thumbnails.add(_ImageThumbnail(
        base64Image: visibleThumbnails[i],
        overlayText: isLastVisible ? '+$remainingCount' : null,
        onTap: () => _openGalleryViewer(context, startIndex: i),
      ));
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: thumbnails,
    );
  }

  void _openGalleryViewer(BuildContext context, {int startIndex = 0}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FullscreenGalleryViewer(
          viewModel: widget.viewModel,
          initialIndex: startIndex,
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
