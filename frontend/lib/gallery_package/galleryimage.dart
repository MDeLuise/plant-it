library galleryimage;

import 'package:flutter/material.dart';

import 'gallery_item_model.dart';
import 'gallery_item_thumbnail.dart';
import './gallery_image_view_wrapper.dart';
import './util.dart';

class GalleryImage extends StatefulWidget {
  final List<String> imageUrls;
  final List<String> imageIds;
  final String? titleGallery;
  final int numOfShowImages;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final EdgeInsetsGeometry padding;
  final Color? colorOfNumberWidget;
  final Color galleryBackgroundColor;
  final TextStyle? textStyleOfNumberWidget;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final double minScale;
  final double maxScale;
  final double imageRadius;
  final bool reverse;
  final bool showListInGalley;
  final bool showAppBar;
  final bool closeWhenSwipeUp;
  final bool closeWhenSwipeDown;
  final Map<String, String>? headers;
  final Future<bool> Function(BuildContext context, String imageId) removePhoto;
  final Future<bool> Function(String imageId) setAvatar;
  final String? avatarImageId;

  const GalleryImage({
    Key? key,
    required this.imageUrls,
    required this.imageIds,
    this.titleGallery,
    this.childAspectRatio = 1,
    this.crossAxisCount = 3,
    this.mainAxisSpacing = 5,
    this.crossAxisSpacing = 5,
    this.numOfShowImages = 3,
    this.colorOfNumberWidget,
    this.textStyleOfNumberWidget,
    this.padding = EdgeInsets.zero,
    this.loadingWidget,
    this.errorWidget,
    this.galleryBackgroundColor = Colors.black,
    this.minScale = .5,
    this.maxScale = 10,
    this.imageRadius = 8,
    this.reverse = false,
    this.showListInGalley = true,
    this.showAppBar = true,
    this.closeWhenSwipeUp = false,
    this.closeWhenSwipeDown = false,
    this.headers,
    required this.removePhoto,
    required this.setAvatar,
    required this.avatarImageId,
  })  : assert(numOfShowImages <= imageUrls.length),
        assert(imageIds.length == imageUrls.length),
        super(key: key);
  @override
  State<GalleryImage> createState() => _GalleryImageState();
}

class _GalleryImageState extends State<GalleryImage> {
  List<GalleryItemModel> galleryItems = <GalleryItemModel>[];
  @override
  void initState() {
    _buildItemsList(widget.imageUrls, widget.imageIds);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return galleryItems.isEmpty
        ? const EmptyWidget()
        : GridView.builder(
            primary: false,
            itemCount: galleryItems.length > 3
                ? widget.numOfShowImages
                : galleryItems.length,
            padding: widget.padding,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: widget.childAspectRatio,
              crossAxisCount: widget.crossAxisCount,
              mainAxisSpacing: widget.mainAxisSpacing,
              crossAxisSpacing: widget.crossAxisSpacing,
            ),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return _isLastItem(index)
                  ? _buildImageNumbers(index)
                  : GalleryItemThumbnail(
                      galleryItem: galleryItems[index],
                      onTap: () {
                        _openImageFullScreen(index);
                      },
                      loadingWidget: widget.loadingWidget,
                      errorWidget: widget.errorWidget,
                      radius: widget.imageRadius,
                      headers: widget.headers,
                    );
            });
  }

// build image with number for other images
  Widget _buildImageNumbers(int index) {
    return GestureDetector(
      onTap: () {
        _openImageFullScreen(index);
      },
      child: Stack(
        alignment: AlignmentDirectional.center,
        fit: StackFit.expand,
        children: <Widget>[
          GalleryItemThumbnail(
            galleryItem: galleryItems[index],
            loadingWidget: widget.loadingWidget,
            errorWidget: widget.errorWidget,
            onTap: null,
            radius: widget.imageRadius,
            headers: widget.headers,
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(widget.imageRadius)),
            child: ColoredBox(
              color: widget.colorOfNumberWidget ?? Colors.black.withOpacity(.7),
              child: Center(
                child: Text(
                  "+${galleryItems.length - index}",
                  style: widget.textStyleOfNumberWidget ??
                      const TextStyle(color: Colors.white, fontSize: 40),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// Check if item is last image in grid to view image or number
  bool _isLastItem(int index) {
    return index < galleryItems.length - 1 &&
        index == widget.numOfShowImages - 1;
  }

// to open gallery image in full screen
  Future<void> _openImageFullScreen(int indexOfImage) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryImageViewWrapper(
          titleGallery: widget.titleGallery,
          galleryItems: galleryItems,
          backgroundColor: widget.galleryBackgroundColor,
          initialIndex: indexOfImage,
          loadingWidget: widget.loadingWidget,
          errorWidget: widget.errorWidget,
          maxScale: widget.maxScale,
          minScale: widget.minScale,
          reverse: widget.reverse,
          showListInGalley: widget.showListInGalley,
          showAppBar: widget.showAppBar,
          closeWhenSwipeUp: widget.closeWhenSwipeUp,
          closeWhenSwipeDown: widget.closeWhenSwipeDown,
          radius: widget.imageRadius,
          headers: widget.headers,
          removePhoto: (context, imageId) async {
            final removed = await widget.removePhoto(context, imageId);
            if (!removed) return false;
            final index = widget.imageIds.indexOf(imageId);
            final newUrls = [...widget.imageUrls];
            newUrls.removeAt(index);
            final newIds = [...widget.imageIds];
            newIds.removeAt(index);
            _buildItemsList(newUrls, newIds);
            return removed;
          },
          setAvatar: widget.setAvatar,
          avatarImageId: widget.avatarImageId,
        ),
      ),
    );
  }

// clear and build list
  void _buildItemsList(List<String> items, List<String> ids) {
    galleryItems.clear();
    for (var i = 0; i < items.length; i++) {
      galleryItems.add(GalleryItemModel(
        id: items[i],
        imageUrl: items[i],
        index: i,
        backendId: ids[i],
      ));
    }
  }
}
