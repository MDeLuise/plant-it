import 'package:flutter/material.dart';
import 'package:plant_it/gallery_package/app_cached_network_image.dart';

import 'gallery_item_model.dart';

// to show image in Row
class GalleryItemThumbnail extends StatelessWidget {
  final GalleryItemModel galleryItem;
  final GestureTapCallback? onTap;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final double radius;
  final Map<String, String>? headers;

  const GalleryItemThumbnail({
    super.key,
    required this.galleryItem,
    required this.onTap,
    required this.radius,
    required this.loadingWidget,
    required this.errorWidget,
    required this.headers,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: galleryItem.id,
        child: AppCachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: galleryItem.imageUrl,
          headers: headers,
          loadingWidget: loadingWidget,
          errorWidget: errorWidget,
          radius: radius,
        ),
      ),
    );
  }
}
