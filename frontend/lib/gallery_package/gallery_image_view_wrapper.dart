import 'package:flutter/material.dart';
import 'package:plant_it/gallery_package/app_cached_network_image.dart';

import 'gallery_item_model.dart';

// to view image in full screen
class GalleryImageViewWrapper extends StatefulWidget {
  final Color? backgroundColor;
  final int? initialIndex;
  final List<GalleryItemModel> galleryItems;
  final String? titleGallery;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final double minScale;
  final double maxScale;
  final double radius;
  final bool reverse;
  final bool showListInGalley;
  final bool showAppBar;
  final bool closeWhenSwipeUp;
  final bool closeWhenSwipeDown;
  final Map<String, String>? headers;
  final Future<bool> Function(BuildContext context, String imageId) removePhoto;
  final Future<bool> Function(String imageId) setAvatar;
  final String? avatarImageId;

  const GalleryImageViewWrapper({
    Key? key,
    required this.titleGallery,
    required this.backgroundColor,
    required this.initialIndex,
    required this.galleryItems,
    required this.loadingWidget,
    required this.errorWidget,
    required this.minScale,
    required this.maxScale,
    required this.radius,
    required this.reverse,
    required this.showListInGalley,
    required this.showAppBar,
    required this.closeWhenSwipeUp,
    required this.closeWhenSwipeDown,
    required this.headers,
    required this.removePhoto,
    required this.setAvatar,
    required this.avatarImageId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GalleryImageViewWrapperState();
  }
}

class _GalleryImageViewWrapperState extends State<GalleryImageViewWrapper> {
  late final PageController _controller =
      PageController(initialPage: widget.initialIndex ?? 0);
  int _currentPage = 0;
  late List<GalleryItemModel> _galleryItems;
  String? _updatedAvatarImageId;

  @override
  void initState() {
    _currentPage = 0;
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page?.toInt() ?? 0;
      });
    });
    _galleryItems = widget.galleryItems;
    _updatedAvatarImageId = widget.avatarImageId;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: Text(widget.titleGallery ?? "Gallery"),
            )
          : null,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              final int? index = _controller.page?.toInt();
              if (index == null) return;
              final String toRemove = widget.galleryItems[index].backendId;
              final removed = await widget.removePhoto(
                context,
                toRemove,
              );
              if (!removed) return;
              final newGalleryItems =
                  _galleryItems.where((p) => p.backendId != toRemove).toList();
              setState(() {
                _galleryItems = newGalleryItems;
              });
              if (_galleryItems.length == 0) {
                Navigator.of(context).pop();
              }
            },
            child: Icon(
              Icons.delete_forever_outlined,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          _DynamicSetAvatarFab(
            currentPageIndex: _currentPage,
            galleryItems: _galleryItems,
            avatarImageId: _updatedAvatarImageId,
            onPressed: (imageId) async {
              final bool updated = await widget.setAvatar(imageId);
              if (updated) {
                String? newAvatarImageId;
                if (imageId != _updatedAvatarImageId) {
                  newAvatarImageId = imageId;
                }
                setState(() {
                  _updatedAvatarImageId = newAvatarImageId;
                });
              }
            },
          ),
          SizedBox(
            height: 40,
          )
        ],
      ),
      backgroundColor: widget.backgroundColor,
      body: SafeArea(
        child: Container(
          constraints:
              BoxConstraints.expand(height: MediaQuery.of(context).size.height),
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onVerticalDragEnd: (details) {
                    if (widget.closeWhenSwipeUp &&
                        details.primaryVelocity! < 0) {
                      //'up'
                      Navigator.of(context).pop();
                    }
                    if (widget.closeWhenSwipeDown &&
                        details.primaryVelocity! > 0) {
                      // 'down'
                      Navigator.of(context).pop();
                    }
                  },
                  child: PageView.builder(
                    reverse: widget.reverse,
                    controller: _controller,
                    itemCount: widget.galleryItems.length,
                    itemBuilder: (context, index) =>
                        _buildImage(widget.galleryItems[index]),
                  ),
                ),
              ),
              if (widget.showListInGalley)
                SizedBox(
                  height: 80,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: widget.galleryItems
                          .map((e) => _buildLitImage(e))
                          .toList(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

// build image with zooming
  Widget _buildImage(GalleryItemModel item) {
    return Hero(
      tag: item.id,
      child: InteractiveViewer(
        minScale: widget.minScale,
        maxScale: widget.maxScale,
        child: Center(
          child: AppCachedNetworkImage(
            imageUrl: item.imageUrl,
            headers: widget.headers,
            loadingWidget: widget.loadingWidget,
            errorWidget: widget.errorWidget,
            radius: widget.radius,
          ),
        ),
      ),
    );
  }

// build image with zooming
  Widget _buildLitImage(GalleryItemModel item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _controller.jumpToPage(item.index);
          });
        },
        child: AppCachedNetworkImage(
          height: _currentPage == item.index ? 70 : 60,
          width: _currentPage == item.index ? 70 : 60,
          fit: BoxFit.cover,
          imageUrl: item.imageUrl,
          errorWidget: widget.errorWidget,
          radius: widget.radius,
          loadingWidget: widget.loadingWidget,
        ),
      ),
    );
  }
}

class _DynamicSetAvatarFab extends StatefulWidget {
  final int currentPageIndex;
  final List<GalleryItemModel> galleryItems;
  final String? avatarImageId;
  final Function(String) onPressed;

  const _DynamicSetAvatarFab({
    Key? key,
    required this.currentPageIndex,
    required this.galleryItems,
    required this.avatarImageId,
    required this.onPressed,
  }) : super(key: key);

  @override
  _DynamicSetAvatarFabState createState() => _DynamicSetAvatarFabState();
}

class _DynamicSetAvatarFabState extends State<_DynamicSetAvatarFab> {
  IconData getIconData() {
    final currentImageId =
        widget.galleryItems[widget.currentPageIndex].backendId;
    return currentImageId == widget.avatarImageId
        ? Icons.account_circle
        : Icons.account_circle_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        widget
            .onPressed(widget.galleryItems[widget.currentPageIndex].backendId);
      },
      child: Icon(getIconData()),
    );
  }
}
