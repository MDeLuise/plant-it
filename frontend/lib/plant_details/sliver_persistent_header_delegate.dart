import 'package:flutter/material.dart';

class PlantDetailsPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  PlantDetailsPersistentHeaderDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(PlantDetailsPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
