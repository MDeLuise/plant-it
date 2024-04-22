import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:http/http.dart' as http;

class ImageProviderHelper {
  static Future<ImageProvider<Object>> getImageProvider(
      XFile file, Talker logger) async {
    try {
      final bytes = await file.readAsBytes();
      return MemoryImage(bytes);
    } catch (e, st) {
      logger.error("Error loading image: ", e, st);
      return AssetImage("assets/images/no-image.png");
    }
  }

  static Future<ImageProvider<Object>> getImageBytesFromUrl(
      String imageUrl, Talker logger) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      return MemoryImage(bytes);
    } else {
      logger.error("Error loading image from URL $imageUrl");
      return AssetImage("assets/images/no-image.png");
    }
  }
}
