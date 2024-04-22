import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter/material.dart';

class AppCachedNetworkImage extends StatelessWidget {
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final double radius;
  final String imageUrl;
  final Map<String, String>? headers;

  const AppCachedNetworkImage({
    super.key,
    required this.imageUrl,
    required this.radius,
    this.loadingWidget,
    this.errorWidget,
    this.fit,
    this.height,
    this.width,
    this.headers,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      child: CachedNetworkImage(
        imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
        height: height,
        width: width,
        fit: fit,
        imageUrl: imageUrl,
        httpHeaders: headers,
        placeholder: (context, url) =>
            loadingWidget ?? const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) =>
            errorWidget ?? const Icon(Icons.error),
      ),
    );
  }
}
