class GalleryItemModel {
  GalleryItemModel({
    required this.id,
    required this.imageUrl,
    required this.index,
    required this.backendId,
  });
  // index in list of image
  final int index;
  // id image (image url) to use in hero animation
  final String id;
  // id of the image on the backend side
  final String backendId;
  // image url
  final String imageUrl;
}
